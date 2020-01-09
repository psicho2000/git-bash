#!/bin/bash
if [[ ! -f "$HOME/.ssh/config" ]]; then
    cat <<EOT >> $HOME/.ssh/config
Host *
    Compression yes
    ServerAliveInterval 240

#Host host-alias
#    HostName host
#    IdentityFile $HOME/.ssh/keyfile
#    User user

#Host prefix*
#    Hostname %h.domain.com
#    IdentityFile $HOME/.ssh/keyfile
#    User user
EOT
fi

chmod 600 $HOME/.ssh/config