#!/bin/sh

if [ -z "$PASSWD" ]
then
    echo "FATAL: No password has been set, exiting."
    exit 1
fi

echo -e "$PASSWD\n$PASSWD" | sudo passwd default > /dev/null 2>&1
echo "Password set to $PASSWD"

sudo xrdp-sesman
exec sudo xrdp --nodaemon