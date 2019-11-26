#!/bin/bash
# Call via `curl -Lks https://bit.ly/setup-cfg | /bin/bash`

function __cfg {
  /mingw64/bin/git --git-dir=$HOME/.git-bash --work-tree=$HOME $@
}

git clone --bare https://github.com/psicho2000/git-bash $HOME/.git-bash
__cfg config --local core.autocrlf input
__cfg config --local status.showUntrackedFiles no
__cfg checkout
__cfg push -u origin HEAD
$HOME/bash-utils/configure-git.sh
$HOME/bash-utils/configure-ssh.sh
cp $HOME/bash-utils/.settings.example $HOME/bash-utils/.settings
cp $HOME/bash-utils/.bash_prompt.sh $HOME/.config/git/git-prompt.sh
