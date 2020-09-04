#!/usr/bin/env bash

count() {
    pad=$(printf '%0.1s' " "{1..60})
    padlength1=40
    padlength2=7
    padlength3=18
    echo "Directory                           Dirs  Files              Byte"
    for d in */; do
        dirs=$(find "./$d" -type d | wc -l)
        files=$(find "./$d" -type f | wc -l)
        size=$(du -bs "./$d" | cut -f1 | sed ':a;s/\B[0-9]\{3\}\>/.&/;ta')
        printf '%s' "$d"
        printf '%*.*s' 0 $((padlength1 - ${#d} - ${#dirs})) "$pad"
        printf '%s' "$dirs"
        printf '%*.*s' 0 $((padlength2 - ${#files})) "$pad"
        printf '%s' "$files"
        printf '%*.*s' 0 $((padlength3 - ${#size})) "$pad"
        printf '%s\n' "$size"
    done
}
