#!/bin/bash

colorSmall() {
    local char="▀▀"

    local palette=$(printf '%s'\
    "$(__formatText "$char" -c black -b dark-gray)"\
    "$(__formatText "$char" -c red -b light-red)"\
    "$(__formatText "$char" -c green -b light-green)"\
    "$(__formatText "$char" -c yellow -b light-yellow)"\
    "$(__formatText "$char" -c blue -b light-blue)"\
    "$(__formatText "$char" -c magenta -b light-magenta)"\
    "$(__formatText "$char" -c cyan -b light-cyan)"\
    "$(__formatText "$char" -c light-gray -b white)")

    printf "$palette\n"
}

colorFancy() {
    local palette_top=$(printf '%s'\
        "$(__formatText "▄" -c dark-gray)$(__formatText "▄" -c dark-gray -b black)$(__formatText "█" -c black) "\
        "$(__formatText "▄" -c light-red)$(__formatText "▄" -c light-red -b red)$(__formatText "█" -c red) "\
        "$(__formatText "▄" -c light-green)$(__formatText "▄" -c light-green -b green)$(__formatText "█" -c green) "\
        "$(__formatText "▄" -c light-yellow)$(__formatText "▄" -c light-yellow -b yellow)$(__formatText "█" -c yellow) "\
        "$(__formatText "▄" -c light-blue)$(__formatText "▄" -c light-blue -b blue)$(__formatText "█" -c blue) "\
        "$(__formatText "▄" -c light-magenta)$(__formatText "▄" -c light-magenta -b magenta)$(__formatText "█" -c magenta) "\
        "$(__formatText "▄" -c light-cyan)$(__formatText "▄" -c light-cyan -b cyan)$(__formatText "█" -c cyan) "\
        "$(__formatText "▄" -c white)$(__formatText "▄" -c white -b light-gray)$(__formatText "█" -c light-gray) ")

    local palette_bot=$(printf '%s'\
        "$(__formatText "██" -c dark-gray)$(__formatText "▀" -c black) "\
        "$(__formatText "██" -c light-red)$(__formatText "▀" -c red) "\
        "$(__formatText "██" -c light-green)$(__formatText "▀" -c green) "\
        "$(__formatText "██" -c light-yellow)$(__formatText "▀" -c yellow) "\
        "$(__formatText "██" -c light-blue)$(__formatText "▀" -c blue) "\
        "$(__formatText "██" -c light-magenta)$(__formatText "▀" -c magenta) "\
        "$(__formatText "██" -c light-cyan)$(__formatText "▀" -c cyan) "\
        "$(__formatText "██" -c white)$(__formatText "▀" -c light-gray) ")

    printf "$palette_top\n$palette_bot\n"
}

colorWords() {
    reset=$(tput sgr0)
    black=$(tput setaf 0)
    cyan=$(tput setaf 37)
    green=$(tput setaf 64)
    orange=$(tput setaf 166)
    purple=$(tput setaf 125)
    red=$(tput setaf 124)
    violet=$(tput setaf 61)
    white=$(tput setaf 15)
    yellow=$(tput setaf 136)

    echo "${black}black"
    echo "${cyan}cyan"
    echo "${green}green"
    echo "${orange}orange"
    echo "${purple}purple"
    echo "${red}red"
    echo "${violet}violet"
    echo "${white}white"
    echo "${yellow}yellow"
}

################ private functions

__formatText() {
    local RESET=$(__getFormattingSequence $(__getEffectCode none))

    ## NO ARGUMENT PROVIDED
    if [ "$#" -eq 0 ]; then
        echo -n "${RESET}"

    ## ONLY A STRING PROVIDED -> Append reset sequence
    elif [ "$#" -eq 1 ]; then
        TEXT=$1
        echo -n "${TEXT}${RESET}"

    ## ARGUMENTS PROVIDED
    else
        TEXT=$1
        FORMAT_CODE=$(__getFormatCode "${@:2}")
        __applyCodeToText "$TEXT" "$FORMAT_CODE"
    fi
}

