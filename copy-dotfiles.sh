#!/bin/bash

dotfiles="$HOME/git-bash"

copy() {
  from="$1"
  to="$2"
  echo "Linking '$from' to '$to'"
  rm -f "$to"
  ln -s "$from" "$to"
}

if [[ -d "$dotfiles" ]]; then
  echo "Copying dotfiles from $dotfiles"
else
  echo "$dotfiles does not exist"
  exit 1
fi

cd $dotfiles

for location in $(find . -maxdepth 1 -type f -name '.*' -printf '%f\n'); do
  if [[ $location != "./.gitignore" ]]; then
    copy "$dotfiles/$location" "$HOME/$location"
    dos2unix "$HOME/$location"
  fi
done
