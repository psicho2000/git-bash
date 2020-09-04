#!/usr/bin/env bash

# Configure it in ~/.ssh/config

login() {
    local host="$1"

    # if arg is provided and host exists, login
    if [ ! -z "$host" ] && [[ "$(_extract_machines)" == *"$host"* ]]; then
        ssh "$@"
    else
        printf "Unknown host '%s'. Available machines: %s\\n" "${host}" "$(_extract_machines)"
    fi
}

_extract_machines() {
    local hosts
    hosts=$(grep -E "^Host [^*]" "$HOME"/.ssh/config)
    hosts=${hosts//Host/}
    # return value through command substitution
    echo "$hosts"
}

_login_completion() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    # shellcheck disable=SC2207
    COMPREPLY=($(compgen -W "$(_extract_machines)" -- "$cur"))
    return 0
}

alias l='login'
complete -F _login_completion login l
