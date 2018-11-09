Intended for Windows

## Usage
1. Clone this repository into %userprofile%
1. ~/git-bash/symlink-dotfiles.sh
1. cp utils/.settings.example .settings
1. configure .settings

* To enable nano, check the appropriate box during installation and take care that line endings of .nanorc are Unix style (LF)

## Enabling multiple GitHub credentials
Normally, it should be possible to configure local credentials, which overwrite global (which override system).
This however does not work.
Workaround: use store for private credentials, manager for team credentials, swap using aliases:
1. Create C:/Users/<user>/.git-credentials (containing private credentials)
   https://<user>:<password>@github.com
2. Remove [credential] section from system config
   git config --system -e
3. Swap with provided aliases team, priv or use push_wiki()
