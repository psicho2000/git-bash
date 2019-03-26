#!/bin/bash
echo "Host *" >> $HOME/.ssh/config
echo "ServerAliveInterval 240" >> $HOME/.ssh/config
chmod 600 $HOME/.ssh/config