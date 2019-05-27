#!/usr/bin/env bash
#
# Ninja Notes
#
# Autor: Felipe Silva
#	Site: neni.dev
# 	Github: nenitf
#	Gitlab: nenitf
#
# O que é:
#   Gerenciador de notas/datas/aniversários
#
# Comandos:
#   Listar: nn
#   Abrir agendamentos: nn a
#   Abrir lista todo: nn t
#   Abrir aniversários: nn b
#   Ajuda: nn -h
#   Remover item agendamento: nn ra <numero-do-item> <numero-do-item> ..
#   Remover item todo: nn rt <numero-da-linha> <numero-da-linha> ..
#   Adicionar texto a todo: nn <texto a ser add no arquivo todo>
#   Adicionar agentamento: dnn <dd/mm> <texto a ser add no arquivo apts>
#   Adicionar agendamento: nn <dd/mm/yyyy> <texto a ser add no arquivo apts>
#
# Como habilitar comando nn?
#   Escrever no .bashrc:
#       source ~/caminho/desse/arquivo.sh
#
# Quais arquivos ficam as notas?
#   Pelas variáveis:
#       local CONF_DIR=~/dev/dotfiles/nn
#       local TODO_FILE=$CONF_DIR/todo
#       local APTS_FILE=$CONF_DIR/apts
#       local BTDS_FILE=$CONF_DIR/birthdays
#
# Inspiração:
#   Calcurse: https://calcurse.org/
#   td-cli: https://github.com/darrikonn/td-cli

nn(){
    # COLORS PREFERENCES
    #####################################
    # https://misc.flogisoft.com/bash/tip_colors_and_formatting
    local RESET="\e[0m\e[39m\e[49m"
    local BOLD="\e[1m"
    local STRIKE="\e[9m"
    local BLINK="\e[25m"

    local BG_RED="\e[41m"

    local FG_YELLOW="\e[33m"
    local FG_GREEN="\e[32m"
    local FG_CYAN="\e[36m"

    local TODO_STYLE=$FG_CYAN
    local APTS_STYLE=$FG_YELLOW
    local BTDS_STYLE=$FG_GREEN

    local WARN_STYLE=$BG_RED
    #####################################

    # GERAL PREFERENCES
    #####################################
    local DAYS_RANGE=7 # range of days that will show

    # files stored
    local CONF_DIR=~/.config/nn
    local TODO_FILE=$CONF_DIR/todo
    local APTS_FILE=$CONF_DIR/apts
    local BTDS_FILE=$CONF_DIR/birthdays
    #####################################

    # create empty dir/files
    mkdir -p $CONF_DIR
    touch $TODO_FILE
    touch $APTS_FILE
    touch $BTDS_FILE

    if [ $# -eq 0 ]; then
        # list todo and apts

        # seconds are comparable
        local HOJE=$(date -d "today 00:00" +'%s')
        local PROX_SEMANA=$(date -d "$APTS_RANGE days" +'%s')

        echo -e $BOLD"\nto do"$RESET
        echo -en $TODO_STYLE
        grep -FnT "$DATA_DMY_SEMANA" $TODO_FILE
        echo -en $RESET

        echo -en $BOLD"\nappointments"$RESET
        for number_day_week in $(seq 0 $DAYS_RANGE); do
            local DATA_DMY_SEMANA=$(date -d "+$number_day_week days" +"%d/%m/%Y")
            local DATA_DM_SEMANA=$(date -d "+$number_day_week days" +"%d/%m")
            if [ $(grep -Fc "$DATA_DMY_SEMANA" $APTS_FILE) -gt 0 ] || [ $(grep -Fc "$DATA_DM_SEMANA" $BTDS_FILE) -gt 0 ]; then
                echo -e "\n$DATA_DM_SEMANA"

                echo -en $APTS_STYLE
                grep -FnT "$DATA_DMY_SEMANA" $APTS_FILE | sed -e 's|\([0-9][0-9]\)/\([0-9][0-9]\)/\([0-9]\{4\}\)||'
                echo -en $RESET

                echo -en $BTDS_STYLE
                grep -FnT "$DATA_DM_SEMANA" $BTDS_FILE | sed -e 's|\([0-9][0-9]\)/\([0-9][0-9]\)||'
                echo -en $RESET
            fi
        done

        echo ""

    else
        case $1 in
            h | -h | --help) # manual
                echo "Listar: nn"
                echo "Abrir agendamentos: nn a"
                echo "Abrir lista todo: nn t"
                echo "Abrir aniversários: nn b"
                echo "Ajuda: nn -h"
                echo "Remover item agendamento: nn ra <numero-do-item> <numero-do-item> .."
                echo "Remover item todo: nn rt <numero-da-linha> <numero-da-linha> .."
                echo "Adicionar texto a todo: nn <texto a ser add no arquivo todo>"
                echo "Adicionar agentamento: dnn <dd/mm> <texto a ser add no arquivo apts>"
                echo "Adicionar agendamento: nn <dd/mm/yyyy> <texto a ser add no arquivo apts>"
                ;;
            t) # open todo
                $EDITOR $TODO_FILE
                ;;
            a) # open apts
                $EDITOR $APTS_FILE
                ;;
            b) # open birthdays
                $EDITOR $BTDS_FILE
                ;;
            rt | ra) # remove todo or apt
                # concat command sed
                #   must be like:  sed -i "1d;3d;4d;5d" file
                local command_sed=""
                # maintain if is ra or rt
                local option_remove="$1"

                # loop while exists parameters
                while [[ $# -gt 1 ]]; do
                    local key="$2"

                    # remove line from 1
                    if [ $key -gt 0 ]; then
                        command_sed+=$key"d"

                        # only last parameter dont receive ";"
                        if [ $# -gt 2 ]; then command_sed+=";"; fi
                    else
                        echo $WARN_STYLE"A LINHA DEVE SER UM VALOR NUMÉRICO A PARTIR DE 1"$RESET
                    fi

                    # remove actual parameter, like $2, $3, $4 ...
                    shift
                done

                if [ $option_remove == "rt" ]; then sed -i "$command_sed" $TODO_FILE; else sed -i "$command_sed" $APTS_FILE; fi
                nn
                ;;
            *)  # write a todo
                if [[ $1 =~ ^[0-9]{2}+\/[0-9]{2} ]]; then
                    # nn date and what more?
                    if [ $# -gt 1 ]; then
                        local DIA=$(echo $1 | awk -F/ '{print $1}')
                        local MES=$(echo $1 | awk -F/ '{print $2}')

                        # year is a parameter?
                        if [[ $1 =~ ^[0-9]{2}+\/[0-9]{2}+\/[0-9]{2} ]]; then
                            local ANO=$(echo $1 | awk -F/ '{print 20$3}')
                        else
                            local ANO=$(date +'%Y')
                        fi

                        # stderr to /dev/null
                        local DATA_APTS=$(date -d "$MES/$DIA/$ANO" +"%s" 2>/dev/null)

                        # date is correct?
                        if [ $DATA_APTS -ge 0 ] &>/dev/null; then
                            # write a apt
                            echo "$DIA/$MES/$ANO ${@:2}" >> $APTS_FILE
                        else
                            echo -e $WARN_STYLE"DATA INVALIDA"$RESET
                        fi
                    fi
                else
                    # nn fyuhfud fdygfiudf fuhaidof duafhiaosd udfhaiodfj
                    echo "$@" >> $TODO_FILE
                fi
                nn
                ;;
        esac
    fi
    echo ""

}