#!/bin/sh

if [ -z "$PASSWD" ]
then
    echo "FATAL: No password has been set, exiting."
    exit 1
fi

echo -e "$PASSWD\n$PASSWD" | sudo passwd default > /dev/null 2>&1
echo "Password set to $PASSWD"

sudo touch /var/log/xrdp-sesman.log
sudo chown default:default /var/log/xrdp-sesman.log

xrdp-sesman -c $HOME/.config/xrdp/sesman.ini
exec xrdp --nodaemon -c $HOME/.config/xrdp/xrdp.ini