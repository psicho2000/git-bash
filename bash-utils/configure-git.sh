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
# Push unpublished branch
git config --global alias.publish '!git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)'

##### Resetting
# Undo Commit
git config --global alias.undo-commit 'reset --soft HEAD~1'
# Unstage a file
git config --global alias.unstage 'reset HEAD --'

##### Logs
# One-line log including branching in/out (last 30 commits)
git config --global alias.l "log --pretty=format:'%C(yellow)%h %<(30)%Cgreen%an%x09%C(black bold)%ad%x09%C(auto)%d%Creset %s' --date=format:'%Y-%m-%d %H:%M:%S' -30"
# One-line log including branching in/out (all commits)
git config --global alias.la "log --pretty=format:'%C(yellow)%h %<(30)%Cgreen%an%x09%C(black bold)%ad%x09%C(auto)%d%Creset %s' --date=format:'%Y-%m-%d %H:%M:%S'"
# One-line log including branching in/out and stats (last 15 commits)
git config --global alias.ls "log --pretty=format:'%C(yellow)%h %<(30)%Cgreen%an%x09%C(black bold)%ad%x09%C(auto)%d%Creset %s' --date=format:'%Y-%m-%d %H:%M:%S' -15 --stat"
# One-line log including branching in/out (graphical)
git config --global alias.hist "log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short"
# Last commit including stats
git config --global alias.last 'log -1 --stat HEAD'
# List contributors with number of commits
git config --global alias.contributors 'shortlog --summary --numbered'

##### Misc
# Status
git config --global alias.s 'status -sb'
# Alias to show all or specific aliases
git config --global alias.alias '!f() { git config --get-regexp "alias.$1*"; }; f'
git config --global alias.aliases "config --get-regexp 'alias.*'"
# Show verbose output about tags, branches or remotes
git config --global alias.tags 'tag -l'
git config --global alias.branches 'branch -a'
git config --global alias.remotes 'remote -v'

echo "Configuring git..."
# general git config
git config --global core.excludesfile '~/.gitignore_global'
# git config --global include.path .gitconfig # seems to be broken...
