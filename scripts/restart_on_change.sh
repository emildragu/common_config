#!/bin/bash
#
# Maintainer: "Emil Dragu" <emi.dragu@webwave.ro>
# Copyright 2018
#
# Start a command in background, tipicaly a daemon or server and monitor current
# folder for changes. When changes occur, kill previous started process and run
# it again.
# Tipically usage for this is, make a development web server restart when files 
# are changed.
#
CMD="$*"

if [ "$*" == "" ]; then
    echo "Usage $0 COMMAND"
    exit 1
fi

echo "Running $CMD ..."
$CMD &
PID=$!

while true; do
    inotifywait --exclude ".*\.swp" -r -e modify .
    echo "Killing pid $PID!"
    kill -9 $PID
    echo "Running '$CMD' again ..."
    $CMD &
    PID=$!
done

