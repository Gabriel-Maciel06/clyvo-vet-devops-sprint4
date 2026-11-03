#!/usr/bin/env bash
# ==============================================================================
# Utilitário rápido para rodar o SELECT diretamente no PostgreSQL em Nuvem (Azure)
# Uso: ./scripts/devops/select-banco-nuvem.sh
# ==============================================================================
set -euo pipefail

echo "=================================================================="
echo "📊 CONSULTANDO TABELA T_PET NO POSTGRESQL EM NUVEM (AZURE ACI)"
echo "   Host: pg-clyvo-db-rm562795.canadacentral.azurecontainer.io:5432"
echo "=================================================================="
az container exec \
  --resource-group "rg-clyvo-sprint4" \
  --name "pg-clyvo-vet-rm562795" \
  --exec-command "psql -U clyvoadmin -d clyvodb -c SELECT/**/id,nome,data_nascimento,peso,escore_saude,raca_id,tutor_cpf/**/FROM/**/t_pet/**/ORDER/**/BY/**/id;"
