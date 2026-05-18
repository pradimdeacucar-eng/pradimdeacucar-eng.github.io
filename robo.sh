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
