#!/bin/sh

if [ -z $GAME ]
then
    echo "GAME environment variable is not set. Exiting..."
    exit 1
fi

mkdir -p /games/$GAMES

export WINEPREFIX=/games/$GAME/prefix

if [ -d $WINEPREFIX ]
then
    echo -e "\n"
    echo "## WINEPREFIX found, skipping configuration ... ##"
    echo "##################################################"
else
    echo -e "\n"
    echo "############ Preparing WINEPREFIX ... ############"
    echo "##################################################"

    wineboot > /dev/null 2>&1
    sleep 10s

    echo -e "\n"
    echo "############## Installing dxvk ... ###############"
    echo "##################################################"

    setup_dxvk install > /dev/null 2>&1
    sleep 5s

    echo -e "\n"
    echo "########### Installing dxvk-nvapi ... ############"
    echo "##################################################"

    setup_dxvk_nvapi install > /dev/null 2>&1
    sleep 5s

    echo -e "\n"
    echo "############## Installing vkd3d ... ##############"
    echo "##################################################"

    setup_vkd3d_proton install > /dev/null 2>&1
    sleep 5s

    winetricks sandbox
    sleep 5s

    if [[ $NVIDIA -eq 1 ]]
    then
        cp /usr/lib/nvidia/wine/* $WINEPREFIX/dosdevices/c:/windows/system32/
    fi
fi