#!/usr/bin/env bash
# ==============================================================================
# Utilitário para o Vídeo de DevOps: faz commit e push para a branch 'master'
# no GitHub (conectada via webhook oficial à pipeline Clyvo-Vet-Sprint4-CI-CD
# em https://dev.azure.com/RM565155/PawCare), disparando o CI/CD automaticamente!
# Uso: ./scripts/devops/push-devops-video.sh "feat(ui): selo de deploy CI/CD Azure Sprint 4"
# ==============================================================================
set -euo pipefail

MSG="${1:-feat(ui): atualizacao visual demonstracao CI/CD Azure Sprint 4}"

git add -A
git commit -m "${MSG}"
git push origin HEAD:master
git push origin HEAD:main

echo "=================================================================="
echo "✅ Commit enviado para a branch 'master' no GitHub!"
echo "🚀 A pipeline 'Clyvo-Vet-Sprint4-CI-CD' em RM565155/PawCare já foi disparada automaticamente!"
echo "   Abra: https://dev.azure.com/RM565155/PawCare/_build"
echo "=================================================================="
