#!/usr/bin/env bash
# ==============================================================================
# FIAP — 4ª SPRINT: DEVOPS TOOLS & CLOUD COMPUTING
# Script de Provisionamento Automatizado: Azure Web App (Java 21) + PostgreSQL Cloud
# Projeto: Clyvo Vet Web v2 | Turma: 2TDSR (RM562795)
# ==============================================================================
set -euo pipefail

RESOURCE_GROUP="${AZURE_RESOURCE_GROUP:-rg-clyvo-sprint4}"
LOCATION="${AZURE_LOCATION:-eastus}"
SUFIXO="${SUFIXO_RM:-rm562795}"
APP_PLAN="plan-clyvo-sprint4-${SUFIXO}"
WEBAPP_NAME="app-clyvo-vet-${SUFIXO}"
PG_SERVER_NAME="pg-clyvo-vet-${SUFIXO}"
PG_DB_NAME="clyvodb"
PG_ADMIN_USER="clyvoadmin"
PG_ADMIN_PASS="${DB_PASSWORD:-Clyvo@Fiap2026!}"

echo "=================================================================="
echo "1. Criando Resource Group: ${RESOURCE_GROUP} (${LOCATION})"
echo "=================================================================="
az group create --name "${RESOURCE_GROUP}" --location "${LOCATION}" -o table

echo "=================================================================="
echo "2. Criando Banco de Dados em Nuvem (PostgreSQL Cloud Container em ACI)"
echo "   (100% compatível com Azure for Students e zero bloqueio de cota)"
echo "=================================================================="
PG_DNS_LABEL="pg-clyvo-db-${SUFIXO}"
az container create \
  --resource-group "${RESOURCE_GROUP}" \
  --name "${PG_SERVER_NAME}" \
  --image postgres:16-alpine \
  --os-type Linux \
  --cpu 1 --memory 1.5 \
  --ports 5432 \
  --ip-address Public \
  --dns-name-label "${PG_DNS_LABEL}" \
  --environment-variables \
    POSTGRES_DB="${PG_DB_NAME}" \
    POSTGRES_USER="${PG_ADMIN_USER}" \
  --secure-environment-variables \
    POSTGRES_PASSWORD="${PG_ADMIN_PASS}" \
  -o table

PG_FQDN=$(az container show --resource-group "${RESOURCE_GROUP}" --name "${PG_SERVER_NAME}" --query "ipAddress.fqdn" -o tsv)
DB_JDBC_URL="jdbc:postgresql://${PG_FQDN}:5432/${PG_DB_NAME}"

echo "=================================================================="
echo "3. Criando App Service Plan + Azure Web App (Linux Java 21 LTS)"
echo "=================================================================="
az appservice plan create \
  --name "${APP_PLAN}" \
  --resource-group "${RESOURCE_GROUP}" \
  --location "${LOCATION}" \
  --is-linux \
  --sku B1 \
  -o table

az webapp create \
  --name "${WEBAPP_NAME}" \
  --resource-group "${RESOURCE_GROUP}" \
  --plan "${APP_PLAN}" \
  --runtime "JAVA:21-java21" \
  -o table

echo "=================================================================="
echo "4. Configurando App Settings no Azure Web App"
echo "=================================================================="
az webapp config appsettings set \
  --name "${WEBAPP_NAME}" \
  --resource-group "${RESOURCE_GROUP}" \
  --settings \
    SPRING_PROFILES_ACTIVE="prod" \
    PORT="8080" \
    WEBSITES_PORT="8080" \
    DB_URL="${DB_JDBC_URL}" \
    DB_USER="${PG_ADMIN_USER}" \
    DB_PASSWORD="${PG_ADMIN_PASS}" \
    JAVA_OPTS="-Dserver.port=8080 -Xms256m -Xmx512m" \
  -o none

echo ""
echo "=================================================================="
echo "✅ INFRAESTRUTURA PROVISIONADA COM SUCESSO NA MICROSOFT AZURE!"
echo "=================================================================="
echo "Copie os valores abaixo para o Azure DevOps -> Pipelines -> Library"
echo "Variable Group: clyvo-sprint4-secrets (Marque o cadeado 🔒 nas senhas):"
echo "------------------------------------------------------------------"
echo "AZURE_RESOURCE_GROUP     = ${RESOURCE_GROUP}"
echo "AZURE_WEBAPP_NAME        = ${WEBAPP_NAME}"
echo "DB_URL                   = ${DB_JDBC_URL}   (🔒 Secret)"
echo "DB_USER                  = ${PG_ADMIN_USER} (🔒 Secret)"
echo "DB_PASSWORD              = ${PG_ADMIN_PASS} (🔒 Secret)"
echo "------------------------------------------------------------------"
echo "URL Pública do Web App   : https://${WEBAPP_NAME}.azurewebsites.net"
echo "Host do PostgreSQL Cloud : ${PG_FQDN} (Porta: 5432 | Banco: ${PG_DB_NAME})"
echo "=================================================================="