__getFormatCode() {
    local RESET=$(__getFormattingSequence $(__getEffectCode none))

    ## NO ARGUMENT PROVIDED
    if [ "$#" -eq 0 ]; then
        echo -n "$RESET"

    ## 1 ARGUMENT -> ASSUME TEXT COLOR
    elif [ "$#" -eq 1 ]; then
        TEXT_COLOR=$(__getFormattingSequence $(__getColorCode $1))
        echo -n "$TEXT_COLOR"

    ## ARGUMENTS PROVIDED
    else
        FORMAT=""
        while [ "$1" != "" ]; do

            ## PROCESS ARGUMENTS
            TYPE=$1
            ARGUMENT=$2
            case $TYPE in
                -c) CODE=$(__getColorCode $ARGUMENT);;
                -b) CODE=$(__getBackgroundCode $ARGUMENT);;
                -e) CODE=$(__getEffectCode $ARGUMENT);;
                *)  CODE=""
            esac

            ## ADD CODE SEPARATOR IF NEEDED
            if [ "$FORMAT" != "" ]; then
                FORMAT="$FORMAT;"
            fi

            ## APPEND CODE
            FORMAT="$FORMAT$CODE"

            # Remove arguments from stack
            shift
            shift
        done

        ## APPLY FORMAT TO TEXT
        FORMAT_CODE=$(__getFormattingSequence $FORMAT)
        echo -n "${FORMAT_CODE}"
    fi
}

__getFormattingSequence() {
    START='\e[0;'
    MIDLE=$1
    END='m'
    echo -n "$START$MIDLE$END"
}

__getEffectCode() {
    EFFECT=$1
    NONE=0

    case $EFFECT in
        none)       echo $NONE;;
        default)    echo $NONE;;
        bold)       echo 1;;
        bright)     echo 1;;
        dim)        echo 2;;
        underline)  echo 4;;
        blink)      echo 5;;
        reverse)    echo 7;;
        hidden)     echo 8;;
        strikeout)  echo 9;;
        *) echo $NONE
    esac
}

__get8bitCode() {
    CODE=$1
    case $CODE in
        default)                echo 9;;
        none)                   echo 9;;
        black)                  echo 0;;
        red)                    echo 1;;
        green)                  echo 2;;
        yellow)                 echo 3;;
        blue)                   echo 4;;
        magenta|purple|pink)    echo 5;;
        cyan)                   echo 6;;
        light-gray)             echo 7;;
        dark-gray)              echo 60;;
        light-red)              echo 61;;
        light-green)            echo 62;;
        light-yellow)           echo 63;;
        light-blue)             echo 64;;
        light-magenta)          echo 65;;
        light-cyan)             echo 66;;
        white)                  echo 67;;
        *)                      echo 0
    esac
}

__getColorCode() {
    COLOR=$1

    ## Check if color is a 256-color code
    if [ $COLOR -eq $COLOR ] 2> /dev/null; then
        if [ $COLOR -gt 0 -a $COLOR -lt 256 ]; then
            echo "38;5;$COLOR"
        else
            echo 0
        fi
    ## Or if color key-workd
    else
        BITCODE=$(__get8bitCode $COLOR)
        COLORCODE=$(($BITCODE + 30))
        echo $COLORCODE
    fi
}

__getBackgroundCode() {
    COLOR=$1

    ## Check if color is a 256-color code
    if [ $COLOR -eq $COLOR ] 2> /dev/null; then
        if [ $COLOR -gt 0 -a $COLOR -lt 256 ]; then
            echo "48;5;$COLOR"
        else
            echo 0
        fi
    ## Or if color key-workd
    else
        BITCODE=$(__get8bitCode $COLOR)
        COLORCODE=$(($BITCODE + 40))
        echo $COLORCODE
    fi
}

__applyCodeToText() {
    local RESET=$(__getFormattingSequence $(__getEffectCode none))
    TEXT=$1
    CODE=$2
    echo -n "$CODE$TEXT$RESET"
}

