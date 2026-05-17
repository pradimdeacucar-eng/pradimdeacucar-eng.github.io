#!/bin/bash

# URL real de Prado
URL_PORTAL="https://doem.org.br/ba/prado"

# Pescando o código do diário mais recente
CODIGO=$(curl -s $URL_PORTAL | grep -oP '/diarios/previsualizar/\K[A-Za-z0-9]+' | head -n 1)

# Se não achou nada, ele te avisa
if [ -z "$CODIGO" ]; then
    echo "Erro: O site da prefeitura mudou ou está fora do ar."
    exit 1
fi

# Monta o link completo
URL_FINAL="https://doem.org.br/ba/prado/diarios/previsualizar/$CODIGO"

# CRIA O JSON DO ZERO - Sem erro de vírgula ou aspas sobrando
printf '[\n  "%s"\n]\n' "$URL_FINAL" > dados.json

echo "Pronto! O link real foi salvo com sucesso."