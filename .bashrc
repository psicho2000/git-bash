# Set directory colors
eval `dircolors ~/bash-utils/.dircolors`

# Set default editor
export EDITOR='vim'
export VISUAL='vim'

# Easier navigation: .., ..., ...., ....., ~ and -
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~' # `cd` is probably faster to type though
alias -- -='cd -'

# general aliases
alias cfg='/mingw64/bin/git --git-dir=$HOME/.git-bash --work-tree=$HOME'
alias count='~/bash-utils/count.sh'
alias g='git'
alias greppath='path|grep -i'
alias gw='./gradlew' # requires gradle and gradle wrapped projects
alias ll='ls -lAh --group-directories-first'
alias md='make-dir'
alias myip='curl -s ifconfig.me'
alias myipv6='curl -s ifconfig.co'
alias priv='git config --global credential.helper store'
alias reload='exec bash -l'
alias team='git config --global credential.helper manager'
alias wiki='cd $wiki_dir'

# autocomplete alternate git command
__git_complete g __git_main


# History stuff
alias h='history'
alias hs="history-search"
alias hsi='history-search -i'
function history-search() {
    history | grep $*
}

# ng autocomplete
_ng_completion () {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=( $(compgen -W "" -- ${cur}) )
    if [[ "$COMP_CWORD" -eq "1" ]]; then
        local commands="add analytics build config doc e2e generate help lint new run serve test update version xi18n"
        COMPREPLY=( $(compgen -W "${commands}" -- ${cur}) )
    fi
}
complete -o default -F _ng_completion ng

# Include last so that common aliases can be overridden in custom settings
. ~/bash-utils/dockercfg.sh
. ~/bash-utils/.settings
. ~/bash-utils/project_dir.sh
. ~/bash-utils/login.sh
. ~/bash-utils/colors.sh
. ~/bash-utils/themes/theme.sh