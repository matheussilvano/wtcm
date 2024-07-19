#!/bin/bash

# Caminho do arquivo de lista de contas
ARQUIVO_LISTA_CONTAS="/home/matheus.silvano/lista_de_contas"
# Caminho para o backup
CAMINHO_BACKUP="/home/skyline/DEMO.GUSTAVOD/WTCM_TRIBANCO_backup/backup.csv"
# Caminho do arquivo ExemploWTCM
CAMINHO_EXEMPLO_WTCM="./ExemploWTCM"
# Caminho para a pasta de backups
CAMINHO_PASTA_BACKUPS="/home/matheus.silvano/backups/wtcm-tribanco/"

# Função para solicitar dados do usuário
solicitar_dados_usuario() {
    read -p "Digite o GDI: " GDI
    read -p "Digite o Parceiro: " PARCEIRO
    read -p "Digite a Conta: " CONTA

    # Adicionar dados ao arquivo de backup CSV
    echo "$GDI,$PARCEIRO,$CONTA" >> "$CAMINHO_BACKUP"

    # Verificar se o ARQUIVO_LISTA_CONTAS está vazio
    if [ ! -s "$ARQUIVO_LISTA_CONTAS" ]; then
        # Obter o último número sequencial de ExemploWTCM
        if [ -f "$CAMINHO_EXEMPLO_WTCM" ]; then
            ULTIMO_NUM_SEQUENCIAL=$(grep -o 'outbox[0-9]*' "$CAMINHO_EXEMPLO_WTCM" | grep -o '[0-9]*' | sort -n | tail -n 1)
            if [ -z "$ULTIMO_NUM_SEQUENCIAL" ]; then
                ULTIMO_NUM_SEQUENCIAL=0
            fi
        else
            ULTIMO_NUM_SEQUENCIAL=0
        fi
    else
        # Obter o último número sequencial do ARQUIVO_LISTA_CONTAS
        ULTIMO_NUM_SEQUENCIAL=$(grep -o 'outbox[0-9]*' "$ARQUIVO_LISTA_CONTAS" | grep -o '[0-9]*' | sort -n | tail -n 1)
        if [ -z "$ULTIMO_NUM_SEQUENCIAL" ]; then
            ULTIMO_NUM_SEQUENCIAL=0
        fi
    fi

    # Incrementar o número sequencial
    NOVO_NUM_SEQUENCIAL=$((ULTIMO_NUM_SEQUENCIAL + 1))

    # Adicionar dados à lista de contas
    echo "outbox$NOVO_NUM_SEQUENCIAL=$PARCEIRO@F:\\cash\\$CONTA.CSH" >> "$ARQUIVO_LISTA_CONTAS"
}

# Verificar se o arquivo de backup existe, se não, criar e adicionar cabeçalho
if [ ! -f "$CAMINHO_BACKUP" ]; then
    echo "GDI,Parceiro,Conta" > "$CAMINHO_BACKUP"
fi

# Solicitar dados do usuário
solicitar_dados_usuario

echo "Dados adicionados com sucesso ao backup e à lista de contas."
