#!/usr/bin/env bash

echo "Cloning to $2 ..."

if [ -d "$2" ]
then
    echo "Already cloned, updating ..."
    git -C "$2" fetch --depth=1 || exit "$?"
    git -C "$2" reset --hard origin || exit "$?"
elif [ ! -z "$3" ]
then
    echo "Using tag $3"
    git clone -q --branch "$3" --depth=1 "$1" "$2" || exit "$?"
else
    git clone -q --depth=1 "$1" "$2" || exit "$?"
fi

echo "Done!"
