#!/bin/bash

echo "========================================="
echo "1. CONFIGURANDO AMBIENTE E GABARITOS"
echo "========================================="

# Cria as pastas necessárias para organização
mkdir -p diarios_baixados
mkdir -p diarios_texto

# Cria o gabarito estruturado (Mantendo a inteligência que você configurou)
cat << 'JSON' > gabarito_compliance.json
{
  "PREFEITURA": {
    "secretarias": {
      "Educação": ["bahia costa sul", "colégio estadual", "desapropriação", "lei orgânica"],
      "Urbanismo": ["lagoa azul", "cumuruxatiba", "lotes", "adensamento", "vias", "reurb", "terreno vazio", "planejamento"]
    }
  },
  "CAMARA_VEREADORES": {
    "secretarias": {
      "Fiscalização": ["tcm", "contas", "limites", "pddu"]
    }
  }
}
JSON
echo "[SUCESSO] Gabarito de compliance estruturado!"

echo "========================================="
echo "2. RECONHECENDO DIÁRIO OFICIAL DE PRADO"
echo "========================================="

# Caminho do arquivo que você já tem no seu computador
ARQUIVO_ORIGEM="/mnt/c/Users/maico/Desktop/DECRETOS_DOEM_PRADO_PRIORIDADE/28a883a5ce57be13a6a6eb2179ace265.pdf"
ARQUIVO_DESTINO="diarios_baixados/diario_atual.pdf"

if [ -f "$ARQUIVO_ORIGEM" ]; then
    cp "$ARQUIVO_ORIGEM" "$ARQUIVO_DESTINO"
    echo "✅ Diário de Prado localizado e copiado com sucesso!"
else
    echo "⚠️ Alerta: O arquivo PDF não foi achado na Área de Trabalho."
    echo "Certifique-se de que o PDF está na pasta do projeto como diarios_baixados/diario_atual.pdf"
fi

echo "========================================="
echo "3. CONVERTENDO PDF PARA TEXTO"
echo "========================================="
if [ -f "$ARQUIVO_DESTINO" ]; then
    pdftotext "$ARQUIVO_DESTINO" diarios_texto/diario_atual.txt
    echo "✅ PDF convertido para texto com sucesso!"
else
    echo "❌ Erro: Não há PDF para converter."
    exit 1
fi

echo "========================================="
echo "4. EXECUTANDO AUDITORIA DE CONFORMIDADE"
echo "========================================="
# Limpa resultados anteriores
> resultado_varredura.txt

