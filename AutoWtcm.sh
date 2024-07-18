#############################################
#
# AutoWtcm.sh - Script para realizar o envio automático do WTCM
#
# Autor: Matheus Silvano
# Data Criação: 17/07/2024
#
# Descrição: Realiza a solicitação, edição e envio do WTCM automaticamente
#
# Exemplo de uso: home/matheus.silvano/AutoWtcm.sh
#
# Dúvidas para tirar com o Junior Leal:
# - r $ARQUIVO_LISTA_CONTAS vai funcionar na edição do wtcm?
# - $ da edição do wtcm tem que ser mudado, pois não fica na última linha do arquivo
# - validar a edição da data no wtcm
#
#######################################################

#!/bin/bash

# Caminho do arquivo de lista de contas
ARQUIVO_LISTA_CONTAS="/home/matheus.silvano/lista_de_contas.txt"
# Caminho para o backup
CAMINHO_BACKUP="/home/skyline/DEMO.GUSTAVOD/WTCM_TRIBANCO_backup"

# Função para verificar se o arquivo de lista de contas tem conteúdo
verificar_conteudo_lista_contas() {
    if [ ! -s "$ARQUIVO_LISTA_CONTAS" ]; then
        echo "O arquivo de lista de contas está vazio ou não existe. Encerrando o processo."
        exit 1
    fi
}

# Verificar se há conteúdo no arquivo de lista de contas
verificar_conteudo_lista_contas

# Solicitar WTCM
echo "Solicitando WTCM..."
cd
vi wtcmactions.ini << EOF
/TRIBANCO.TRIBANCO
:insert
s/command=0/command=1/
:wq
EOF
clear

# Aguardar o recebimento do WTCM
echo "Aguardando recebimento do WTCM..."
while true; do
    cd wtcm
    if ls -ltr *TRIBANCO*; then
        echo "WTCM recebido."
        break
    else
        echo "WTCM não recebido. Tentando novamente em 1 minuto..."
        sleep 60
    fi
    cd
done
clear

# Editar WTCM com as novas contas
echo "Editando WTCM..."
cd wtcm
vi wtcm.TRIBANCO.TRIBANCO << EOF
:$
r $ARQUIVO_LISTA_CONTAS
:wq
EOF
clear

# Criar backup do WTCM editado
DATA_HOJE=$(date +%Y%m%d)
echo "Criando backup do WTCM editado..."
cp -pv wtcm.TRIBANCO.TRIBANCO $CAMINHO_BACKUP/Evidencia_$DATA_HOJE
clear

# Atualizar wtcmactions.ini para command=2
cd
vi wtcmactions.ini << EOF
/TRIBANCO.TRIBANCO
:insert
s/command=1/command=2/
:wq
EOF
clear

# Limpar arquivo de lista de contas
echo "Limpando arquivo de lista de contas..."
> $ARQUIVO_LISTA_CONTAS

echo "Processo de WTCM concluído."
