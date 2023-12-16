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

    export DXVK_STATE_CACHE_PATH=/games/$GAME
	export VKD3D_SHADER_CACHE_PATH=/games/$GAME

    cd /games/$GAME

    winetricks sandbox
    sleep 5s

    chmod +x /games/$GAME/wrapper.sh
    /games/$GAME/wrapper.sh $ARGS

    exec wineserver --wait
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