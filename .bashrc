# Set directory colors
eval `dircolors ~/bash-utils/.dircolors`

# Define colors
COLOR_CYAN=$(tput setaf 37);    export COLOR_CYAN
COLOR_RESET=$(tput sgr0);       export COLOR_RESET

# Set default editor
export EDITOR='vim'
export VISUAL='vim'
alias v='vim'

# Define starship config
export STARSHIP_CONFIG=$HOME/bash-utils/themes/starship

# Define pager
## do not page if output fits on screen, preserve colors, do not clear screen after quitting, smart case searching
export LESS='--quit-if-one-screen --RAW-CONTROL-CHARS --no-init --ignore-case'
export PAGER='less'

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
alias df='df --human-readable'
alias du='du --human-readable'
alias fdh='fd --hidden --no-ignore --exclude ".git" --follow --color=always'
alias greppath='path | grep --ignore-case'
alias gw='./gradlew' # requires gradle and gradle wrapped projects
alias here='explorer .'
alias ll='ls -l --almost-all --human-readable --color --group-directories-first'
alias ls='ls --color'
alias md='make-dir'
alias myip='curl -s ifconfig.me'
alias myipv6='curl -s ifconfig.co'
alias rd='rmdir'
alias rg='rg --smart-case'
alias rgh='rg --hidden --glob "!.git" --smart-case'
alias reload='exec bash --login'
alias pack='tar --create --gzip --verbose --file'
alias unpack='tar --extract --gunzip --verbose --file'
alias wiki='cd $WIKI_DIR'

