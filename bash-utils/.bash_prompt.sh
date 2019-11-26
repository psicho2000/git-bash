#!/bin/bash
# https://alanbarber.com/post/how-to-customize-the-git-for-windows-bash-shell-prompt/

function __git_status {
    local s;
    # Check if the current directory is in a Git repository.
    if [ $(git rev-parse --is-inside-work-tree &>/dev/null; echo "${?}") == '0' ]; then

        # check if the current directory is in .git before running git checks
        if [ "$(git rev-parse --is-inside-git-dir 2> /dev/null)" == 'false' ]; then

            # Ensure the index is up to date.
            git update-index --really-refresh -q &>/dev/null;

            # Check for uncommitted changes in the index.
            if ! $(git diff --quiet --ignore-submodules --cached); then
                s+='+';
            fi;

            # Check for unstaged changes.
            if ! $(git diff-files --quiet --ignore-submodules --); then
                s+='!';
            fi;

            # Check for untracked files.
            if [ -n "$(git ls-files --others --exclude-standard)" ]; then
                s+='?';
            fi;

            # Check for stashed files.
            if $(git rev-parse --verify refs/stash &>/dev/null); then
                s+='$';
            fi;

        fi;

        [ -n "${s}" ] && s=" [${s}]";
        echo -e "$s";
    fi;
}

PS1='\[\033]0;Git Bash\007\]'  # set window title
PS1+='\n'                      # new line
PS1+='\[\033[32m\]'            # change to green
PS1+='\u@\h '                  # user@host<space>
PS1+='\[\033[33m\]'            # change to brownish yellow
PS1+='\w'                      # current working directory
if test -z "$WINELOADERNOEXEC"
then
    GIT_EXEC_PATH="$(git --exec-path 2>/dev/null)"
    COMPLETION_PATH="${GIT_EXEC_PATH%/libexec/git-core}"
    COMPLETION_PATH="${COMPLETION_PATH%/lib/git-core}"
    COMPLETION_PATH="$COMPLETION_PATH/share/git/completion"
    if test -f "$COMPLETION_PATH/git-prompt.sh"
    then
        . "$COMPLETION_PATH/git-completion.bash"
        . "$COMPLETION_PATH/git-prompt.sh"
        PS1+='\[\033[36m\]'  # change color to cyan
        PS1+='`__git_ps1`'   # bash function
    fi
fi
PS1+='\[\033[34m\]`__git_status`' # change color to blue and show git status
PS1+='\[\033[0m\]'                # change color
PS1+='\n'                         # new line
PS1+='$ '                         # prompt: always $
