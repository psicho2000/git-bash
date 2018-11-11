#!/bin/bash
# Assumes it is used within Cmder/ConEmu. If used within git-bash, remove the lines starting with ConEmuC.
# Configure it in .settings.

function login() {
    local machine=$1
    local host identity
    
    # if no arg is provided and there is only one machine, take that one
    if [ -z "$machine" ] && [ ${#login_machines[@]} -eq "1" ]; then
        machine=${!login_machines[@]}
        echo "Logging into $machine"
    fi
    
    # if arg is provided and the list of machines is not empty, login
    if [ ! -z "$machine" ] && [ ${login_machines[$machine]+_} ]; then
        machine_setting=${login_machines[$machine]}
        ConEmuC -Silent -GuiMacro Rename 0 "$machine"
        # use custom private key
        if [[ "$machine_setting" =~ ";" ]]; then
            setting_parts=(${machine_setting//;/ })
            host=${setting_parts[0]}
            identity=${setting_parts[1]}
            ssh -i $login_identity_base_path/$identity $host
        # use default private key (~/.ssh/id_rsa)
        else
            ssh ${login_machines[$machine]}
        fi
        ConEmuC -Silent -GuiMacro Rename 0 "git-bash"
    else
        printf "Unknown machine '%s'. Available machines: %s\\n" "${machine}" "$(_extract_machines)"
    fi
}

_extract_machines() {
    local available_machines
    for machine in "${!login_machines[@]}"; do
        available_machines="$available_machines $machine";
    done
    # return value through command substitution
    echo $available_machines
}

_login() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=($(compgen -W "$(_extract_machines)" -- ${cur}))
    return 0
}

complete -F _login login
