#!/bin/bash

measure() {
    start=$(date +%s%N)
    eval $1 &>/dev/null
    end=$(date +%s%N)
    total=$((($end - $start)/1000000))
    echo "$1: $total ms"
}

measure "git rev-parse --is-inside-work-tree"
measure "git rev-parse --is-inside-git-dir"
measure "git update-index --really-refresh -q"
measure "git ls-files --others --exclude-standard"
measure "git diff-files --quiet --ignore-submodules --"
measure "git diff --quiet --ignore-submodules --cached"
measure "git rev-parse --verify refs/stash &>/dev/null"
measure "git rev-parse --abbrev-ref --symbolic-full-name @{u}"
measure "git rev-parse --abbrev-ref HEAD"
measure "git rev-list --right-only --count origin/master...master"
measure "git rev-list --left-only --count origin/master...master"
measure "git symbolic-ref --quiet --short HEAD"
