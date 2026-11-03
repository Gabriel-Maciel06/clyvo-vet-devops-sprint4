-- ==============================================================================
-- FIAP — 4ª SPRINT: DEVOPS TOOLS & CLOUD COMPUTING
-- SCRIPT DE EVIDÊNCIA DE PERSISTÊNCIA DO CRUD NO BANCO EM NUVEM (POSTGRESQL)
-- ==============================================================================
-- DADOS DE CONEXÃO DO BANCO EM NUVEM (DBeaver / Azure Data Studio / psql):
-- Host     : pg-clyvo-db-rm562795.canadacentral.azurecontainer.io (ou 130.107.16.110)
-- Porta    : 5432
-- Database : clyvodb
-- Username : clyvoadmin
-- Password : Clyvo@Fiap2026!
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
       p.data_nascimento,
       p.peso,
       p.escore_saude,
       r.nome AS raca,
       r.especie,
       t.nome AS tutor_responsavel,
       p.tutor_cpf
FROM t_pet p
JOIN t_raca r ON r.id = p.raca_id
JOIN t_tutor t ON t.cpf = p.tutor_cpf
ORDER BY p.id;

-- ------------------------------------------------------------------------------
-- PASSO 2: EVIDÊNCIA DE INSERÇÃO (CREATE)
-- Ação na Aplicação Web (https://app-clyvo-vet-rm562795.azurewebsites.net):
-- Logado como 'tutor' (senha: tutor123), acesse "Meus Pets" -> "+ Novo Pet"
-- e cadastre: Nome: "Apollo Cloud" | Espécie: Canina | Raça: Golden Retriever |
-- Peso: 28.5 kg | Data de Nascimento: 2023-05-10
-- Em seguida, execute este SELECT no banco em nuvem para provar o INSERT:
-- ------------------------------------------------------------------------------
SELECT id,
       nome,
       data_nascimento,
       peso,
       escore_saude,
       status_longevidade,
       raca_id,
       tutor_cpf
FROM t_pet
ORDER BY id DESC;

-- ------------------------------------------------------------------------------
-- PASSO 3: EVIDÊNCIA DE CONSULTA (READ) E DETALHAMENTO CLÍNICO
-- Ação na Aplicação Web: Clique no Prontuário do pet "Apollo Cloud".
-- Em seguida, execute este SELECT relacionando Tutor, Pet e Raça:
-- ------------------------------------------------------------------------------
SELECT p.id AS pet_id,
       p.nome AS nome_pet,
       r.nome AS raca,
       r.especie,
       p.peso,
       p.escore_saude,
       t.nome AS tutor,
       t.email AS email_tutor
FROM t_pet p
JOIN t_raca r ON r.id = p.raca_id
JOIN t_tutor t ON t.cpf = p.tutor_cpf
WHERE p.nome ILIKE '%Apollo%';

-- ------------------------------------------------------------------------------
-- PASSO 4: EVIDÊNCIA DE ATUALIZAÇÃO (UPDATE)
-- Ação na Aplicação Web: Dentro do Prontuário do "Apollo Cloud", clique na aba
-- "Editar Pet", altere o peso de 28.5 para 30.2 kg e o nome para
-- "Apollo Cloud Editado", e clique em "Salvar Alterações".
-- Em seguida, execute este SELECT no banco para provar o UPDATE:
-- ------------------------------------------------------------------------------
SELECT id,
       nome AS nome_atualizado,
       peso AS novo_peso_kg,
       escore_saude,
       status_longevidade
FROM t_pet
ORDER BY id DESC;

-- ------------------------------------------------------------------------------
-- PASSO 5: EVIDÊNCIA DE EXCLUSÃO (DELETE)
-- Ação na Aplicação Web: Na aba "Editar Pet" (Zona de Perigo), clique em
-- "Excluir Pet" para remover o "Apollo Cloud Editado".
-- Em seguida, execute este SELECT no banco para provar que o registro foi removido:
-- ------------------------------------------------------------------------------
SELECT id, nome, data_nascimento, peso, escore_saude, tutor_cpf
FROM t_pet
ORDER BY id;

-- Confirmar com COUNT = 0 que o pet excluído não existe mais no banco:
SELECT COUNT(*) AS total_registros_apollo
FROM t_pet
WHERE nome ILIKE '%Apollo%';
