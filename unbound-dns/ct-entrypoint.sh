#!/usr/bin/env sh

echo -e "\n"
echo "############ Updating root hints ... #############"
echo "##################################################"

echo -e "\n"

wget -S https://www.internic.net/domain/named.cache -O .config/unbound/root.hints

echo -e "\n"
echo "############# Launching unbound ... ##############"
echo "##################################################"

echo -e "\n"

exec unbound -vvvdpc .config/unbound/unbound.conf