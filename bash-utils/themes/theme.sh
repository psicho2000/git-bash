#!/bin/bash

THEME_CONFIG_FILE="$HOME/bash-utils/themes/.theme"

theme() {
    case "$1" in
        classic)
            echo ". ~/bash-utils/themes/classic" > "$THEME_CONFIG_FILE"
            exec bash -l
            ;;
        diesire)
            echo ". ~/bash-utils/themes/diesire" > "$THEME_CONFIG_FILE"
            exec bash -l
            ;;
        pureline)
            echo ". ~/bash-utils/themes/pureline ~/bash-utils/themes/.pureline.conf" > "$THEME_CONFIG_FILE"
            exec bash -l
            ;;
        starship)
            eval "$(starship init bash)"
            echo "eval \"\$(starship init bash)\"" >"$THEME_CONFIG_FILE"
            ;;
    esac
}

_theme_completion() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=( $(compgen -W "classic diesire pureline starship" -- ${cur}) )
    return 0
}

if [[ -f "$THEME_CONFIG_FILE" ]]; then
    . "$THEME_CONFIG_FILE"
fi

complete -F _theme_completion theme
