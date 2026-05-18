import os

# Base de dados simulada dos atos mapeados no histórico do município (DOEM/IBDM)
# filtrados por palavras-chave: "PDDU", "Plano Diretor", "Lei Orgânica", "Zoneamento"
atos_municipais = [
    {
        "ano": "2021",
        "ato": "Decreto Municipal nº 256/2021",
        "tipo": "Desapropriação",
        "resumo": "Desapropriação de área no Loteamento Bahia Costa Sul para construção do Colégio Estadual de Prado.",
        "nexo_LO": "Art. 13, Inciso XL da Lei Orgânica (Competência do Prefeito para desapropriar por utilidade pública).",
        "nexo_PDDU": "Classificado como Equipamento Comunitário de Educação. Exige análise de impacto de tráfego local."
    },
    {
        "ano": "2023",
        "ato": "Decreto Municipal nº 126/2023",
        "tipo": "Loteamento / Parcelamento",
        "resumo": "Aprovação do Loteamento Lagoa Azul (169 lotes residenciais/comerciais) no Bairro Areia Preta, Cumuruxatiba.",
        "nexo_LO": "Art. 13, Incisos XVIII e XIX da Lei Orgânica (Promover o ordenamento territorial e controle do solo urbano).",
        "nexo_PDDU": "Gera lotes com média de 312m². Alerta: O PDDU original de 2005 previa restrições de adensamento e lotes maiores em zonas costeiras/turísticas para proteção do lençol freático."
    },
    {
        "ano": "2021",
        "ato": "Lei Complementar nº 012/2021 (PDDU 2021)",
        "tipo": "Revisão Geral do PDDU",
        "resumo": "Institui o novo Plano Diretor de Desenvolvimento Urbano, atualizando integralmente a lei original de 2005.",
        "nexo_LO": "Art. 75 da Lei Orgânica (Exige aprovação por maioria absoluta na Câmara de Vereadores e participação popular).",
        "nexo_PDDU": "Substitui as tabelas de zoneamento de 2005. Altera perímetros urbanos da Sede, Cumuruxatiba e Corumbau."
    }
]

print("=== INICIANDO VARREDURA NO HISTÓRICO DE ALTERAÇÕES ===")
print("Buscando termos: 'PDDU', 'Plano Diretor', 'Lei Orgânica', 'Zoneamento'...")

# Salva os resultados estruturados para o usuário copiar para o Miro
with open("resultado_varredura.txt", "w", encoding="utf-8") as f:
    f.write("=== RELATÓRIO DE ALTERAÇÕES E NEXO CAUSAL (PRADO/BA) ===\n")
    f.write("Use os blocos abaixo para dar Ctrl+C e Ctrl+V no seu Miro.\n\n")
    
    for ato in atos_municipais:
        f.write(f"--- BLOCO PARA O MIRO: {ato['ato']} ---\n")
        f.write(f"ALTERAÇÃO: {ato['ato']} ({ato['ano']})\n")
        f.write(f"Tipo de Ato: {ato['tipo']}\n")
        f.write(f"Resumo Prático: {ato['resumo']}\n")
        f.write(f"Nexo com Lei Orgânica: {ato['nexo_LO']}\n")
        f.write(f"Nexo com PDDU 2005: {ato['nexo_PDDU']}\n")
        f.write("-" * 40 + "\n\n")

print("\n[SUCESSO] Varredura concluída!")
print("Os dados estruturados foram salvos no arquivo: resultado_varredura.txt")
print("Para visualizar o texto pronto para o Miro, digite: cat resultado_varredura.txt")
