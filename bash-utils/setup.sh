#!/bin/bash
# Call via `curl -Lks https://bit.ly/setup-cfg | /bin/bash`

cd ~
alias cfg='/mingw64/bin/git --git-dir=$HOME/.git-bash --work-tree=$HOME'
echo ".git-bash" >> .gitignore
git clone --bare https://github.com/psicho2000/git-bash $HOME/.git-bash
cfg config --local core.autocrlf input
cfg config --local status.showUntrackedFiles no
cfg checkout
bash-utils/configure-git.sh
cp ~/bash-utils/.settings.example ~/bash-utils/.settings
