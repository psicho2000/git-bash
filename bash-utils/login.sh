#!/bin/bash
# Configure it in ~/.ssh/config

login() {
    local host=$1

    # if arg is provided and host exists, login
    if [ ! -z "$host" ] && [[ "$(_extract_machines)" == *"$host"* ]]; then
        ConEmuC -Silent -GuiMacro Rename 0 "$host" >/dev/null 2>&1
        ssh $*
        ConEmuC -Silent -GuiMacro Rename 0 "git-bash" >/dev/null 2>&1
    else
        printf "Unknown host '%s'. Available machines: %s\\n" "${host}" "$(_extract_machines)"
    fi
}

_extract_machines() {
    local hosts=`egrep "^Host [^*]" $HOME/.ssh/config`
    hosts=${hosts//Host/}
    # return value through command substitution
    echo $hosts
}

_login_completion() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=( $(compgen -W "$(_extract_machines)" -- ${cur}) )
    return 0
}

alias l='login'
complete -F _login_completion login l
