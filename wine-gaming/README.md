# wine-gaming
This image is based upon archlinux:base-devel and packs a custom wine build from Glorious Eggroll with dxvk and vkd3d-proton, from their respective AUR packages.

This podman-cli example is meant to be used with a NVIDIA gpu.
```
podman run -it --rm \
    --userns=keep-id \
    -v winegaming_games:/games \
    -v winegaming_data:/home/default \
    -v $XDG_RUNTIME_DIR/pipewire-0:$XDG_RUNTIME_DIR/pipewire-0 \
    -v $XAUTHORITY:$XAUTHORITY:ro \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rslave \
    -e DISPLAY="$DISPLAY" \
    -v /dev/dri:/dev/dri:rslave \
    -e GAME="somegame" \
    -e NVIDIA=1 \
    -v /dev/nvidia0:/dev/nvidia0 \
    -v /dev/nvidia-caps:/dev/nvidia-caps:rslave \
    -v /dev/nvidiactl:/dev/nvidiactl \
    -v /dev/nvidia-modeset:/dev/nvidia-modeset \
    -v /dev/nvidia-uvm:/dev/nvidia-uvm \
    -v /dev/nvidia-uvm-tools:/dev/nvidia-uvm-tools \
    localhost/wine-gaming:latest
```