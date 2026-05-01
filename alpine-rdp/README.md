# Alpine RDP Desktop

This container provides a lightweight, ready-to-use **XFCE4** desktop environment, with a pre-configured **xrdp** server based on the official Alpine Linux container. It exposes **port 3389** for remote desktop connections.

## Features
- **Desktop Environment**: XFCE4 (includes terminal and Faenza icon theme).
- **Web Browser**: Firefox pre-installed.
- **Connectivity**: Use standard RDP clients for connection.
- **Localization**: Full UTF-8 support (default `C.UTF-8`).

## Configuration
- **User**: `default` (UID 1000) with passwordless `sudo` privileges.
- **Home Directory**: `/home/default`
- **Password**: Must be set via the `PASSWD` environment variable.

### Running the Container

```bash
podman run -it --rm \
    --userns=keep-id \ # Optional: Map the user id with podman rootless
    -e PASSWD="your-password" \
    -p 3389:3389/tcp \
    -e LANG=en_US.UTF-8 \ # Optional: Override language at runtime
    -e LC_ALL=en_US.UTF-8 \ # Optional: Override language at runtime
    -v rdp-data:/home/default \ # Optional: Mount a home directory
    localhost/alpine-rdp:latest
```
