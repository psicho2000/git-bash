#!/usr/bin/env bash

count() {
    local num_in_dir dir pad padlength1 padlength2 padlength3
    local dirs files subdir size

    if [[ $1 = "-h" || $1 = "--help" ]]; then
        chelp <<-EOF
		Count files and directories.

		Usage:
		    count [option] [directory]

		Options:
		    -h, --help  Print this help

		Arguments:
		    directory   Directory to count. pwd, if none provided.
		EOF
        return 0
    fi
    if [[ -n $1 ]]; then
        dir="$1"
    else
        dir=$(pwd)
    fi
    pad=$(printf '%0.1s' " "{1..60})
    padlength1=40
    padlength2=7
    padlength3=18

    # shellcheck disable=SC2012
    num_in_dir="$(ls -A "$dir" | wc --lines)"
    echo "$num_in_dir ${COLOR_CYAN}files and subdirs in directory ${COLOR_BROWN}$dir${COLOR_CYAN}; recursing:${COLOR_RESET}"
    echo "${COLOR_GRAY}Directory                           Dirs  Files              Byte${COLOR_RESET}"
    for d in "$dir/"*/; do
        # in this case, find is faster than fd
        dirs=$(find "$d" -type d | wc --lines)
        files=$(find "$d" -type f | wc --lines)
        subdir=${d#"$dir"}
        subdir=${subdir//\//}
        size=$(du --bytes --summarize "$d" | cut --fields=1 | sed ':a;s/\B[0-9]\{3\}\>/.&/;ta')
        printf '%s' "${COLOR_BLUE}$subdir${COLOR_RESET}"
        printf '%*.*s' 0 $((padlength1 - ${#subdir} - ${#dirs})) "$pad"
        printf '%s' "$dirs"
        printf '%*.*s' 0 $((padlength2 - ${#files})) "$pad"
        printf '%s' "$files"
        printf '%*.*s' 0 $((padlength3 - ${#size})) "$pad"
        printf '%s\n' "$size"
    done
}

alias count-lines="fdfind --type f --hidden --exclude '.git' | xargs file | rg 'ASCII|UTF-8' | cut --delimiter=':' --fields=1 | xargs cat | wc --lines"