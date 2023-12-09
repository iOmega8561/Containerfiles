#!/bin/sh

export ARGS="$@"

export PATH="/opt/wine-ge-custom/bin:$PATH"

if [[ $NVIDIA -eq 1 ]]
then
    echo "######### Installing NVIDIA Drivers ... ##########"
    echo "##################################################"
    echo -e "\n\n"
    sudo pacman -Syu nvidia-utils lib32-nvidia-utils --noconfirm --needed
    sudo pacman -Scc --noconfirm
fi

if [[ -z "${GAME}" ]]
then
    if [ $# -eq 0 ]
    then
        exec /bin/bash
    fi

    exec /bin/bash -c "$ARGS"
fi

exec $GAME/game.sh