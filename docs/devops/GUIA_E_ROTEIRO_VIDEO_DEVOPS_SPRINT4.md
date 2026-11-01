# 🎬 Guia de Configuração Azure DevOps & Roteiro Oficial do Vídeo (80 Pontos)
**Disciplina:** DevOps Tools & Cloud Computing — 4ª Sprint (FIAP 2026)  
**Projeto:** `Sprint 4 – Azure DevOps` — **Clyvo Vet Web v2 (Java Advanced + PostgreSQL Cloud)**  
**Professor:** Prof. João Menk (`profjoao.menk@fiap.com.br`)  
**Turma:** `2TDSR`

---

## 🛠️ PARTE 1: Preparação Rápida Antes de Gravar (10 Minutos)

### Passo 1 — Provisionar os Recursos na Azure (1 Comando)
No terminal, autentique na Azure e rode o script automatizado:
```bash
az login
./scripts/devops/provision-azure-webapp-postgres.sh
```
O script criará automaticamente no Resource Group `rg-clyvo-sprint4`:
1. **Banco de Dados PostgreSQL 16 em Nuvem** (`pg-clyvo-vet-rm562795`) com IP/FQDN público na porta `5432`.
2. **App Service Plan Linux (`B1`) + Azure Web App Java 21 (`app-clyvo-vet-rm562795`)**.
3. Ao final, o terminal exibirá os valores exatos de `DB_URL`, `DB_USER`, `DB_PASSWORD`, `AZURE_WEBAPP_NAME` e `AZURE_RESOURCE_GROUP`.

---

