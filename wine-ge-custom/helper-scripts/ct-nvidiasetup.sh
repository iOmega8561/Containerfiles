#!/bin/sh

BASE_URL="https://us.download.nvidia.com/XFree86/Linux-x86_64"

echo -e "\n"
echo "########## Checking module version ... ###########"
echo "##################################################"

DRIVER_VERSION=$(cat /sys/module/nvidia/version)

if [ -z "$DRIVER_VERSION" ] || ! [ -f /sys/module/nvidia/version ]
then
    echo "##################################################"
    echo "##### FATAL: NVIDIA Kernel module not loaded #####"
    echo "##################################################"
    exit 1
fi

echo -e "\n"
echo "KERNEL MODULE VERSION: $DRIVER_VERSION"

echo -e "\n"
echo "######### Trying to download package ... #########"
echo "##################################################"

curl -fl $BASE_URL/$DRIVER_VERSION/NVIDIA-Linux-x86_64-$DRIVER_VERSION.run -o /tmp/NVIDIA-$DRIVER_VERSION.run

if ! [ -f "/tmp/NVIDIA-$DRIVER_VERSION.run" ]
then
    echo "##################################################"
    echo "########## FATAL: Something went wrong ###########"
    echo "##################################################"
    exit 1
fi

chmod +x "/tmp/NVIDIA-$DRIVER_VERSION.run"

echo -e "\n"
echo "########## Starting driver installer ... #########"
echo "##################################################"

sudo /tmp/NVIDIA-$DRIVER_VERSION.run --no-kernel-modules --silent --no-systemd
rm /tmp/NVIDIA-$DRIVER_VERSION.run

echo -e "\n"
echo "##### NVIDIA libs installation completed ... #####"
echo "##################################################"