#!/bin/bash

THEME_CONFIG_FILE="$HOME/bash-utils/themes/.theme"

theme() {
    case "$1" in
        classic)
            echo ". ~/bash-utils/themes/classic" > "$THEME_CONFIG_FILE"
            exec bash -l
            ;;
        pureline)
            echo ". ~/bash-utils/themes/pureline ~/bash-utils/themes/.pureline.conf" > "$THEME_CONFIG_FILE"
            exec bash -l
            ;;
    esac
}

_theme_completion() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=( $(compgen -W "classic pureline" -- ${cur}) )
    return 0
}

if [[ -f "$THEME_CONFIG_FILE" ]]; then
    . "$THEME_CONFIG_FILE"
fi

complete -F _theme_completion theme
