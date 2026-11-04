#!/usr/bin/env bash
# ==============================================================================
# Utilitário para o Vídeo de DevOps: faz commit e push para a branch 'master'
# no GitHub (conectada via webhook oficial à pipeline Clyvo-Vet-Sprint4-CI-CD
# em https://dev.azure.com/RM565155/PawCare), disparando o CI/CD automaticamente!
# Uso: ./scripts/devops/push-devops-video.sh "feat(ui): selo de deploy CI/CD Azure Sprint 4"
# ==============================================================================
set -euo pipefail

MSG="${1:-feat(ui): atualizacao visual demonstracao CI/CD Azure Sprint 4}"

# Se nenhuma alteracao manual foi salva antes de rodar o comando, aplica automaticamente
# uma marcacao visual no subtitulo do login.html para garantir o commit e o trigger do CI/CD
if git diff --quiet && git diff --cached --quiet; then
  echo "ℹ️ Nenhuma alteração detectada no workspace. Aplicando atualização visual no login.html..."
  python3 -c '
path = "src/main/resources/templates/login.html"
with open(path, "r", encoding="utf-8") as f:
    c = f.read()
if "CI/CD Sprint 4" not in c:
    c = c.replace("Medicina Preventiva & Longevidade Pet</p>", "Medicina Preventiva & Longevidade Pet - CI/CD Sprint 4 🚀</p>")
else:
    c = c.replace(" - CI/CD Sprint 4 🚀", " - Deploy CI/CD em Nuvem ✅")
with open(path, "w", encoding="utf-8") as f:
    f.write(c)
'
fi

git add -A
git commit -m "${MSG}"
git push origin HEAD:master
git push origin HEAD:main

echo "=================================================================="
echo "✅ Commit enviado para a branch 'master' no GitHub!"
echo "🚀 A pipeline 'Clyvo-Vet-Sprint4-CI-CD' em RM565155/PawCare já foi disparada automaticamente!"
echo "   Abra: https://dev.azure.com/RM565155/PawCare/_build"
echo "=================================================================="
