# Set directory colors
eval `dircolors ~/bash-utils/.dircolors`

# Set default editor
export EDITOR='vim'
export VISUAL='vim'

# Define starship config
export STARSHIP_CONFIG=$HOME/bash-utils/themes/starship

# Easier navigation: .., ..., ...., ....., ~ and -
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~' # `cd` is probably faster to type though
alias -- -='cd -'

# general aliases
alias cat='bat'
alias desktop='cd $DESKTOP_DIR'
alias df='df -h'
alias du='du -h'
alias fdh='fd --hidden --no-ignore --exclude ".git" --follow --color=always'
alias greppath='path|grep -i'
alias gw='./gradlew' # requires gradle and gradle wrapped projects
alias here='explorer .'
alias ll='ls -lAh --group-directories-first'
alias md='make-dir'
alias myip='curl -s ifconfig.me'
alias myipv6='curl -s ifconfig.co'
alias rd='rmdir'
alias rg='rg --smart-case'
alias rgh='rg --hidden --glob "!.git" --smart-case'
alias reload='exec bash -l'
alias tar-compress-gz='tar -czvf'
alias tar-extract-gz='tar -xzvf'
alias wiki='cd $WIKI_DIR'

# Show what an alias or function does
explain() {
    local alias_result
    local declarable
    local alias_part

    if [[ "$#" -eq 0 ]]; then
        alias_result=$(alias 2>&1)
    else
        alias_result=$(alias "$1" 2>&1)
    fi
    if [[ -n $alias_result && ! $alias_result =~ "not found" ]]; then
        echo "$alias_result" | bat --style="plain" --language sh
        alias_part=${alias_result#*=}
        [[ $alias_part =~ ^\'.*\'$ ]] && alias_part=${alias_part:1:${#alias_part}-2}
        declarable=$alias_part
    else
        declarable=$1
    fi

    if declare -f "$declarable" >/dev/null; then
        declare -f "$declarable" | bat --style="numbers,grid" --language sh
    fi
}
alias ex='explain'

# History stuff
alias h='history'
alias hs="history-search"
alias hsi='history-search -i'
history-search() {
    history | grep $*
}

# create a directory recursively and cd to it
make-dir() {
    mkdir -p "$@" && cd "$_";
}

path() {
    echo $PATH|sed -E 's/:/\n/g'
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

### git

alias cfg='/mingw64/bin/git --git-dir=$HOME/.git-bash --work-tree=$HOME'
alias g='git'
alias gc='git clone'
gd() {
    if [ -n "$(git diff 2>/dev/null)" ]; then
        git diff
    else
        git show
    fi
}
alias gl='git l'
alias gp='git push'
alias gs='git s'
alias gu='git pull --rebase'
alias priv='git config --global credential.helper store'
alias team='git config --global credential.helper manager'

push_wiki() {
    priv
    wiki
    git commit -am "$1"
    git push
    team
}

# autocomplete alternate git command
__git_complete g __git_main

### Includes
# Include last so that common aliases can be overridden in custom settings
. ~/bash-utils/fzf/fzf_config
. ~/bash-utils/fzf/completion.bash
. ~/bash-utils/fzf/key-bindings.bash
. ~/bash-utils/dockercfg.sh
. ~/bash-utils/.settings
. ~/bash-utils/project_dir.sh
. ~/bash-utils/login.sh
. ~/bash-utils/colors.sh
. ~/bash-utils/count.sh
. ~/bash-utils/themes/theme.sh
# curl -O https://raw.githubusercontent.com/rupa/z/master/z.sh ~/bash-utils && chmod +x ~/bash-utils/z.sh
. ~/bash-utils/z.sh
