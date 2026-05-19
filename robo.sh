#!/bin/bash

echo "=== CALIBRANDO JSON COM A ESTRUTURA DOS TRÊS PODERES ==="

# 1. Gerando dados.json com a árvore exata: orgaos -> escopo -> secretarias
cat << 'JSON' > dados.json
{
  "orgaos": {
    "PREFEITURA": {
      "secretarias": {
        "Educação": [
          "Decreto Municipal nº 256/2021 - Dispõe sobre desapropriação de área de pleno domínio no Loteamento Bahia Costa Sul para sede de Colégio Estadual."
        ],
        "Urbanismo": [
          "Decreto Municipal nº 126/2023 - Aprovação do Loteamento Lagoa Azul com 169 lotes em Cumuruxatiba."
        ]
      }
    },
    "CAMARA_VEREADORES": {
      "secretarias": {
        "Fiscalização": [
          "Sessões Ordinárias de acompanhamento das contrapartidas fiscais e limites do PDDU de 2005."
        ]
      }
    }
  }
}
JSON

# 2. Gerando o gabarito_compliance.json alinhado para o cruzamento cognitivo
cat << 'JSON' > gabarito_compliance.json
{
  "PREFEITURA": {
    "secretarias": {
      "Educação": ["bahia costa sul", "colégio estadual", "desapropriação", "lei orgânica"],
      "Urbanismo": ["lagoa azul", "cumuruxatiba", "lotes", "adensamento", "vias"]
    }
  },
  "CAMARA_VEREADORES": {
    "secretarias": {
      "Fiscalização": ["tcm", "contas", "limites", "pddu"]
    }
  }
}
JSON

echo "[SUCESSO] Estrutura interna alinhada!"
echo "========================================="
echo "4. GERANDO RELATÓRIO FORMATADO PARA O GITHUB..."
echo "========================================="

# Nome do relatório final baseado na data de hoje
DATA_HOJE=$(date +%Y-%m-%d)
RELATORIO_FINAL="relatorio_auditoria_${DATA_HOJE}.md"

# Se o resultado da varredura não estiver vazio, cria o relatório de danos
if [ -s resultado_varredura.txt ]; then
    
    # Monta um documento Markdown bonitão de forma automática
    echo "# ⚠️ RELATÓRIO DE AUDITORIA DE CONFORMIDADE" > $RELATORIO_FINAL
    echo "Distrito/Município: Auditoria Automatizada" >> $RELATORIO_FINAL
    echo "Data da Varredura: $(date '+%d/%m/%Y às %H:%M:%S')" >> $RELATORIO_FINAL
    echo "Status: **INCONFORMIDADE DETECTADA**" >> $RELATORIO_FINAL
    echo "---" >> $RELATORIO_FINAL
    echo "## 🔍 Termos Encontrados no Diário Oficial:" >> $RELATORIO_FINAL
    echo "Abaixo estão as ocorrências de termos ligados a Planejamento Urbano e Terrenos Vazios:" >> $RELATORIO_FINAL
    echo "" >> $RELATORIO_FINAL
    
    # Injeta os trechos encontrados formatados como citações de código
    echo "\`\`\`text" >> $RELATORIO_FINAL
    cat resultado_varredura.txt >> $RELATORIO_FINAL
    echo "\`\`\`" >> $RELATORIO_FINAL
    
    echo "---" >> $RELATORIO_FINAL
    echo "### 🛡️ Autenticidade" >> $RELATORIO_FINAL
    # Gera a pegada criptográfica única do relatório (Hash) que vai virar o NFT
    HASH_RELATORIO=$(sha256sum $RELATORIO_FINAL | awk '{print $1}')
    echo "Pegada Digital (SHA-256): \`$HASH_RELATORIO\`" >> $RELATORIO_FINAL

    echo "✅ Relatório visual gerado: $RELATORIO_FINAL"
    
    # Próximo passo automático: Enviar para o GitHub usando os comandos que você já tem vinculados
    # git add $RELATORIO_FINAL
    # git commit -m "Adicionando relatório de conformidade urbano $DATA_HOJE"
    # git push origin main

else
    echo "✅ Tudo limpo. Nenhum dano ou termo encontrado para gerar relatório."
fi

# Comando atualizado usando weasyprint (funciona perfeitamente no seu WSL)
weasyprint "$RELATORIO_FINAL" "relatorio_auditoria_${DATA_HOJE}.pdf"
echo "📕 PDF Oficial Gerado: relatorio_auditoria_${DATA_HOJE}.pdf"