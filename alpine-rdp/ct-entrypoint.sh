#!/usr/bin/env sh

if [ -z "$PASSWD" ]
then
    echo "FATAL: No password has been set, exiting."
    exit 1
fi

lc_all=${LC_ALL:-C.UTF-8}
lang=${LANG:-C.UTF-8}

cat <<EOF > /etc/profile.d/locale.sh
export LANG="${lang}"
export LC_ALL="${lc_all}"
EOF

echo -e "$PASSWD\n$PASSWD" | sudo passwd default > /dev/null 2>&1
echo "Password set to $PASSWD"

sudo xrdp-sesman
exec sudo xrdp --nodaemon