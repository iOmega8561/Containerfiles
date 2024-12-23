# UxPlay

This container provides a ready-to-use instance of [UxPlay](https://github.com/FDH2/UxPlay), an open-source implementation of the AirPlay streaming server for Apple devices. The image is based on the official Alpine Linux container.

## Features
- **AirPlay Streaming**: Seamless streaming from Apple devices to a Linux host.
- **Flexible Configuration**: Supports both Xorg and Wayland desktop environments.
- **Simplified Network Discovery**: Uses host-mounted sockets to streamline mDNS and reduce complexity.

## Building the Image

Build the image using the following command:

```bash
podman build --tag airplay-server:latest .
```

This command creates a local container image tagged as `airplay-server:latest`.

## Configuration and Usage

### Running the Container

You can run the container directly using the `podman` command. Below are examples for Xorg and Wayland:

#### Xorg Example

```bash
podman run -it --rm \
    --network host \
    --userns=keep-id \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rslave \
    -v /run/dbus/system_bus_socket:/run/dbus/system_bus_socket \
    -e DISPLAY="$DISPLAY" \
    localhost/airplay-server:latest
```

#### Wayland Example

```bash
podman run -it --rm \
    --network host \
    --userns=keep-id \
    -v $XDG_RUNTIME_DIR/pipewire-0:$XDG_RUNTIME_DIR/pipewire-0 \
    -v $XDG_RUNTIME_DIR/wayland-0:$XDG_RUNTIME_DIR/wayland-0 \
    -v /run/dbus/system_bus_socket:/run/dbus/system_bus_socket \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rslave \
    -e DISPLAY="$DISPLAY" \
    localhost/airplay-server:latest
```

### Notes
- **Environment Variables**:
  - `DISPLAY`: Specifies the display server (default is `:0`).
  - `TZ`: Sets the timezone (e.g., `Europe/Rome`).
- **Volumes**:
  - Mount the host sockets for PipeWire, Wayland, or Xorg as required.
  - Optionally include `~/.uxplayrc` for custom UxPlay settings.

This container provides an easy way to deploy an AirPlay server compatible with both Xorg and Wayland desktops, leveraging the flexibility of Podman.
