Intended for Git Bash in Windows

## Contents
bash-utils/
.bashrc
.gitignore-global
.inputrc
.minttyrc
.nanorc

## Usage
1. Clone this repository into %userprofile%
1. `~/git-bash/copy-dotfiles.sh`
1. `cp ~/git-bash/utils/.settings.example ~/git-bash/utils/.settings`
1. configure `.settings`

* To enable nano, check the appropriate box during installation and take care that line endings of .nanorc are Unix style (LF)

## Enabling multiple GitHub credentials
Normally, it should be possible to configure local credentials, which overwrite global (which override system).
This however does not work.
Workaround: use store for private credentials, manager for team credentials, swap using aliases:
1. Create `C:/Users/<user>/.git-credentials` (containing private credentials)
   `https://<user>:<password>@github.com`
2. Remove [credential] section from system config
   `git config --system -e`
3. Swap with provided aliases `team`, `priv` or use `push_wiki()`

## Creating private key authentication (e.g. for .login.sh)
On local system
    ssh-keygen.exe -t rsa -C "your.email@example.com"
Copy ~/.ssh/id_rsa.pub to remote system
On remote system
    touch ~/.ssh/authorized_keys
    cat id_rsa.pub >> ~/.ssh/authorized_keys