# !$ - argument of last command
# ToDo: evaluate https://www.digitalocean.com/community/tutorials/how-to-use-sshfs-to-mount-remote-file-systems-over-ssh (maybe in WSL2?)

# Easier navigation: .., ..., ...., ....., ~ and -
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~' # `cd` is probably faster to type though
alias -- -='cd -'

declare -a __forward_dir_hist
# change directory and push it onto stack; if argument is a file, open it in the default editor
function cd() {
    if [ "$#" = "0" ]; then
        pushd ${HOME} > /dev/null
    elif [ -f "${1}" ]; then
        ${EDITOR} ${1}
    else
        pushd "$1" > /dev/null
    fi
}
# go back on or more directories and push it onto forward history stack
function bd(){
    local dirs=$(dirs -p -l)
    IFS=$'\n' read -rd '' -a last_dirs <<<"$dirs"
    last_dir=${last_dirs[0]}
    if [ "${#last_dirs[*]}" -gt "1" ]; then
        __forward_dir_hist+=("$last_dir")
        if [ "$#" = "0" ]; then
            popd > /dev/null
        else
            for i in $(seq ${1}); do
                popd > /dev/null
            done
        fi
    fi
}
# go forward one directory according to forward stack
function fd() {
    if [ ${#__forward_dir_hist[*]} -eq "0" ]; then
        return
    fi
    local forward_dir=${__forward_dir_hist[-1]}
    unset '__forward_dir_hist[${#__forward_dir_hist[@]}-1]'
    cd "$forward_dir"
}
