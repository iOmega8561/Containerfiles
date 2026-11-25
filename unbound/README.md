# Unbound

A lightweight [Unbound](https://nlnetlabs.nl/projects/unbound/about/) image: a validating, recursive and caching DNS resolver on Alpine Linux, with a stock Unbound install. It ships with a rootless Quadlet and a container-oriented configuration that runs it as an unprivileged user, with no capabilities and a fully read-only filesystem.

## Features

- Alpine Linux base, stock Unbound package and DNSSEC root anchor.
- Rootless Quadlet: unprivileged user, read-only root filesystem with nothing writable, zero Linux capabilities and no new privileges.
- Recursion straight to the root servers, DNSSEC validation, QNAME minimisation and an in-memory cache.
- Answers loopback and private networks only; logs to the journal.

## Requirements

- Linux with systemd and Podman 5 with Quadlet support.
- Outbound UDP and TCP port 53 to the Internet, for recursion.

Run all deployment commands as your regular user, without `sudo`.

## Quick Start

Build the image:

```sh
podman build --pull=always -t localhost/unbound:latest .
```

Install the configuration and the Quadlet, then start the service:

```sh
install -Dm644 unbound.conf ~/.config/unbound/unbound.conf
install -Dm644 unbound.container -t ~/.config/containers/systemd/
systemctl --user daemon-reload
systemctl --user start unbound.service
```

Test it:

```sh
dig @127.0.0.1 -p 1053 example.com +dnssec
```

The `ad` flag in the answer means DNSSEC validation succeeded. To start at boot without an active login, enable lingering with `loginctl enable-linger "$USER"`.

## Configuration

`unbound.conf` replaces the stock configuration, which assumes a full system: it starts as root, binds port 53, keeps a control socket in `/run` and listens only on its own loopback. The container version instead:

| Setting | Value |
| --- | --- |
| User | `unbound`, from the start; no chroot, no privilege drop |
| Interfaces | Every interface of the container's own network namespace |
| Clients | Loopback and private ranges; everything else is refused |
| DNSSEC | Static root anchor from the `dnssec-root` package |
| Cache | 32 MiB messages, 64 MiB records, prefetch, serve-expired |
| Logs | stderr, collected by the journal |
| Remote control | Disabled; restart the service instead |

The anchor is not updated at runtime (RFC 5011 needs a writable file): it follows the package, and the image is rebuilt monthly. Edit `~/.config/unbound/unbound.conf` and restart the service to apply changes. To use your own configuration, replace that file; keep `username: ""`, `chroot: ""` and `control-enable: no`, or the read-only, capability-free container will refuse to start.

### Serving the LAN

The Quadlet publishes port 1053 on the host loopback only. A rootless user cannot bind host ports below 1024, so to serve clients on port 53 either:

- allow it host-wide, once, as root: `echo 'net.ipv4.ip_unprivileged_port_start=53' > /etc/sysctl.d/90-unprivileged-dns.conf && sysctl --system`, then set `PublishPort=<LAN address>:53:53/udp` and `.../tcp`;
- or keep port 1053 and redirect port 53 to it in the host firewall.

Pasta, Podman's default rootless network, preserves the clients' source addresses, so `access-control` keeps working. Do not expose the resolver to the Internet: open resolvers are abused for amplification attacks.

## Runtime Verification

```sh
podman exec unbound grep -E '^(Cap|NoNewPrivs)' /proc/1/status   # all zero, NoNewPrivs 1
podman exec unbound id                                            # uid=100(unbound)
journalctl --user -u unbound.service -f
```

## Security

Inside the container, Unbound runs as the `unbound` user (UID 100), not as root. It binds port 53 because the Quadlet lowers `net.ipv4.ip_unprivileged_port_start` in the container's own network namespace; the host is not affected, and no capability is needed. The root filesystem is read-only with no tmpfs at all, and Podman's default seccomp profile and SELinux labeling stay enabled.


## Running Without Quadlet

The image also runs with its stock configuration, which needs the default capabilities:

```sh
podman run -it --rm -p 1053:53/udp -p 1053:53/tcp localhost/unbound:latest
```

With the stock configuration Unbound only listens on the container's loopback, so mount a configuration that sets `interface:` and `access-control:`:

```sh
podman run -it --rm \
    -p 1053:53/udp -p 1053:53/tcp \
    -v /path/to/your/config:/etc/unbound:ro \
    localhost/unbound:latest
```

The directory must contain an `unbound.conf`.
