# ---------------------------------------------------------------------------
# Imagem de produção do Clyvo Vet.
#
# Build em dois estágios: o primeiro compila com Maven e o segundo carrega
# apenas o JRE e o jar. A imagem final não leva Maven, código-fonte nem cache
# do build, o que reduz bastante o tamanho e a superfície exposta.
# ---------------------------------------------------------------------------

# ---- Estágio 1: build ----
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /build

# As dependências mudam muito menos que o código. Copiando só o pom primeiro,
# o cache desta camada sobrevive a alterações em src/ e o rebuild fica rápido.
COPY pom.xml .
RUN mvn -B -q dependency:go-offline

COPY src ./src
# Os testes rodam no pipeline e na máquina do desenvolvedor; repeti-los aqui só
# alongaria o deploy.
RUN mvn -B -q clean package -DskipTests

# ---- Estágio 2: runtime ----
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Processo sem privilégio de root: se a aplicação for comprometida, o atacante
# não herda administrador do contêiner.
RUN addgroup -S clyvo && adduser -S clyvo -G clyvo
COPY --from=build /build/target/*.jar app.jar
RUN chown clyvo:clyvo app.jar
USER clyvo

# A maioria das plataformas injeta a porta em PORT; o padrão cobre execução local.
ENV PORT=8095
EXPOSE 8095

# Limite de memória proporcional ao contêiner, em vez do padrão da JVM, que
# costuma estourar nos planos gratuitos.
ENV JAVA_OPTS="-XX:MaxRAMPercentage=75 -XX:+UseSerialGC"

ENTRYPOINT ["sh", "-c", "exec java $JAVA_OPTS -jar app.jar"]
