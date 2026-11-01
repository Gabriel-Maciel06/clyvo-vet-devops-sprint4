#!/usr/bin/env bash
# ==============================================================================
# Script de Limpeza (Destruição do Resource Group após a correção da Sprint 4)
# ATENÇÃO: Só execute DEPOIS que o professor avaliar o projeto!
# ==============================================================================
set -euo pipefail

RESOURCE_GROUP="${AZURE_RESOURCE_GROUP:-rg-clyvo-sprint4}"
echo "Excluindo Resource Group ${RESOURCE_GROUP}..."
az group delete --name "${RESOURCE_GROUP}" --yes --no-wait
echo "Solicitação de exclusão enviada com sucesso."
