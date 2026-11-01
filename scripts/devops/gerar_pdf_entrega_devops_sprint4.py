#!/usr/bin/env python3
"""
Gerador do PDF Obrigatório — 4ª Sprint: DevOps Tools & Cloud Computing (FIAP)
Regra estrita do Slide 1:
"Entrega Obrigatória: Um PDF com:
 - Nome completo, RM dos integrantes do grupo e turma de cada integrante
 - Link do repositório no GitHub
 - Link do vídeo no YouTube
 - Link do projeto no Azure DevOps
 Somente isso no PDF, o resto é no README"
"""
import os
import subprocess
import sys
from pathlib import Path

ROOT_DIR = Path(__file__).resolve().parents[2]
PDF_OUTPUT = ROOT_DIR / "Entrega_DevOps_Sprint4_FIAP.pdf"
HTML_TEMP = ROOT_DIR / "docs" / "devops" / "_temp_entrega_sprint4.html"

GITHUB_URL = os.environ.get(
    "GITHUB_URL", "https://github.com/Gabriel-Maciel06/clyvo-vet-web-v2"
)
YOUTUBE_URL = os.environ.get(
    "YOUTUBE_URL", "https://youtu.be/INSERIR_LINK_DO_VIDEO_AQUI"
)
AZURE_DEVOPS_URL = os.environ.get(
    "AZURE_DEVOPS_URL",
    "https://dev.azure.com/GabrielMaciel562795/Sprint%204%20%E2%80%93%20Azure%20DevOps",
)

HTML_CONTENT = f"""<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <title>Entrega 4ª Sprint - DevOps Tools &amp; Cloud Computing</title>
  <style>
    @page {{
      size: A4;
      margin: 24mm 22mm;
    }}
    body {{
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
      color: #0f172a;
      line-height: 1.6;
      font-size: 11.5pt;
      margin: 0;
      padding: 0;
    }}
    .header {{
      border-bottom: 3px solid #ed145b;
      padding-bottom: 14px;
      margin-bottom: 28px;
    }}
    .header h1 {{
      font-size: 16pt;
      margin: 0 0 4px 0;
      color: #0f172a;
      letter-spacing: -0.2px;
    }}
    .header p {{
      font-size: 11pt;
      margin: 0;
      color: #475569;
      font-weight: 600;
    }}
    .section {{
      margin-bottom: 24px;
    }}
    .section h2 {{
      font-size: 12.5pt;
      color: #0f172a;
      margin: 0 0 10px 0;
      text-transform: uppercase;
      letter-spacing: 0.4px;
      border-left: 4px solid #0078d4;
      padding-left: 10px;
    }}
    table {{
      width: 100%;
      border-collapse: collapse;
      margin-top: 8px;
    }}
    th, td {{
      border: 1px solid #cbd5e1;
      padding: 9px 12px;
      text-align: left;
      font-size: 11pt;
    }}
    th {{
      background-color: #f1f5f9;
      font-weight: 700;
      color: #1e293b;
    }}
    .link-box {{
      background: #f8fafc;
      border: 1px solid #cbd5e1;
      border-radius: 6px;
      padding: 12px 16px;
      margin-bottom: 14px;
    }}
    .link-label {{
      font-weight: 700;
      color: #1e293b;
      display: block;
      margin-bottom: 4px;
      font-size: 11pt;
    }}
    .link-url {{
      color: #0078d4;
      text-decoration: underline;
      word-break: break-all;
      font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
      font-size: 10.5pt;
    }}
  </style>
</head>
<body>
  <div class="header">
    <h1>FIAP — DEVOPS TOOLS &amp; CLOUD COMPUTING (4ª SPRINT)</h1>
    <p>Projeto: Sprint 4 – Azure DevOps | Professor: Prof. João Menk</p>
  </div>

  <div class="section">
    <h2>1. Integrantes do Grupo, RM e Turma</h2>
    <table>
      <thead>
        <tr>
          <th>Nome Completo</th>
          <th>RM</th>
          <th>Turma</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>Gabriel Maciel Alves de Oliveira</td>
          <td>RM562795</td>
          <td>2TDSR</td>
        </tr>
        <tr>
          <td>Vitória Rodrigues Martins</td>
          <td>RM565160</td>
          <td>2TDSR</td>
        </tr>
        <tr>
          <td>Augusto Bonomo Júnior</td>
          <td>RM565155</td>
          <td>2TDSR</td>
        </tr>
        <tr>
          <td>Thomas Fontes</td>
          <td>RM562254</td>
          <td>2TDSR</td>
        </tr>
        <tr>
          <td>Matheus Pereira Molina</td>
          <td>RM563399</td>
          <td>2TDSR</td>
        </tr>
      </tbody>
    </table>
  </div>

  <div class="section">
    <h2>2. Links Obrigatórios da Entrega</h2>

    <div class="link-box">
      <span class="link-label">Link do Repositório no GitHub:</span>
      <a class="link-url" href="{GITHUB_URL}">{GITHUB_URL}</a>
    </div>

    <div class="link-box">
      <span class="link-label">Link do Vídeo Demonstrativo no YouTube:</span>
      <a class="link-url" href="{YOUTUBE_URL}">{YOUTUBE_URL}</a>
    </div>

    <div class="link-box">
      <span class="link-label">Link do Projeto no Azure DevOps (Sprint 4 – Azure DevOps):</span>
      <a class="link-url" href="{AZURE_DEVOPS_URL}">{AZURE_DEVOPS_URL}</a>
    </div>
  </div>
</body>
</html>
"""

def main():
    HTML_TEMP.parent.mkdir(parents=True, exist_ok=True)
    HTML_TEMP.write_text(HTML_CONTENT, encoding="utf-8")

    chrome_bin = "/Users/gabrieloliveira/Library/Caches/ms-playwright/chromium_headless_shell-1248/chrome-headless-shell-mac-arm64/chrome-headless-shell"
    if not os.path.exists(chrome_bin):
        chrome_bin = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

    cmd = [
        chrome_bin,
        "--headless",
        "--no-pdf-header-footer",
        f"--print-to-pdf={PDF_OUTPUT}",
        f"file://{HTML_TEMP}",
    ]
    subprocess.run(cmd, check=True)
    if HTML_TEMP.exists():
        HTML_TEMP.unlink()
    print(f"PDF gerado com sucesso em: {PDF_OUTPUT}")

if __name__ == "__main__":
    main()
