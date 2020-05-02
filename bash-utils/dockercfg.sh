#!/bin/bash

# docker
alias d='docker'
alias dal="docker-aliases"
alias de='docker-exec'
alias dgrep='docker-ps-format|grep'
alias di='docker-inspect'
alias dps='docker-ps-format'
alias dpsn='docker-ps-format-sort-by-name'

# docker-compose
alias dc='docker-compose'
alias dccp='docker-compose-copy't
alias dce='docker-compose-exec'
alias dcer='docker-compose-exec-root'
alias dcl='docker-compose logs -f --tail 500'
alias dcls='docker-compose-list'
alias dci='docker-compose-inspect'
alias dcu='docker-compose-update'

docker-aliases() {
    cat <<EOF
docker aliases
d       docker
        args: see docker
dal     print this help
        args: <none>
de      enter service's bash as default user
        args: container
dgrep   grep docker ps
        args: string
di      inspect a container
        args: substring of image name
dps     formatted docker ps, sorted by status time
        args: options of docker ps
dpsn    formatted docker ps, sorted by image name
        args: options of docker ps

docker compose aliases (autocompletion available for all commands)
dc      docker-compose
        args: see docker-compose
dccp    copy from or to service
        args: source target
dce     enter service's bash as default user
        args: servicename
dcer    enter service's bash as root
        args: servicename
dcl     log with follow, starting at last 500 lines
        args: [servicename...]
dcls    list directory content (default: /)
        args: servicename [directory]
dci     inspect a service
        args: servicename
dcu     update any number of services (pull and up)
        args: [servicename...]
EOF
}

docker-compose-copy() {
    if [ "$#" -ne 2 ]; then
        echo "Provide exactly 2 arguments."
        return 0;
    fi
    container_args=0
    if [[ $1 == *":"* ]]; then
      container_args=$((container_args+1))
      direction="from_container"
    fi
    if [[ $2 == *":"* ]]; then
      container_args=$((container_args+1))
      direction="to_container"
    fi
    if [ "$container_args" -ne 1 ]; then
        echo "Exactly one argument must refer to a container: CONTAINER:PATH."
        return 0;
    fi
    if [ "$direction" = "from_container" ]; then
        IFS=':' read -ra target <<< "$1"
        service="${target[0]}"
        path="${target[1]}"
        docker cp "$(docker-compose ps -q $service)":$path $2
    else
        IFS=':' read -ra target <<< "$2"
        service="${target[0]}"
        path="${target[1]}"
        docker cp $1 "$(docker-compose ps -q $service)":$path
    fi
}

docker-compose-exec() {
    docker-compose exec "$1" bash
}

docker-compose-exec-root() {
    docker-compose exec -u root "$1" bash
}

docker-compose-list() {
    docker-compose exec "$1" sh -c "ls -lAh --color=auto --group-directories-first $2"
}

docker-compose-inspect() {
    docker inspect "$(docker-compose ps -q $1)" | less
}

docker-compose-update() {
    docker-compose pull $*
    docker-compose up -d $*
}

docker-exec() {
    docker exec -it "$1" bash
}

docker-inspect() {
  docker ps|grep $1|awk -F'[[:space:]]+' '{print $1}'|xargs docker inspect|less
}

docker-ps-format() {
    docker ps $* --format 'table {{.ID}}\t{{.Image}}\t{{.RunningFor}}\t{{.Status}}\t{{.Ports}}'
}

docker-ps-format-sort-by-name() {
    docker-ps-format $*|awk 'NR<2{print $0;next}{print $0| "sort -k2"}'
}

### docker-compose completion
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

# https://salsa.debian.org/debian/bash-completion/blob/master/bash_completion
# This method is copied from bash completion: `declare -f _quote_readline_by_ref`
__quote_readline_by_ref_copied() {
    if [[ $1 == \'* ]]; then
        printf -v $2 %s "${1:1}"
    else
        printf -v $2 %q "$1"
    fi
    [[ ${!2} == \$* ]] && eval $2=${!2}
}

# This method is copied and adapted from bash completion: `declare -f _filedir`
__filedir_copied() {
    local IFS='
'
    local -a toks
    local x tmp
    x=$(compgen -d -- "$cur") && while read -r tmp; do
        toks+=("$tmp")
    done <<<"$x"
    if [[ "$1" != -d ]]; then
        local quoted
        __quote_readline_by_ref_copied "$cur" quoted
        local xspec=${1:+"!*.@($1|${1^^})"}
        x=$(compgen -f -X "$xspec" -- $quoted) && while read -r tmp; do
            toks+=("$tmp")
        done <<<"$x"
        [[ -n ${COMP_FILEDIR_FALLBACK:-} && -n "$1" && ${#toks[@]} -lt 1 ]] && x=$(compgen -f -- $quoted) && while read -r tmp; do
            toks+=("$tmp")
        done <<<"$x"
    fi
    if [[ ${#toks[@]} -ne 0 ]]; then
        compopt -o filenames 2>/dev/null
        COMPREPLY+=("${toks[@]}")
    fi
}

__docker_compose_copy_completion() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    __docker_compose_alias_completion
    __filedir_copied
}

complete -F __docker_compose_completion dc docker-compose
complete -F __docker_compose_alias_completion dcl dcu dce dcer dci dcls
complete -F __docker_compose_copy_completion dccp
