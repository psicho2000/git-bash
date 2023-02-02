Intended for Git Bash for Windows

## Contents
* bash-utils/
* .bashrc
* .gitignore
* .gitignore_global
* .inputrc
* .minttyrc
* .nanorc
* .vimrc
* README.md

## Usage
    1. Install Git for Windows*
    1. `curl -Lks https://bit.ly/setup-cfg | /bin/bash`
       `curl -Lks https://vipc.de/setup-cfg | /bin/bash` (alternatively)
       (or call `./bash-utils/setup.sh`)
### Optional
    1. Configure `.settings`
    1. Configure `~/.ssh/config` (for more info, see https://linux.die.net/man/5/ssh_config)
       On Windows, make sure all keyfiles and config itself have appropriate rights:
           .ssh > Properties > Security > Advanced
               * Disable inheritance
               * Only current user may access this file
    1. Theme can be chosen using `theme` command. If using pureline:
      1. Install a powerline font, e.g. Cascadia Code PL from https://github.com/microsoft/cascadia-code
      1. Use the chosen powerline font in your desired Console Host
      1. Configure `themes/.pureline.conf`
    1. Add a repository specific URL (in case of ssh: `"git@github.com:<username>/")` shorthand in .gitconfig, e.g.:
       ```
        [url "https://github.com/<username>/"]
            insteadOf = "gh:"
       ```
    1. If you have writing access to the repo, add a remote:
      1. Log in to your git repo to be able to configure push
      1. `cfg push -u origin HEAD`
    1. If using neovim:
       ```
       mkdir $LOCALAPPDATA/nvim
       vim $LOCALAPPDATA/nvim/init.vim
       ```
       Then set the contents of that file to the following (note: there are no symlinks in windows):
       ```
       set runtimepath^=~/.vim runtimepath+=~/.vim/after
       let &packpath=&runtimepath
       source ~/.vimrc
       ```

*_To enable nano, check the appropriate box during installation. setup.sh takes care that line endings of .nanorc are Unix style (LF)._

## Enabling multiple GitHub credentials
Normally, it should be possible to configure local credentials, which overwrite global (which override system).
This however does not work.
Workaround: use store for private credentials, manager-core for team credentials, swap using aliases:
1. Create `C:/Users/<user>/.git-credentials` (containing private credentials)
   * `https://<user>:<password>@github.com`
2. Remove [credential] section from system config (needs an admin user)
   * `git config --system -e`
3. Swap with provided aliases `team`, `priv` or use `push_wiki()`
4. To change credentials in Windows Credential Manager, open the search box and type "credential manager" (en) or "Anmeldeinformationsverwaltung" (de).

## Creating private key authentication (e.g. for login.sh)
* On local system
  * `ssh-keygen.exe -t rsa -C "your.email@example.com"`
  * Copy `~/.ssh/id_rsa.pub` to remote system
* On remote system
  * `touch ~/.ssh/authorized_keys`
  * `cat id_rsa.pub >> ~/.ssh/authorized_keys`

## Some note worthy tools
https://ranger.github.io/
https://github.com/jesseduffield/lazydocker
https://github.com/jesseduffield/lazygit

Thanks to https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/
