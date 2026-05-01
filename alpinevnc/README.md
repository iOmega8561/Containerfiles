# Alpine VNC Desktop

This container provides a lightweight, ready-to-use **XFCE4** desktop environment based on Alpine Linux. It features a pre-configured **VNC** server and **noVNC** web interface, allowing remote access via standard VNC clients or any modern web browser.

The environment is managed by **Supervisord** for process reliability and includes a pre-configured **D-Bus** setup to ensure a stable desktop session.

## Features
- **Desktop Environment**: XFCE4 (includes terminal and Faenza icon theme).
- **Web Browser**: Firefox pre-installed.
- **Connectivity**: Dual access via VNC (port 5900) and noVNC (port 6080).
- **Localization**: Full UTF-8 support (default `C.UTF-8`).

## Configuration
- **User**: `default` (UID 1000) with passwordless `sudo` privileges.
- **Home Directory**: `/home/default`
- **Init System**: Supervisord.

## Usage

### Running the Container

```bash
podman run -d --rm \
    --name alpinevnc \
    --userns keep-id \ # Optional: Map the user id with podman rootless
    -p 5900:5900 \
    -p 6080:6080 \
    -e LANG=en_US.UTF-8 \ # Optional: Override language at runtime
    -e LC_ALL=en_US.UTF-8 \ # Optional: Override language at runtime
    -v vnc-data:/home/default \ # Optional: Mount a home directory for persistence
    localhost/alpinevnc:latest
```

### Exposed Ports
- `5900/tcp`: Standard VNC client access.
- `6080/tcp`: Web-based access via noVNC.