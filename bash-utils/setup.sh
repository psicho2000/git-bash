#!/bin/bash
# Call via `curl -Lks https://bit.ly/setup-cfg | /bin/bash`

function __cfg {
  /mingw64/bin/git --git-dir=$HOME/.git-bash --work-tree=$HOME $@
}

cd ~
echo ".git-bash" >> .gitignore
git clone --bare https://github.com/psicho2000/git-bash $HOME/.git-bash
__cfg config --local core.autocrlf input
__cfg config --local status.showUntrackedFiles no
__cfg checkout
~/bash-utils/configure-git.sh
cp ~/bash-utils/.settings.example ~/bash-utils/.settings
exec bash -l
