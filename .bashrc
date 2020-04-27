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

alias cfg='/mingw64/bin/git --git-dir=$HOME/.git-bash --work-tree=$HOME'
alias count='~/bash-utils/count.sh'
alias d='winpty docker'
alias dc='winpty docker-compose'
alias dce='docker-compose-exec'
alias dcer='docker-compose-exec-root'
alias dcl='winpty docker-compose logs -f --tail 500'
alias dcu='docker-compose-update'
alias de='docker-exec'
alias desktop='cd $desktop_dir'
alias dgrep='docker-ps-format|grep'
alias di='docker-inspect'
alias dps='docker-ps-format'
alias dpsn='docker-ps-format-sort-by-name'
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

function docker-compose-exec() {
    winpty docker-compose exec "$1" bash
}
function docker-compose-exec-root() {
    winpty docker-compose exec -u root "$1" bash
}
function docker-compose-update() {
    winpty docker-compose stop $*
    winpty docker-compose pull $*
    winpty docker-compose up -d $*
}
function docker-exec() {
    winpty docker exec -it "$1" bash
}
function docker-inspect() {
  docker ps|grep $1|awk -F'[[:space:]]+' '{print $1}'|xargs docker inspect|less
}
function docker-ps-format() {
    docker ps $* --format 'table {{.ID}}\t{{.Image}}\t{{.RunningFor}}\t{{.Status}}\t{{.Ports}}'
}
function docker-ps-format-sort-by-name() {
    docker-ps-format $*|awk 'NR<2{print $0;next}{print $0| "sort -k2"}'
}
function explain() {
    alias_result=$(alias $1 2>&1)
    if [[ ! $alias_result =~ "not found" ]]; then
        echo $alias_result
        alias_part=${alias_result#*\'}
        alias_part=${alias_part:0:${#alias_part}-1}
        declare -f $alias_part
    fi
    declare -f $1
}
# create a directory recursively and cd to it
function make-dir() {
        mkdir -p "$@" && cd "$_";
}
function path() {
    echo $PATH|sed -E 's/:/\n/g'
}
function push_wiki() {
    priv
    wiki
    git commit -am "$1"
    git push
    team
}

# docker-compose completion
__get_docker_compose_services() {
    if ls docker-compose* 1> /dev/null 2>&1; then
        echo $(egrep -h '^[[:blank:]]{2}[a-z-]+:' docker-compose*.yml | sort --unique | tr -d '[:space:]' | tr ':' ' ')
    else
        # we are not in a directory with docker-compose* files
        echo ""
    fi
}
__docker_compose_completion() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local commands="build bundle config create down events exec help images kill logs pause port ps pull push restart rm run start stop top unpause up version"
    if [[ "$COMP_CWORD" -eq 1 ]]; then
        COMPREPLY=($(compgen -W "${commands}" -- ${cur}))
    elif [[ "$COMP_CWORD" -gt 1 ]]; then
        case ${COMP_WORDS[1]} in
        build | create | events | exec | images | kill | logs | pause | port | ps | pull | push | restart | rm | run | start | stop | top | unpause | up)
            local services=$(__get_docker_compose_services)
            COMPREPLY=($(compgen -W "${services}" -- ${cur}))
            ;;
        help)
            COMPREPLY=($(compgen -W "${commands}" -- ${cur}))
            ;;
        *) ;;
        esac
    fi
    return 0
}
__docker_compose_alias_completion() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local services=$(__get_docker_compose_services)
    COMPREPLY=($(compgen -W "${services}" -- ${cur}))
    return 0
}
complete -F __docker_compose_completion dc docker-compose
complete -F __docker_compose_alias_completion dcl dcu dce dcer

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
. ~/bash-utils/.settings
. ~/bash-utils/project_dir.sh
. ~/bash-utils/login.sh
. ~/bash-utils/colors.sh
. ~/bash-utils/themes/theme.sh
