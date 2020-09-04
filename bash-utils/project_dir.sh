#!/usr/bin/env bash

alias pj='project-dir'

project-dir() {
    if [ -z "$1" ]; then
        cd $PROJECT_DIR
        cat << EOF
Usage: project-dir [directory]
    directory will be searched in defined PROJECT_DIR (currently being '$PROJECT_DIR')
    directory can be a substring of actual directory
EOF
        return
    fi
    subdirs=(`find $PROJECT_DIR -mindepth 1 -maxdepth 1 -type d -printf '%f\n'|grep $1`)
    dircount=${#subdirs[@]}
    if [ "$dircount" -eq "0" ]; then
        echo "No directory matching '$1' found under '$PROJECT_DIR'."
    elif [ "$dircount" -eq "1" ]; then
        cd $PROJECT_DIR/${subdirs[0]}
    else
        # in case of an exact match, change dir
        for i in "${subdirs[@]}"
        do
            if [ "$i" = "$1" ]; then
                cd $PROJECT_DIR/$1
                return
            fi
        done

        echo "Found multiple directories matching '$1':"
        for i in "${subdirs[@]}"
        do
            echo "    $i"
        done
    fi
}

_project_dir_completion() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local subdirs=`find $PROJECT_DIR -mindepth 1 -maxdepth 1 -type d -printf '%f '`
    COMPREPLY=( $(compgen -W "${subdirs}" -- ${cur}) )
    return 0
}
complete -F _project_dir_completion project-dir pj
