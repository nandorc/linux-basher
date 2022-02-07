#!/bin/bash

# Dependencies
source ~/.basher/lib/wrapper.sh

options=$(getRebuildedOptions $*)
printColoredMessage "Starting elasticsearch service..." --wrap-position begin $options
rm -f ~/.basher/src/elasticsearch/var/warning && touch ~/.basher/src/elasticsearch/var/warning && warning=""
if [ $(basher elasticsearch:status --output bool) -eq 1 ]; then
    printMessage "* elasticsearch service is currently running"
elif [ ! -f ~/.basher/src/elasticsearch/var/path ]; then
    warning="* elasticsearch service won't be started due to not elasticsearch root path defined. Use 'basher elasticsearch:set-path [path]' to define it and try again"
else
    elasticsearch_path=$(cat ~/.basher/src/elasticsearch/var/path)
    [ ! -z "$(echo $elasticsearch_path | grep "^~/")" ] && elasticsearch_path=~/"$(echo $elasticsearch_path | sed -e "s|~/||g")"
    if [ -z "$elasticsearch_path" ] || [ ! -f "$elasticsearch_path"/bin/elasticsearch ]; then
        warning="* elasticsearch service won't be started due to not valid elasticsearch root path. Use 'basher elasticsearch:set-path [path]' to define it and try again"
    else
        "$elasticsearch_path"/bin/elasticsearch -d -p pid
        while [ $(basher elasticsearch:status --output bool) -ne 1 ]; do
            sleep 2
        done
        rm -f ~/.basher/src/elasticsearch/var/pid && cp "$elasticsearch_path"/pid ~/.basher/src/elasticsearch/var/pid
        printMessage "* elasticsearch service started"
    fi
fi
[ -n "$warning" ] && echo "$warning" >>~/.basher/src/elasticsearch/var/warning && printWarningMessage "$warning"
printColoredMessage "starting process finished" --wrap-position end $options
unset serviceName options
