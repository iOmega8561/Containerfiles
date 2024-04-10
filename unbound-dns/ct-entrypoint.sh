#!/usr/bin/env sh

update_root_hints() {
    wget -S https://www.internic.net/domain/named.cache -O .config/unbound/root.hints
}

update_every_day() {
    while [ true ]
    do
        sleep 86400
        update_root_hints
    done
}

echo -e "\n"
echo "############ Updating root hints ... #############"
echo "##################################################"
echo -e "\n"

update_root_hints

echo -e "\n"
echo "############# Launching unbound ... ##############"
echo "##################################################"
echo -e "\n"

update_every_day &
exec unbound -vvvdpc .config/unbound/unbound.conf