### Passo 2 — Criar o Projeto no Azure DevOps (Regra 4 do Slide 2)
Acesse [https://dev.azure.com](https://dev.azure.com) e clique em **New project** preenchendo **exatamente**:
- **Project name:** `Sprint 4 – Azure DevOps`
- **Description:** *(copie e cole o bloco abaixo)*
  ```text
  Projeto para entrega da Sprint 4 do professor João Menk
  RM562795 - Gabriel Maciel Alves de Oliveira - 2TDSR
  RM565160 - Vitória Rodrigues Martins - 2TDSR
  RM565155 - Augusto Bonomo Júnior - 2TDSR
  RM562254 - Thomas Fontes - 2TDSR
  RM563399 - Matheus Pereira Molina - 2TDSR
  ```
- **Visibility:** `Private`
- **Version control:** `Git`
- **Work item process:** `Scrum` (ou `Agile`)

---

### Passo 3 — Convidar o Professor com Acesso "Basic" (CRÍTICO — Evita Nota Zero!)
> ⚠️ **ATENÇÃO (Slide 6):** *"Se o professor não for convidado para o projeto e não tiver o acesso Basic não irá conseguir acessar o projeto, Repos ou a pipeline - A avaliação será zerada."*

1. No menu raiz da sua Organização no Azure DevOps (canto inferior esquerdo), clique em **Organization settings** $\rightarrow$ **Users** $\rightarrow$ **Add users**.
2. Em **Users**, digite o e-mail do professor: `profjoao.menk@fiap.com.br`
3. Em **Access level**, selecione obrigatoriamente **`Basic`** *(NUNCA deixe como Stakeholder!)*.
4. Marque **Add to projects** $\rightarrow$ selecione `Sprint 4 – Azure DevOps` $\rightarrow$ grupo **Project Administrators** (ou **Contributors**) $\rightarrow$ clique em **Add**.

---

### Passo 4 — Criar a Service Connection e as Variáveis Protegidas (Regra IV — Evita -15 pts)
1. **Service Connection com a Azure:**
   - No projeto `Sprint 4 – Azure DevOps`, vá em **Project settings** $\rightarrow$ **Service connections** $\rightarrow$ **New service connection** $\rightarrow$ **Azure Resource Manager** $\rightarrow$ **Service principal (automatic)**.
   - Selecione sua assinatura Azure, Resource Group `rg-clyvo-sprint4`, dê o nome **`azure-sprint4-connection`** e marque *Grant access permission to all pipelines*.
2. **Variable Group com Cadeado (`clyvo-sprint4-secrets`):**
   - Vá em **Pipelines** $\rightarrow$ **Library** $\rightarrow$ **+ Variable group**.
   - **Variable group name:** `clyvo-sprint4-secrets`
   - Adicione as variáveis abaixo e **clique no ícone de cadeado 🔒** nas variáveis sensíveis:

| Nome da Variável | Valor | Cadeado 🔒 (Secret) |
| :--- | :--- | :---: |
| `AZURE_SERVICE_CONNECTION` | `azure-sprint4-connection` | Aberto |
| `AZURE_RESOURCE_GROUP` | `rg-clyvo-sprint4` | Aberto |
| `AZURE_WEBAPP_NAME` | `app-clyvo-vet-rm562795` | Aberto |
| `DB_URL` | `jdbc:postgresql://pg-clyvo-db-rm562795.eastus.azurecontainer.io:5432/clyvodb` | **🔒 Trancado** |
| `DB_USER` | `clyvoadmin` | **🔒 Trancado** |
| `DB_PASSWORD` | `Clyvo@Fiap2026!` | **🔒 Trancado** |

3. Clique em **Save** e em **Pipeline permissions** $\rightarrow$ autorize todas as pipelines.

---

### Passo 5 — Conectar a Pipeline (`azure-pipelines.yml`) na Branch `master`
1. Vá em **Pipelines** $\rightarrow$ **Create Pipeline** $\rightarrow$ selecione **GitHub** (ou **Azure Repos Git**, caso tenha importado o repositório `https://github.com/Gabriel-Maciel06/clyvo-vet-web-v2.git` em *Repos*).
2. Selecione o repositório `clyvo-vet-web-v2` $\rightarrow$ **Existing Azure Pipelines YAML file** $\rightarrow$ branch `master` $\rightarrow$ path `/azure-pipelines.yml`.
3. Clique em **Save** (ou **Run** uma primeira vez antes de gravar para já deixar o cache aquecido e validar que ficou tudo verde!).

---

## 🎥 PARTE 2: Roteiro Passo a Passo para Gravação do Vídeo (Vale 80 Pontos)

### 📋 Deixe estas 5 janelas/abas abertas antes de apertar REC:
1. **Aba 1 (Navegador):** Repositório GitHub / Azure DevOps com o `README.md` e o Diagrama de Arquitetura (`docs/devops/arquitetura-cicd-sprint4.png`).
2. **Aba 2 (Navegador):** Azure DevOps (`Sprint 4 – Azure DevOps`) nas abas **Project Settings (Users/Permissions)**, **Pipelines > Library (`clyvo-sprint4-secrets`)** e **Pipelines**.
3. **Aba 3 (Navegador):** **Portal do Azure** (`rg-clyvo-sprint4`) mostrando o **Azure Web App (`app-clyvo-vet-rm562795`)** e o **Banco de Dados PostgreSQL (`pg-clyvo-vet-rm562795`)**.
4. **Aba 4 (Navegador):** A aplicação aberta na URL pública da Azure (`https://app-clyvo-vet-rm562795.azurewebsites.net/login`). *(Zero localhost!)*
5. **Janela 5 (IDE + Cliente SQL):** VS Code / IntelliJ com o código aberto + **DBeaver / Azure Data Studio / Terminal `psql`** conectado ao PostgreSQL da Azure com o arquivo [`docs/devops/EVIDENCIAS_CRUD_BANCO_NUVEM.sql`](EVIDENCIAS_CRUD_BANCO_NUVEM.sql) aberto.

---

### ⏱️ Bloco 1 — Apresentação da Solução, Diagrama CI/CD e Configuração do Azure DevOps (00:00 – 02:30)
1. **Mostre o `README.md` e o Diagrama (`docs/devops/arquitetura-cicd-sprint4.png`):**
   - **Fala sugerida:**
     > *"Olá professor João Menk! Apresentamos a entrega da 4ª Sprint de DevOps Tools & Cloud Computing integrada com nossa aplicação de Java Advanced: o **Clyvo Vet Web v2**, uma plataforma HealthTech de medicina veterinária preventiva desenvolvida em Java 21, Spring Boot 3.3.4, Spring Security 6, Flyway e PostgreSQL em nuvem."*
   - Aponte o mouse para o **Diagrama de Arquitetura + Fluxo CI/CD**:
     > *"Neste diagrama apresentamos as personas (Desenvolvedor, Usuário Final e Professor Avaliador), todas as ferramentas da stack e o fluxo numerado de 1 a 10 da nossa esteira CI/CD no Azure DevOps até o deploy no Azure Web App e persistência no PostgreSQL em nuvem."*
2. **Mostre a configuração do Projeto no Azure DevOps:**
   - Mostre o nome do projeto **`Sprint 4 – Azure DevOps`**, a descrição com o nome do professor e os RMs da turma `2TDSR`, visibilidade **Private**, **Git** e processo **Scrum**.
   - Abra **Organization Settings > Users** (ou **Project Settings > Permissions**) e mostre que o professor foi convidado com nível de acesso **`Basic`**.

---

### ⏱️ Bloco 2 — Explicação da Pipeline YAML e Variáveis Protegidas (02:30 – 04:30)
1. **Mostre as Variáveis Protegidas com Cadeado (`Pipelines > Library > clyvo-sprint4-secrets`):**
   - **Fala sugerida:**
     > *"Atendendo à Regra IV de segurança, armazenamos todos os dados sensíveis (URL do banco, usuário e senha do PostgreSQL em nuvem) no Variable Group `clyvo-sprint4-secrets` marcados como Secret Variables com cadeado, garantindo que nenhuma credencial fique exposta no código ou nos logs."*
2. **Abra o arquivo `azure-pipelines.yml` no Azure DevOps / IDE e explique cada Stage e Task:**
   - **Fala sugerida:**
     > *"Nossa pipeline YAML possui trigger automático na branch `master` e está dividida em 2 Stages:*
     > *- No **Stage 1 (CI)**, o job faz o checkout do código, instala o JDK 21 (`JavaToolInstaller@0`), executa o build e os **113 testes automatizados JUnit 5** (`mvn clean test`) publicando o relatório de testes no Azure DevOps, empacota o `.jar` executável (`mvn package`) e publica o artefato `drop` via `PublishBuildArtifacts@1`.*
     > *- No **Stage 2 (CD)**, que depende do sucesso do CI e dispara automaticamente após o novo artefato ser gerado, fazemos o download do artefato `drop`, injetamos as variáveis protegidas do Variable Group e realizamos o deploy automático no **Azure Web App Linux Java 21** via task `AzureWebApp@1`."*

---

### ⏱️ Bloco 3 — Alteração Visual no Código + Commit na Branch `master` + Disparo Automático (04:30 – 08:00)
> ⚠️ **REGRA CRÍTICA (Slide 7):** **NÃO altere o README.md** (alterar README desconta `-20 pontos`). Altere um elemento visual de código na tela da aplicação!

1. **Mostre a tela de Login atual na URL da Azure (`https://app-clyvo-vet-rm562795.azurewebsites.net/login`):**
   - Aponte para o título ou rodapé atual.
2. **Vá na IDE (VS Code / IntelliJ) e abra [`src/main/resources/templates/login.html`](../../src/main/resources/templates/login.html):**
   - Na linha do subtítulo da marca (`<p class="brand-subtitle">` ou título de boas-vindas), adicione um selo visível, por exemplo:
     ```html
     <span class="badge bg-success mb-2">Deploy Automático Azure CI/CD — Sprint 4 (2TDSR)</span>
     ```
   - *(Ou altere o texto do rodapé em [`src/main/resources/templates/fragments/layout.html`](../../src/main/resources/templates/fragments/layout.html) de `(FIAP 4º Sprint — Entrega Final)` para `(FIAP 4º Sprint — Deploy Azure CI/CD Ativo)`).*
3. **No terminal da IDE, faça o commit e o push para a branch `master`:**
   ```bash
   git add src/main/resources/templates/login.html
   git commit -m "feat(ui): selo visual de deploy automatico Azure CI/CD Sprint 4"
   git push origin master
   ```
4. **Volte imediatamente para a aba `Pipelines` no Azure DevOps:**
   - Mostre que a pipeline **iniciou sozinha automaticamente** após o push na `master`!
   - **Clique na execução em andamento e abra os logs em tempo real (Obrigatório explicar cada etapa durante a execução — vale 20 pontos):**
     - Comente enquanto roda: *"Aqui vemos o passo 1 fazendo checkout do commit que acabamos de enviar; o passo 2 configurando o Java 21; o passo 4 compilando o projeto e executando os 113 testes unitários e de integração com JUnit 5 e MockMvc; o passo 5 gerando o artefato `.jar`; e o passo 7 publicando o artefato `drop` no Azure DevOps."*
   - Quando o **Stage 1 (CI)** terminar, clique no resumo da execução e mostre:
     1. A aba **Tests** com **113/113 testes aprovados (100% pass)**.
     2. O link **1 published** mostrando o artefato **`drop` (`clyvo-vet-web-v2-0.0.1-SNAPSHOT.jar`)** publicado no Azure DevOps.
   - Em seguida, abra o **Stage 2 (CD)** em execução e explique:
     - *"Assim que o artefato foi publicado, o Stage de CD iniciou automaticamente, baixou o artefato `drop` e agora a task `AzureWebApp@1` está enviando a nova versão para o nosso Azure Web App e reiniciando o serviço conectado ao PostgreSQL em nuvem."*

---

### ⏱️ Bloco 4 — Portal do Azure + Verificação da Alteração no Ar (08:00 – 09:30)
1. **Abra o Portal do Azure (`portal.azure.com`):**
   - Mostre o **Resource Group `rg-clyvo-sprint4`** com os recursos criados: o **Azure Web App (`app-clyvo-vet-rm562795`)** com status `Running` e o **Banco de Dados PostgreSQL em Nuvem (`pg-clyvo-vet-rm562795`)**.
   - Entre no **Azure Web App** $\rightarrow$ mostre a URL pública e o **Deployment Center / Activity Log** confirmando o deploy recém-aplicado pelo Azure Pipelines.
2. **Acesse a URL Pública da Aplicação no Navegador (`https://app-clyvo-vet-rm562795.azurewebsites.net/login`):**
   - Atualize a página (`F5`) e **destaque com o mouse a alteração visual no código** (`"Deploy Automático Azure CI/CD — Sprint 4 (2TDSR)"`) já rodando online na nuvem!

---

### ⏱️ Bloco 5 — Execução do CRUD Completo na Nuvem + Evidência com `SELECT` no Banco (09:30 – 13:00)
> ⚠️ **REGRA CRÍTICA (Slide 5 e Slide 7):** Para **cada** uma das 4 operações (Inserir, Consultar, Atualizar, Deletar), faça a ação na aplicação em nuvem e **imediatamente execute o `SELECT` dentro do banco de dados** (DBeaver / Azure Data Studio / `psql`) usando o arquivo [`docs/devops/EVIDENCIAS_CRUD_BANCO_NUVEM.sql`](EVIDENCIAS_CRUD_BANCO_NUVEM.sql).

1. **Login na Aplicação em Nuvem:**
   - Entre com `tutor` / `tutor123`.
2. **Operação 1 — CREATE (Inserir):**
   - Na aplicação web (na URL da Azure), vá em **Meus Pets** $\rightarrow$ **+ Cadastrar Novo Pet**.
   - Preencha: Nome = **`Apollo Cloud`**, Espécie = **`Canina`**, Raça = **`Golden Retriever`**, Sexo = **`Macho`**, Peso = **`18.5`**, Data de Nascimento = **`2023-05-10`** $\rightarrow$ clique em **Salvar Pet**.
   - **Vá imediatamente ao DBeaver / Cliente SQL conectado ao PostgreSQL na Azure e execute o `SELECT` de CREATE:**
     ```sql
     SELECT id, nome, especie, sexo, peso_atual_kg, data_nascimento
     FROM t_pet
     ORDER BY id DESC;
     ```
   - Aponte o mouse para a linha recém-inserida **`Apollo Cloud`** com peso **`18.5`** dentro do banco de dados!
3. **Operação 2 — READ (Consultar):**
   - Na aplicação web, filtre ou clique em **Ver Prontuário** do pet **`Apollo Cloud`** (`/pets/{id}`), mostrando os dados biométricos e protocolo de longevidade carregados do banco.
   - **Vá ao DBeaver / Cliente SQL e execute o `SELECT` de READ com `JOIN`:**
     ```sql
     SELECT p.id, p.nome AS nome_pet, r.nome AS raca, p.peso_atual_kg, t.nome AS tutor
     FROM t_pet p
     JOIN t_raca r ON r.id = p.raca_id
     JOIN t_tutor t ON t.id = p.tutor_id
     WHERE p.nome ILIKE '%Apollo%';
     ```
4. **Operação 3 — UPDATE (Atualizar):**
   - Na página de prontuário do **`Apollo Cloud`**, clique na aba **Editar Pet**.
   - Altere o Nome para **`Apollo Cloud Editado`** e o Peso de `18.5` para **`21.2`** $\rightarrow$ clique em **Salvar Alterações**.
   - **Vá imediatamente ao DBeaver / Cliente SQL e execute o `SELECT` de UPDATE:**
     ```sql
     SELECT id, nome, peso_atual_kg
     FROM t_pet
     ORDER BY id DESC
     LIMIT 3;
     ```
   - Aponte para o registro no banco mostrando que o nome mudou para **`Apollo Cloud Editado`** e o peso foi atualizado para **`21.20`**!
5. **Operação 4 — DELETE (Deletar):**
   - Volte na aba **Editar Pet** (ou na lista de Pets) e clique em **Excluir Pet** $\rightarrow$ confirme a exclusão do **`Apollo Cloud Editado`**.
   - **Vá imediatamente ao DBeaver / Cliente SQL e execute o `SELECT` de DELETE:**
     ```sql
     SELECT id, nome, especie, peso_atual_kg FROM t_pet ORDER BY id;
     SELECT COUNT(*) AS total_registros_apollo FROM t_pet WHERE nome ILIKE '%Apollo%';
     ```
   - Mostre que o registro foi removido da tabela `t_pet` e que o `COUNT(*)` retornou **`0`**, comprovando as 4 operações do CRUD persistidas no banco em nuvem!
