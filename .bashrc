# Includes
. ~/git-bash/utils/.settings
. ~/git-bash/utils/.project_dir.sh
. ~/git-bash/utils/.login.sh

# Set directory colors
eval `dircolors ~/git-bash/utils/.dircolors`

# Set default editor
export EDITOR='nano'
export VISUAL='nano'

# Easier navigation: .., ..., ...., ....., ~ and -
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~' # `cd` is probably faster to type though
alias -- -='cd -'

alias d='winpty docker'
alias dc='winpty docker-compose'
alias dce='docker-compose-exec'
alias dcl='winpty docker-compose logs -f --tail 500'
alias dcu='docker-compose-update'
alias de='docker-exec'
alias desktop='cd $desktop_dir'
alias di='docker-inspect'
alias dps='docker-ps-format'
alias dpsn='docker-ps-format-sort-by-name'
alias g='./gradlew' # requires gradle and gradle wrapped projects
alias ll='ls -lAh --group-directories-first'
alias priv='git config --global credential.helper store'
alias reload='exec bash -l'
alias team='git config --global credential.helper manager'
alias wiki='cd $wiki_dir'

function docker-compose-exec() {
    winpty docker-compose exec "$1" bash
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
function push_wiki() {
    priv
    wiki
    git commit -am "$1"
    git push
    team
}

# History stuff
alias h='history'
alias hs="history-search"
alias hsi='history-search -i'
function history-search() {
    history | grep $*
}
