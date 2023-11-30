# UxPlay
This image is based upon archlinux:base-devel and packs an Open Soource AirPlay server

Although it is definitely possible to run the mDNS server inside the container, the best case scenario is to bind-mount the host sockets to simplify network discovery.

Assuming a user with uid=1000 and gid=1000, with podman's command-line this image can be run using the following commands 
```
# ROOTLESS
podman run -it --rm \
    --network host \
    --userns=keep-id \
    -v $XDG_RUNTIME_DIR/pipewire-0:$XDG_RUNTIME_DIR/pipewire-0 \
    -v $XAUTHORITY:$XAUTHORITY:ro \
    -v /run/dbus/system_bus_socket:/run/dbus/system_bus_socket \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e DISPLAY="$DISPLAY" \
    localhost/uxplay:latest

# ROOTFUL
sudo podman run -it --rm \
    --network host \
    -v $XDG_RUNTIME_DIR/pipewire-0:$XDG_RUNTIME_DIR/pipewire-0 \
    -v $XAUTHORITY:$XAUTHORITY:ro \
    -v /run/dbus/system_bus_socket:/run/dbus/system_bus_socket \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e DISPLAY="$DISPLAY" \
    localhost/uxplay:latest
```