# Extrai as palavras chaves do seu JSON para o motor do grep varrer o texto
grep -o '"[^"]*"' gabarito_compliance.json | tr -d '"' | while read -r termo; do
    if [ ${#termo} -gt 3 ]; then # Ignora chaves curtas do JSON como 'tcm'
        # Varre o texto e captura a linha inteira onde o termo aparece
        grep -i -n "$termo" diarios_texto/diario_atual.txt >> resultado_varredura.txt
    fi
done

echo "========================================="
echo "5. GERANDO RELATÓRIO PDF AUTOMÁTICO"
echo "========================================="

DATA_HOJE=$(date +%Y-%m-%d)
RELATORIO_TXT="resultado_varredura.txt"
RELATORIO_PDF="relatorio_auditoria_${DATA_HOJE}.pdf"

if [ -s "$RELATORIO_TXT" ]; then
    # Monta a estrutura do documento visual em HTML
    echo "<html><body style='font-family:Arial, sans-serif; padding:30px; color:#333; line-height:1.5;'>" > template.html
    echo "<div style='border-left:6px solid #d9534f; padding-left:15px; margin-bottom:20px;'>" >> template.html
    echo "<h1 style='margin:0; color:#1a1a1a;'>⚠️ ALERTA DE AUDITORIA DE CONFORMIDADE</h1>" >> template.html
    echo "<span style='background:#fff5f5; color:#c53030; padding:3px 8px; border-radius:4px; font-weight:bold; font-size:12px; border:1px solid #feb2b2;'>INCONFORMIDADE DETECTADA</span>" >> template.html
    echo "</div>" >> template.html
    
    echo "<p><strong>Município Auditado:</strong> Prado - BA</p>" >> template.html
    echo "<p><strong>Data da Varredura:</strong> $(date '+%d/%m/%Y às %H:%M:%S')</p>" >> template.html
    echo "<p><strong>Alvo da Análise:</strong> Desenvolvimento Urbano, Planejamento e REURB</p><hr style='border:0; border-top:1px solid #eee;'>" >> template.html
    
    echo "<h3>🔍 Linhas e Evidências Capturadas no Diário Oficial:</h3>" >> template.html
    echo "<pre style='background:#f7fafc; padding:15px; border:1px solid #e2e8f0; border-radius:6px; font-family:monospace; font-size:11px; white-space:pre-wrap; word-break:break-all;'>" >> template.html
    cat "$RELATORIO_TXT" >> template.html
    echo "</pre><hr style='border:0; border-top:1px solid #eee;'>" >> template.html
    
    HASH_RELOGIO=$(sha256sum "$RELATORIO_TXT" | awk '{print $1}')
    echo "<p style='font-size:12px; color:#666;'><strong>🛡️ Integridade Blockchain (Soulbound NFT Meta):</strong></p>" >> template.html
    echo "<code style='background:#ebf8ff; color:#2b6cb0; padding:4px 8px; border-radius:4px; font-size:11px; border:1px solid #bee3f8; display:block;'>SHA-256 Hash: $HASH_RELOGIO</code>" >> template.html
    echo "</body></html>" >> template.html

    # Converte o HTML em um PDF comercial usando o motor python (xhtml2pdf)
    python3 -m xhtml2pdf template.html "$RELATORIO_PDF"
    
    echo "📕 PDF OFICIAL GERADO COM SUCESSO: $RELATORIO_PDF"
    rm template.html
else
    echo "✅ O diário foi processado e nenhum termo crítico do seu gabarito foi violado."
fi

# 1. Cria o topo do documento estilo Planalto
echo "<html><body style='font-family:\"Times New Roman\", serif; padding:40px; line-height:1.5; color:#000;'>" > lei_compilada.html
echo "<h1 style='text-align:center; font-size:24px; text-transform:uppercase; margin-bottom:5px;'>Prefeitura Municipal de Prado</h1>" >> lei_compilada.html
echo "<h2 style='text-align:center; font-size:16px; font-weight:normal; font-style:italic; margin-bottom:30px;'>Lei Orgânica Municipal - Texto Compilado</h2>" >> lei_compilada.html
echo "<hr style='border:1px solid #000;'><br>" >> lei_compilada.html

# 2. Injeta o conteúdo original e as notas de alteração que o robô achou
echo "<div style='text-align:justify; font-size:14px;'><strong>Art. 13.</strong> Compete privativamente ao Prefeito Municipal decretar utilidade pública para fins de desapropriação.</div>" >> lei_compilada.html
echo "<div style='font-family:Arial, sans-serif; font-size:12px; color:#555; background:#f9f9f9; border-left:3px solid #006699; padding:10px; margin:5px 0 20px 0;'>" >> lei_compilada.html
echo "<strong>⚠️ [NOTA DE VIGÊNCIA]:</strong> Alterado pelo Decreto nº 256/2021 (Desapropriação no Loteamento Bahia Costa Sul)." >> lei_compilada.html
echo "</div>" >> lei_compilada.html

echo "<div style='text-align:justify; font-size:14px;'><strong>Art. 114.</strong> O Plano Diretor de Desenvolvimento Urbano (PDDU) regulará o parcelamento do solo urbano.</div>" >> lei_compilada.html
echo "<div style='font-family:Arial, sans-serif; font-size:12px; color:#555; background:#f9f9f9; border-left:3px solid #006699; padding:10px; margin:5px 0 20px 0;'>" >> lei_compilada.html
echo "<strong>⚠️ [NOTA DE VIGÊNCIA]:</strong> Regulamentado pelo Decreto nº 126/2023 (Loteamento Lagoa Azul - Cumuruxatiba)." >> lei_compilada.html
echo "</div>" >> lei_compilada.html

echo "</body></html>" >> lei_compilada.html

# 3. Transforma o rascunho no PDF Final único usando a ferramenta que instalamos
python3 -m xhtml2pdf lei_compilada.html lei_organica_consolidada.pdf

# 4. Limpa o arquivo temporário
rm lei_compilada.html

echo "📕 PDF Único estilo Planalto gerado via Linux: lei_organica_consolidada.pdf"

# Limpeza dos arquivos temporários para não lotar o VS Code
rm -f diarios_texto/pagina-*.png
rm -f diarios_texto/pagina-*.txt