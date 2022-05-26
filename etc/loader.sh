#!/bin/bash

# Load dependencies
source ~/.basher/lib/colorhandler.sh

# Init message
clear && echo -e "$(color green)START:$(color none) Load Basher for Linux"

# Include Bash Utilities bin folder to path
if [ -n "$(echo $PATH | grep "~/.basher/bin")" ]; then
    echo -e "$(color yellow)WARNING:$(color none) Basher bin folder is already on PATH"
else
    PATH="$PATH:~/.basher/bin"
    echo -e "$(color blue)INFO:$(color none) Basher bin folder included on PATH"
fi

# Load basher configurations
basher_commands=$(find ~/.basher/src/* -maxdepth 0 -type d)
basher_commands_array=(${basher_commands// / }) && unset basher_commands
basher_commands_home=~/.basher/src/
for basher_command_dir in "${basher_commands_array[@]}"; do
    basher_command=$(echo $basher_command_dir | sed -e "s|$basher_commands_home||g")
    [ -f "$basher_command_dir"/etc/variables.sh ] && . "$basher_command_dir"/etc/variables.sh && echo -e "$(color blue)INFO:$(color none) $basher_command variables included"
    [ -f "$basher_command_dir"/etc/aliases.sh ] && . "$basher_command_dir"/etc/aliases.sh && echo -e "$(color blue)INFO:$(color none) $basher_command aliases included"
    [ -f "$basher_command_dir"/etc/style.sh ] && . "$basher_command_dir"/etc/style.sh && echo -e "$(color blue)INFO:$(color none) $basher_command styles included"
    [ -f "$basher_command_dir"/etc/settings.sh ] && . "$basher_command_dir"/etc/settings.sh && echo -e "$(color blue)INFO:$(color none) $basher_command settings included"
    unset basher_command
done
unset basher_commands_array basher_commands_home basher_command_dir

# End message
echo -e "$(color green)FINISH:$(color none) Basher for Linux loaded" && unset color && sleep 1 && clear
