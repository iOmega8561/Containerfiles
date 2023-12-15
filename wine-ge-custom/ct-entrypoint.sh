#!/bin/sh

export ARGS="$@"

if ! [ -z $GAME ]
then
    export WINEPREFIX=/games/$GAME/prefix

    if ! [ -f /games/$GAME/wrapper.sh ]
    then
        echo "##################################################"
        echo "######### FATAL: Game wrapper not found ##########"
        echo "##################################################"
        exit 1
    fi

    chmod +x /games/$GAME/wrapper.sh
    exec /games/$GAME/wrapper.sh $ARGS
fi

if [[ -z "${ARGS}" ]]
then
    echo -e "\n"
    echo "########## Updating system packages ... ##########"
    echo "##################################################"
    sudo pacman -Syu --noconfirm --needed > /dev/null 2>&1
    sudo pacman -Scc --noconfirm > /dev/null 2>&1

    echo -e "\n"
    echo "############ Entering sleep state ... ############"
    echo "##################################################"
    trap exit INT TERM
    sleep infinity
fi

exec $ARGS