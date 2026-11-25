# UxPlay Rootless

A hardened [UxPlay](https://github.com/FDH2/UxPlay) AirPlay receiver for Linux desktops, running rootless with Podman and managed by systemd Quadlet.

## Features

- Multi-stage build using Alpine Linux 3.23 and UxPlay v1.73.4.
- Rootless execution, non-root user, read-only root filesystem, zero Linux capabilities and no new privileges.
- Native Wayland video and PipeWire audio; host Avahi for mDNS discovery.
- Software decoding without GPU passthrough.
- Password authentication, resource limits and session-bound systemd supervision.

## Requirements

- Linux with systemd, cgroup v2 and Podman with Quadlet support.
- A running Wayland session, PipeWire and Avahi (with system D-Bus access).
- A trusted local network shared with the AirPlay client.

Run all deployment commands as your regular desktop user, without `sudo`.

## Quick Start

Build the image:

```sh
podman build --pull=always -t localhost/uxplay:latest .
```

Check your Wayland socket with `echo "$WAYLAND_DISPLAY"`. If it differs from `wayland-0`, adjust both the socket mount and environment variable in `uxplay.container`.

Install and start the Quadlet:

```sh
mkdir -p ~/.config/containers/systemd
install -m 0644 uxplay.container ~/.config/containers/systemd/
systemctl --user daemon-reload
systemctl --user start uxplay.service
journalctl --user -u uxplay.service -f
```

Select **UxPlay** from Screen Mirroring on your Apple device and enter the password displayed in the journal.

The service follows `graphical-session.target` on desktops that support it. Otherwise, start it manually after login. Quadlet handles startup dependencies; no `systemctl enable` is required.

## Configuration

Edit `uxplay.container` to customize the receiver:

```ini
Exec=-n UxPlay -nh -p 7000 -vs waylandsink -as pipewiresink -avdec -pw
```

| Setting | Default |
| --- | --- |
| Receiver name | `UxPlay` |
| Video / audio | Wayland / PipeWire |
| Decoding | Software (`-avdec`) |
| Authentication | Temporary password (`-pw`) |
| Memory / CPU / PIDs | 1 GiB / 4 CPU equivalents / 128 |

The container uses host networking. Allow TCP and UDP ports **7000–7002**, plus UDP **5353** for host mDNS, on the trusted LAN only. Do not expose the receiver to the Internet.

After editing the installed Quadlet, reload and restart the service.

## Security

The container uses `keep-id` to map the host user to UID/GID 1000. Its root filesystem is read-only, with an explicit temporary filesystem for GStreamer cache. Podman's default seccomp and security labeling remain enabled.

Host networking and access to Wayland, PipeWire and system D-Bus are deliberate isolation trade-offs. Read-only socket mounts do not restrict operations performed through those sockets. A filtered D-Bus proxy is not included.

On SELinux hosts, never relabel system or desktop sockets with `:z` or `:Z`. Prefer a narrowly scoped policy over `SecurityLabelDisable=true`, which weakens isolation. Keep journal access restricted because it contains authentication information.

## Runtime Verification

Verify that the container is running with the expected security restrictions:

```sh
podman exec uxplay grep -E '^(Cap|NoNewPrivs)' /proc/self/status
```

All capability masks should be zero and `NoNewPrivs` should be `1`.

Check that the root filesystem is mounted read-only:

```sh
podman exec uxplay mount | grep ' on / '
```

Inspect service logs for runtime errors:

```sh
journalctl --user -u uxplay.service -f
```

## Maintenance

Inspect or manage the service:

```sh
systemctl --user status uxplay.service
systemctl --user restart uxplay.service
journalctl --user -u uxplay.service -f
```

To update, review upstream releases, adjust `UXPLAY_VERSION` if needed, then rebuild:

```sh
podman tag localhost/uxplay:latest localhost/uxplay:rollback
podman build --pull=always --no-cache -t localhost/uxplay:latest .
systemctl --user restart uxplay.service
```

Restore the rollback tag to `localhost/uxplay:latest` and restart if necessary. Version tags are pinned, but base images and package repositories are not digest- or snapshot-locked.

To uninstall, stop the service, remove the installed Quadlet, reload systemd and remove the image with `podman image rm localhost/uxplay:latest`.

## Troubleshooting

| Issue | Check |
| --- | --- |
| Receiver not visible | Avahi, D-Bus permissions, firewall and multicast |
| No video | Wayland socket, session and SELinux policy |
| No audio | PipeWire socket and host audio routing |
| Service not found | Quadlet support, installation path and daemon reload |
| Read-only filesystem error | Add narrowly scoped temporary storage if required |

For verbose GStreamer logs, temporarily add `Environment=GST_DEBUG=3` to the Quadlet.

## Project Status & License

This is a reference deployment, not an end-to-end tested release. Test discovery, audio and video on your host before relying on it.

UxPlay is GPL-3.0 licensed; dependencies retain their respective licenses. No separate license has been selected for these deployment files. Redistributing built images requires compliance with applicable license and corresponding-source obligations.

See [UxPlay](https://github.com/FDH2/UxPlay) and the [Podman Quadlet documentation](https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html) for further details.