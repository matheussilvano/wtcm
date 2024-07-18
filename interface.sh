#!/bin/bash

# Caminho do arquivo de lista de contas
ARQUIVO_LISTA_CONTAS="/home/matheus.silvano/lista_de_contas.txt"
# Caminho para o backup
CAMINHO_BACKUP="/home/skyline/DEMO.GUSTAVOD/WTCM_TRIBANCO_backup/backup.csv"

# Função para solicitar dados do usuário
solicitar_dados_usuario() {
    read -p "Digite o GDI: " GDI
    read -p "Digite o Parceiro: " PARCEIRO
    read -p "Digite a Conta: " CONTA

    # Adicionar dados ao arquivo de backup CSV
    echo "$GDI,$PARCEIRO,$CONTA" >> "$CAMINHO_BACKUP"

    # Adicionar dados à lista de contas
    NUM_SEQUENCIAL=$(($(wc -l < "$ARQUIVO_LISTA_CONTAS") + 1))
    echo "outbox$NUM_SEQUENCIAL=$PARCEIRO@F:\\cash\\$CONTA.CSH" >> "$ARQUIVO_LISTA_CONTAS"
}

# Verificar se o arquivo de backup existe, se não, criar e adicionar cabeçalho
if [ ! -f "$CAMINHO_BACKUP" ]; then
    echo "GDI,Parceiro,Conta" > "$CAMINHO_BACKUP"
fi

# Solicitar dados do usuário
solicitar_dados_usuario

echo "Dados adicionados com sucesso ao backup e à lista de contas."
