######################################################################################
##                                                                                  ##
##     AutoWtcm.sh - Script para realizar o envio automático do WTCM                ##
##                                                                                  ##
##     Autor: Matheus Silvano                                                       ##
##     Data Criação: 17/07/2024                                                     ##
##                                                                                  ##
##     Descrição: Realiza a solicitação, edição e envio do WTCM automaticamente     ##
##                                                                                  ##
######################################################################################

#!/bin/bash

# Caminho do arquivo de lista de contas
ARQUIVO_LISTA_CONTAS="/home/matheus.silvano/lista_de_contas.txt"
# Caminho para o backup
CAMINHO_BACKUP="/home/skyline/DEMO.GUSTAVOD/WTCM_TRIBANCO_backup"
# Caminho TRIBANCO.TRIBANCO
CAMINHO_TRIBANCO="TRIBANCO.TRIBANCO"
# Data de Hoje no formato YYYYmmdd
DATA_HOJE_YYYYmmdd=$(date +%Y%m%d)
# Data de Hoje no formato dd/mm/YYYY
DATA_HOJE_PADRAO=$(date +%d/%m/%Y)

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
sed -i 's/"${VAR}".command=0/"${VAR}".command=1/' wtcmactions.ini
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
linha=$(grep -n 'outbox' wtcm.TRIBANCO.TRIBANCO | tail -1 | cut -d: -f1)
awk -v linha="$linha" -v arquivo="$ARQUIVO_LISTA_CONTAS" 'NR==linha {print; system("cat " arquivo)} 1' wtcm.TRIBANCO.TRIBANCO > temp && mv temp wtcm.TRIBANCO.TRIBANCO
clear


# Criar backup do WTCM editado
echo "Criando backup do WTCM editado..."
cp -pv wtcm.TRIBANCO.TRIBANCO $CAMINHO_BACKUP/Evidencia_$DATA_HOJE_YYYYmmdd
clear

# Atualizar wtcmactions.ini para command=2
cd
sed -i 's/"${VAR}".command=./"${VAR}".command=2/' wtcmactions.ini
clear

# Limpar arquivo de lista de contas
echo "Limpando arquivo de lista de contas..."
> $ARQUIVO_LISTA_CONTAS

echo "Processo de WTCM concluído."
