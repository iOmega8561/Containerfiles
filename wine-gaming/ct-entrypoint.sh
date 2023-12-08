#!/bin/sh

if [[ $NVIDIA -eq 1 ]]
then
    echo "Installing NVIDIA Drivers ..."
    sudo pacman -S nvidia-utils lib32-nvidia-utils --noconfirm
fi

export PATH="/opt/wine-ge-custom/bin:$PATH"
exec /bin/bash