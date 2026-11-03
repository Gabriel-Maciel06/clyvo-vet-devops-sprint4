#!/usr/bin/env bash
# ==============================================================================
# Utilitário para o Vídeo de DevOps: faz commit e push simultâneo para o GitHub
# e para o Azure Repos (branch master), disparando o CI/CD automaticamente!
# Uso: ./scripts/devops/push-devops-video.sh "feat(ui): selo de deploy CI/CD Azure Sprint 4"
# ==============================================================================
set -euo pipefail

MSG="${1:-feat(ui): atualizacao visual demonstracao CI/CD Azure Sprint 4}"

git add -A
git commit -m "${MSG}"
git push origin main
git push origin main:master

ADO_TOKEN=$(az account get-access-token --resource 499b84ac-1321-427f-aa17-267ca6975798 --query accessToken -o tsv)
git push "https://x-access-token:${ADO_TOKEN}@dev.azure.com/RM565155/PawCare/_git/PawCare" main:master main:main

echo "=================================================================="
echo "✅ Commit enviado para a branch 'master' no Azure DevOps e GitHub!"
echo "🚀 A pipeline 'Clyvo-Vet-Sprint4-CI-CD' já foi disparada automaticamente!"
echo "   Abra: https://dev.azure.com/RM565155/PawCare/_build"
echo "=================================================================="
