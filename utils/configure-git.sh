#!/bin/bash

echo "Installing git aliases..."

##### Committing
# Stage everything & commit
git config --global alias.ac '!git add . && git commit -am'
# Stage changes & commit
git config --global alias.ci 'commit -am'
# Amend staged changes to the last commit, keeping the same commit message
git config --global alias.amend 'commit --amend -C HEAD'

##### Resetting
# Undo Commit
git config --global alias.undo-commit 'reset --soft HEAD~1'
# Unstage a file
git config --global alias.unstage 'reset HEAD --'

##### Checkout
# Shortcut for checkout
git config --global alias.co checkout
# Checkout the last branch you were on
git config --global alias.col 'checkout @{-1}'
# Checkout new branch
git config --global alias.new 'checkout -b'

##### Logs
# One-line logs including branching in/out
git config --global alias.hist 'log --pretty=format:"%h %ad | %s%d [%an]" --graph --date=short'
# Show last commit
git config --global alias.last 'log -1 HEAD'

# Delete all local branches that have already been merged to current branch
git config --global alias.clean-merged '!git branch --merged | grep -v \"\\*\" | xargs -n 1 git branch -d'

##### Misc
# Status
git config --global alias.st 'status -sb'
# Alias to show all aliases
git config --global alias.aliases "config --get-regexp 'alias.*'"

echo "Configuring git..."
# general git config
git config --global core.excludesfile '~/.gitignore_global'