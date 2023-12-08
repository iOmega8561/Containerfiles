#!/bin/bash

export PATH="/opt/wine-ge-custom/bin:$PATH"

if [[ $NVIDIA -eq 1 ]]
then
    echo "######### Installing NVIDIA Drivers ... ##########"
    echo "##################################################"
    sudo pacman -S nvidia-utils lib32-nvidia-utils --noconfirm
fi

if [[ -z "${GAME}" ]]
then
    exec /bin/bash -c "$@"
else
    exec $GAME/game.sh
fi