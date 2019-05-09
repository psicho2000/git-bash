#!/bin/bash
cat <<EOT >> $HOME/.ssh/config
Host *
    Compression yes
    ServerAliveInterval 240

#Host host-alias
#    HostName host
#    IdentityFile $HOME/.ssh/keyfile
#    User user
EOT

chmod 600 $HOME/.ssh/config