# Determine size of a file or total size of a directory
file-size() {
    if du --bytes /dev/null >/dev/null 2>&1; then
        local arg="--bytes"
    else
        local arg=""
    fi
    if [[ "$#" -gt 0 ]]; then
        du --human-readable --summarize "$arg" -- "$@"
    else
        du --human-readable --summarize "$arg" .[^.]* ./*
    fi
}
alias fs='file-size'

# Lists the 20 most used commands
history-stats() {
    fc -l -100000000000 | \
        awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | \
        grep --invert-match "./" | \
        column -c 3 -s " " -t | \
        sort --numeric-sort --reverse | \
        nl | \
        head --lines=20
}

# Show what an alias or function does
explain() {
    local alias_result declarable alias_part found=false

    if [[ "$#" -eq 0 ]]; then
        alias_result=$(alias 2>&1)
    else
        alias_result=$(alias "$1" 2>&1)
    fi
    if [[ -n $alias_result && ! $alias_result =~ "not found" ]]; then
        if hash bat &> /dev/null; then
            echo "$alias_result" | bat --plain --language sh
        else
            echo "$alias_result"
        fi
        alias_part=${alias_result#*=}
        [[ $alias_part =~ ^\'.*\'$ ]] && alias_part=${alias_part:1:${#alias_part}-2}
        declarable=$alias_part
        found=true
    else
        declarable="$1"
    fi

    if declare -f "$declarable" >/dev/null; then
        if hash bat &> /dev/null; then
            declare -f "$declarable" | bat --style="numbers,grid" --language sh --color always
        else
            declare -f "$declarable" | cat
        fi
        found=true
    fi

    if [[ $found = false ]]; then
        command -v "$1"
    fi
}
alias ex='explain'

## Customize history
# Show timestamp of command execution in history
HISTTIMEFORMAT="%Y-%m-%d %T "
export HISTFILE=$HOME/.cache/bash_history
export HISTSIZE=100000
export HISTFILESIZE=200000
# Append commands to history file
shopt -s histappend
alias h='history'
history-search() {
    # do not print the last line, which is the current call
    history | grep --ignore-case "$@" | head --lines=-1
}
alias hs='history-search'

# create a directory recursively and cd to it
make-dir() {
    mkdir --parents "$@" && cd "$_";
}

path() {
    echo $PATH | sed --regexp-extended 's/:/\n/g'
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
# Use Git's colored diff when available; delta is better, though
diffgit() {
    git diff --no-index --color-words "$@"
}

## this is overwritten when config-environment.sh is loaded - which isn't in minimal installation
export GIT_PAGER='less'
alias g='git'
alias gc='git clone'
gd() {
    local infotext diffresult
    if [ -n "$(git diff 2>/dev/null)" ]; then
        infotext="${COLOR_CYAN}Showing diff${COLOR_RESET}"
        diffresult=$(git diff --color=always "$@")
    elif [ -n "$(git diff --cached 2>/dev/null)" ]; then
        infotext="${COLOR_CYAN}Showing staged${COLOR_RESET}"
        diffresult=$(git diff --color=always --cached "$@")
    else
        infotext="${COLOR_CYAN}Showing last commit${COLOR_RESET}"
        diffresult=$(git show --color=always "$@")
    fi
    echo -e "$infotext\n$diffresult" | eval "$GIT_PAGER"
}
## gl and gs rely upon git aliases from .gitconfig
alias gl='git l'
alias gp='git push'
alias gs='git s'
alias gu='git pull'
alias priv='git config --global credential.helper store'
alias team='git config --global credential.helper manager'

push_wiki() {
    priv
    wiki
    git commit -am "$1"
    git push
    team
}

# Used for the Ctrl+N shortcut
edit-current-file() {
    local valid_files=() file
    for file in "$@"; do
        # the only way I could find to replace vars (like $HOME) and ~
        file=$(eval "echo $file")
        if [[ -f $file ]]; then
            valid_files+=("$file")
        fi
    done
    # shellcheck disable=SC2068
    "$EDITOR" ${valid_files[@]}
}

# shellcheck disable=SC2016
bind -x '"\C-n":"edit-current-file $READLINE_LINE"'

# Clear screen
bind -x '"\eL": printf "\ec"'

sudo-command-line() {
    [[ -z $READLINE_LINE ]] && READLINE_LINE=$(fc -ln -0 | sed 's/^[ \t]*//')
    if [[ $READLINE_LINE == sudo\ * ]]; then
        READLINE_LINE="${READLINE_LINE#sudo }"
        ((READLINE_POINT-=5))
    elif [[ $READLINE_LINE == $EDITOR\ * ]]; then
        READLINE_LINE="${READLINE_LINE#$EDITOR }"
        READLINE_LINE="sudoedit $READLINE_LINE"
        local len=${#EDITOR}
        ((READLINE_POINT-=len+8))
    elif [[ $READLINE_LINE == sudoedit\ * ]]; then
        READLINE_LINE="${READLINE_LINE#sudoedit }"
        READLINE_LINE="$EDITOR $READLINE_LINE"
        local len=${#EDITOR}
        ((READLINE_POINT+=len-8))
    else
        READLINE_LINE="sudo $READLINE_LINE"
        ((READLINE_POINT+=5))
    fi
}
bind -x '"\C-f":"sudo-command-line"'

transpose_whitespace_words() {
    local prefix=${READLINE_LINE:0:$READLINE_POINT}
    local suffix=${READLINE_LINE:$READLINE_POINT}
    # cursor is at the end of line
    if [[ $suffix =~ ^[[:space:]]*$ && $prefix =~ ([^[:space:]][[:space:]]*)$ ]]; then
        prefix=${prefix%${BASH_REMATCH[0]}}
        suffix=${BASH_REMATCH[0]}${suffix}
    fi
    # cursor is in a word (prefix does not end with a space and suffix does not start with a space)
    if [[ $suffix =~ ^[^[:space:]] && $prefix =~ [^[:space:]]+$ ]]; then
        prefix=${prefix%${BASH_REMATCH[0]}}
        suffix=${BASH_REMATCH[0]}${suffix}
    fi
    # suffix starts with a space
    if [[ $suffix =~ ^[[:space:]]+ ]]; then
        prefix=${prefix}${BASH_REMATCH[0]}
        suffix=${suffix#${BASH_REMATCH[0]}}
    fi
    if [[ $prefix =~ ([^[:space:]]+)([[:space:]]+)$ ]]; then
        local word1=${BASH_REMATCH[1]}
        local space=${BASH_REMATCH[2]}
        prefix=${prefix%${BASH_REMATCH[0]}}
        if [[ $suffix =~ [^[:space:]]+ ]]; then
            local word2=${BASH_REMATCH[0]}
            suffix=${suffix#$word2}
            READLINE_LINE=${prefix}$word2$space$word1$suffix
            READLINE_POINT=$((${#prefix} + ${#word2} + ${#space} + ${#word1}))
        fi
    fi
}
bind -x '"\C-g": transpose_whitespace_words'

repeat_last_word() {
    local prefix=${READLINE_LINE:0:$READLINE_POINT}
    local suffix=${READLINE_LINE:$READLINE_POINT}
    local last_word
    # cursor is behind a non space
    if [[ $prefix =~ [^[:space:]]+$ ]]; then
        last_word=${BASH_REMATCH[0]}
        # cursor is before a non space
        if [[ $suffix =~ ^[^[:space:]]+ ]]; then
            last_word=${last_word}${BASH_REMATCH[0]}
        fi
    elif [[ $prefix =~ ([^[:space:]]+)[[:space:]]+$ ]]; then
        last_word=${BASH_REMATCH[1]}
    fi
    READLINE_LINE=${prefix}${last_word}${suffix}
    READLINE_POINT=$((${#prefix} + ${#last_word}))
}
bind -x '"\em": repeat_last_word'

# Go directory up with Ctrl+Alt+K
# keycode 201 does not exist, so using it as a hack
# The usage of the macro hides the 'cd ..'
bind -x '"\201": cd ..'
bind '"\e\C-k":"\C-u\201\C-m"'
# Ctrl+Alt+Up (\e[1;7A) not working, using Ctrl+Up instead
bind '"\e[1;5A":"\C-u\201\C-m"'

## Directory cycle
# Make pushd silent, except for help
pushd() {
    if [[ $1 = "--help" ]]; then
        command pushd "$@" || return
    else
        command pushd "$@" > /dev/null 2>&1 || return
    fi
}
cd() {
    if [[ $# -eq 0 ]]; then
        command cd || return
    else
        pushd "$@" || return
    fi
}
# keycodes 202 and 203 do not exist, so using it as a hack
# The usage of the macro hides the 'pushd ..'
# Cycle backwards
bind -x '"\202": pushd +1'
bind '"\e\C-h":"\C-u\202\C-m"'
bind '"\e[1;7D":"\C-u\202\C-m"'
# Cycle forwards
bind -x '"\203": pushd -0'
bind '"\e\C-l":"\C-u\203\C-m"'
bind '"\e[1;7C":"\C-u\203\C-m"'

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
