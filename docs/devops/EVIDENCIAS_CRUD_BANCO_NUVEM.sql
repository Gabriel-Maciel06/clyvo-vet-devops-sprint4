-- ==============================================================================
-- FIAP — 4ª SPRINT: DEVOPS TOOLS & CLOUD COMPUTING
-- SCRIPT DE EVIDÊNCIA DE PERSISTÊNCIA DO CRUD NO BANCO EM NUVEM (POSTGRESQL)
-- ==============================================================================
-- REGRA DO EDITAL (Slide 5 e Slide 7):
-- "Acesse a aplicação no Web App ou ACI e execute o CRUD completo, mostrando no
--  banco cada operação (inserir, consultar, atualizar, deletar). As evidências
--  de persistência devem ser efetuadas através de SELECT dentro do Banco."
-- (Sem evidência clara de cada operação CRUD no banco de dados: -30 pontos)
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- PASSO 0: VERIFICAR TABELAS CRIADAS PELO FLYWAY NA NUVEM (15 TABELAS EM 3FN)
-- ------------------------------------------------------------------------------
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

-- Verificar histórico de migrações Flyway aplicadas automaticamente no deploy:
SELECT installed_rank, version, description, type, installed_on, success
FROM flyway_schema_history
ORDER BY installed_rank;

-- ------------------------------------------------------------------------------
-- PASSO 1: EVIDÊNCIA ANTES DO CRUD (ESTADO INICIAL DA TABELA T_PET E T_TUTOR)
-- ------------------------------------------------------------------------------
SELECT p.id,
       p.nome AS nome_pet,
       p.especie,
       p.peso_atual_kg,
       r.nome AS raca,
       t.nome AS tutor_responsavel
FROM t_pet p
JOIN t_raca r ON r.id = p.raca_id
JOIN t_tutor t ON t.id = p.tutor_id
ORDER BY p.id;

-- ------------------------------------------------------------------------------
-- PASSO 2: EVIDÊNCIA DE INSERÇÃO (CREATE)
-- Ação na Aplicação Web (Azure): Logado como 'tutor' (senha: tutor123),
-- acesse "Meus Pets" -> "+ Cadastrar Novo Pet" e cadastre:
-- Nome: "Apollo Cloud" | Espécie: Canina | Peso: 18.5 kg | Sexo: Macho
-- Em seguida, execute este SELECT no banco em nuvem para provar o INSERT:
-- ------------------------------------------------------------------------------
SELECT p.id,
       p.nome AS nome_pet,
       p.especie,
       p.sexo,
       p.peso_atual_kg,
       p.data_nascimento,
       t.nome AS tutor_responsavel
FROM t_pet p
JOIN t_tutor t ON t.id = p.tutor_id
ORDER BY p.id DESC;

-- ------------------------------------------------------------------------------
-- PASSO 3: EVIDÊNCIA DE CONSULTA (READ) E DETALHAMENTO CLÍNICO
-- Ação na Aplicação Web (Azure): Clique em "Ver Prontuário" do pet "Apollo Cloud".
-- Em seguida, execute este SELECT relacionando Tutor, Pet, Raça e Histórico:
-- ------------------------------------------------------------------------------
SELECT p.id AS pet_id,
       p.nome AS nome_pet,
       r.nome AS raca,
       r.expectativa_vida_anos,
       p.peso_atual_kg,
       t.nome AS tutor,
       t.email AS email_tutor
FROM t_pet p
JOIN t_raca r ON r.id = p.raca_id
JOIN t_tutor t ON t.id = p.tutor_id
WHERE p.nome ILIKE '%Apollo%';

-- ------------------------------------------------------------------------------
-- PASSO 4: EVIDÊNCIA DE ATUALIZAÇÃO (UPDATE)
-- Ação na Aplicação Web (Azure): Dentro do Prontuário do "Apollo Cloud",
-- clique na aba "Editar Pet", altere o peso de 18.5 para 21.2 kg e o nome para
-- "Apollo Cloud Atualizado", e clique em "Salvar Alterações".
-- Em seguida, execute este SELECT no banco para provar o UPDATE:
-- ------------------------------------------------------------------------------
SELECT id,
       nome AS nome_atualizado,
       peso_atual_kg AS novo_peso_kg,
       castrado,
       observacoes_clinicas
FROM t_pet
ORDER BY id DESC
LIMIT 3;

-- Verificar também o registro automático gerado na timeline clínica após o UPDATE de peso:
SELECT id, pet_id, tipo_evento, titulo, descricao, data_registro
FROM t_historico_clinico
ORDER BY id DESC
LIMIT 5;

-- ------------------------------------------------------------------------------
-- PASSO 5: EVIDÊNCIA DE EXCLUSÃO (DELETE)
-- Ação na Aplicação Web (Azure): Na aba "Editar Pet" (Zona de Perigo) ou na
-- listagem de Pets, clique em "Excluir Pet" para remover o "Apollo Cloud Atualizado".
-- Em seguida, execute este SELECT no banco para provar que o registro foi removido:
-- ------------------------------------------------------------------------------
SELECT id, nome, especie, peso_atual_kg
FROM t_pet
ORDER BY id;

-- Confirmar com COUNT = 0 que o pet excluído não existe mais no banco:
SELECT COUNT(*) AS total_registros_apollo
FROM t_pet
WHERE nome ILIKE '%Apollo%';
