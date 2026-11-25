# XAlpine

A lightweight **XFCE4** desktop on Alpine Linux, with Firefox, reachable from any VNC client or any modern browser through **noVNC**. Supervisord runs the display server, the web gateway and the session, restarts whichever fails and sends every log to the container's output. It ships with a rootless Quadlet.

## Features

- XFCE4 desktop with terminal, Faenza icons and Firefox.
- Dual access: VNC on port 5900, noVNC on port 6080, with remote resizing and a shared clipboard.
- Rootless Quadlet: non-root user, read-only root filesystem, zero Linux capabilities and no new privileges.
- Persistent home directory in a named volume.
- Full UTF-8 support (default `C.UTF-8`).

## Requirements

- Linux with systemd and Podman 5 with Quadlet support.
- A VPN or a private network to reach it from: neither VNC nor noVNC asks for a password.

Run all deployment commands as your regular user, without `sudo`.

## Quick Start

Build the image:

```sh
podman build --pull=always -t localhost/xalpine:latest .
```

Install and start the Quadlet:

```sh
install -Dm644 xalpine.container -t ~/.config/containers/systemd/
systemctl --user daemon-reload
systemctl --user start xalpine.service
```

Open `http://127.0.0.1:6080/vnc.html` in a browser, or point a VNC client at `127.0.0.1:5900`.

## Configuration

| Setting | Default |
| --- | --- |
| User | `xalpine` (UID 1000), home `/home/xalpine` |
| VNC / noVNC | `127.0.0.1:5900` / `127.0.0.1:6080` |
| Persistent state | `xalpine-home` volume |
| Shared memory | 1 GiB |
| Memory / CPU / PIDs | 4 GiB / 4 CPU equivalents / 2048 |

To reach the desktop remotely, replace `127.0.0.1` in both `PublishPort` lines with the server's VPN address and restrict access with the host firewall, or use an SSH tunnel. Never publish these ports on the Internet. To change the language, add `Environment=LANG=it_IT.UTF-8` and `Environment=LC_ALL=it_IT.UTF-8` (or your locale) to the Quadlet. After editing the installed Quadlet, reload systemd and restart the service.

## Runtime Verification

```sh
podman exec xalpine grep -E '^(Cap|NoNewPrivs)' /proc/1/status   # all zero, NoNewPrivs 1
podman exec xalpine mount | grep ' on / '                          # ro
journalctl --user -u xalpine.service -f
```

## Security

Everything runs as `xalpine`, never as root. The root filesystem is read-only: the home volume is the only persistent writable path, and two tmpfs mounts hold the X11 socket, the compiled keymaps and the D-Bus session bus. `/tmp` is mounted `noexec`. Supervisord is PID 1 and reaps the session's processes. Podman's default seccomp profile and SELinux labeling stay enabled.

The session logs warnings about the system bus, power management and ConsoleKit: there is none of them in a container, and the desktop works without them.