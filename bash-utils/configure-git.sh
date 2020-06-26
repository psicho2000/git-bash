#!/bin/bash

echo "Installing git aliases..."

##### Checkout
# Shortcut for checkout
git config --global alias.co checkout
# Checkout the last branch you were on
git config --global alias.col 'checkout @{-1}'
# Checkout new branch
git config --global alias.new 'checkout -b'

##### Commit & push
# Stage everything & commit
git config --global alias.ac '!git add . && git commit -am'
# Stage changes & commit (a.k.a. "checkin")
git config --global alias.ci 'commit -am'
# Amend staged changes to the last commit, keeping the same commit message
git config --global alias.amend 'commit --amend -C HEAD'
# Rename last commit
git config --global alias.rename 'commit --amend'
# Push unpublished branch
git config --global alias.publish '!git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)'

##### Resetting & cleanup
# Undo Commit
git config --global alias.undo-commit 'reset --soft HEAD~1'
# Unstage a file
git config --global alias.unstage 'reset HEAD --'
# Drop the given number of commits, defaults to 1
git config --global alias.drop-commits '!f() { [[ $1 =~ ^[0-9]+$ ]] && num=$1 || num=1; git reset --hard HEAD~$num; }; f'
# Join the given number of commits, defaults to 2
git config --global alias.join '!f() { [[ $1 =~ ^[0-9]+$ ]] && num=$1 || num=2; git rebase -i HEAD~$num; }; f'
# Delete local branches without a remote
git config --global alias.prune-branches '!git remote prune origin && git branch -vv | grep '"'"': gone]'"'"' | awk '"'"'{print $1}'"'"' | xargs -r git branch -D'
# Reset to remote, overwriting any differing local history
git config --global alias.hard-reset '!git reset --hard origin/$(git rev-parse --abbrev-ref HEAD)'

##### Logs
# One-line log including branching in/out (last 30 commits)
git config --global alias.l "log --pretty=format:'%C(yellow)%h %<(30)%Cgreen%an%x09%C(black bold)%ad%x09%C(auto)%d%Creset %s' --date=format:'%Y-%m-%d %H:%M:%S' -30"
# One-line log including branching in/out (all commits)
git config --global alias.la "log --pretty=format:'%C(yellow)%h %<(30)%Cgreen%an%x09%C(black bold)%ad%x09%C(auto)%d%Creset %s' --date=format:'%Y-%m-%d %H:%M:%S'"
# One-line log including branching in/out and stats (long listing, last 15 commits)
git config --global alias.ll "log --pretty=format:'%C(yellow)%h %<(30)%Cgreen%an%x09%C(black bold)%ad%x09%C(auto)%d%Creset %s' --date=format:'%Y-%m-%d %H:%M:%S' -15 --stat"
# One-line log including branching in/out (graphical)
git config --global alias.hist "log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short"
# Last commit including stats
git config --global alias.last 'log -1 --stat HEAD'
# Specific commit including stats
git config --global alias.ls 'log -1 --stat'
# List contributors with number of commits
git config --global alias.contributors 'shortlog --summary --numbered'

##### Editing
# Change permissions (view with `git ls-files --stage`)
git config --global alias.chmod '!f() { git update-index --chmod=$1 "`pwd`/$2"; }; f'

##### Misc
# Status
git config --global alias.s 'status -sb'
# Alias to show all or specific aliases
git config --global alias.alias '!f() { git config --get-regexp "alias.$1*"; }; f'
# Show verbose output about tags, branches or remotes
git config --global alias.tags 'tag -l'
git config --global alias.branches 'branch -a'
git config --global alias.remotes 'remote -v'
git config --global alias.local-branches '!git branch -vv | grep ": gone]"'

echo "Configuring git..."
# general git config
git config --global core.excludesfile '~/.gitignore_global'
git config --global core.editor 'vim'
git config --global help.autocorrect 20

# Enable long paths
## https://stackoverflow.com/questions/22575662/filename-too-long-in-git-for-windows
## See also https://docs.microsoft.com/en-us/windows/win32/fileio/naming-a-file#maximum-path-length-limitation
git config --global core.longpaths true

# The following interferes with global config and git-bash - therefore permanently disabled
# i.e. global config ~/.gitconfig overwrites local config of git-bash instead in reverse
# git config --global include.path .gitconfig
