#!/bin/bash

# Add & commit
git config --global alias.ac '!git add . && git commit -am'

# Undo Commit
git config --global alias.undo-commit 'reset --soft HEAD~1'

# Check out the last branch you were on
git config --global alias.col 'checkout @{-1}'

git config --global alias.new 'checkout -b'
git config --global alias.unstage 'reset HEAD --'
git config --global alias.co checkout
git config --global alias.last 'log -1 HEAD'