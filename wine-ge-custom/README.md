# wine-gaming
This image is based upon archlinux:base-devel and packs a custom wine build from Glorious Eggroll with dxvk and vkd3d-proton, from their respective AUR packages.

This container is meant to be used for multiple games. All the necessary tools are packaged but games and their necessary launchers must be installed manually by using the container's command interface. 

Create your container with the following example (Omit all the nvidia lines if you don't have NVIDIA gpus)
```
podman container create --replace --name wine-ge-custom \
    --userns=keep-id \
    -v /where_games_are_stored:/games \
    -v /where_data_gets_stored:/home/default \
    -v $XDG_RUNTIME_DIR:$XDG_RUNTIME_DIR:rslave \
    -v /tmp:/tmp:rslave \
    -e DISPLAY="$DISPLAY" \
    -v /dev/dri:/dev/dri:rslave \
    -v /dev/nvidia0:/dev/nvidia0 \
    -v /dev/nvidiactl:/dev/nvidiactl \
    -v /dev/nvidia-modeset:/dev/nvidia-modeset \
    -v /dev/nvidia-uvm:/dev/nvidia-uvm \
    -v /dev/nvidia-uvm-tools:/dev/nvidia-uvm-tools \
    localhost/wine-gaming:latest
```
The start the container, it will update system packages and then will go to sleep
```
podman start wine-ge-custom
```
To create a new WINE prefix at path /where_games_are_stored/$GAME_NAME/prefix, you can use the bundled helper script with the following command
```
podman exec -it -e GAME="GameName" wine-ge-custom ct-winesetup
```
After you can execute a shell and manually install your game or launcher.
When you are done installing everything, place a wrapper script in the game folder like /where_games_are_stored/$GAME_NAME/wrapper.sh and run your application with the following command
```
podman exec -it -e GAME="GameName" wine-ge-custom ct-entrypoint arg1 arg2 ... argN
```
It will start your helper script and pass every argument to it