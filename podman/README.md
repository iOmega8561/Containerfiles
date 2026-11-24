# Podman (rootless Podman-in-Podman)

A lightweight Debian-based development environment providing rootless Podman,
`podman-compose`, Buildah and an OpenSSH server. Designed for private remote
shells and homelabs, with container storage independent of the host engine.

## Features

- Debian Trixie slim base and a non-root `podman` user (UID/GID 1000).
- Nested rootless Podman with subordinate IDs `10000–14999`.
- SSH on port 2222 with public-key-only authentication.
- Deployment-specific Ed25519 host key, supplied at runtime.
- Rootless systemd Quadlet, persistent home and read-only image filesystem.

## Quick start

Requires a Linux host with rootless Podman, Quadlet, subordinate UID/GID
allocations covering the nested mappings, and access to `/dev/fuse` and
`/dev/net/tun`. Nested user namespaces must be supported by the host.

Build from this directory:

```sh
podman build -t localhost/podman:latest .
```

Generate a unique server key and install your SSH client's **public** key:

```sh
install -d -m 0700 ~/.config/podman-dev/ssh
ssh-keygen -t ed25519 -N '' \
  -f ~/.config/podman-dev/ssh/ssh_host_ed25519_key
install -m 0600 /path/to/client.pub \
  ~/.config/podman-dev/ssh/authorized_keys
```

Generate the host key only once per deployment. Never copy the client's private
key to the server or commit any server private key to Git.

Install and start the Quadlet as your regular host user:

```sh
mkdir -p ~/.config/containers/systemd
install -m 0644 podman.container ~/.config/containers/systemd/
systemctl --user daemon-reload
systemctl --user start podman.service
```

The default port mapping listens only on loopback. For direct VPN access,
replace `127.0.0.1` in `PublishPort` with the server's VPN address and restrict
access using the host firewall. Alternatively, connect through an SSH tunnel
on the host. Do not publish the service on all interfaces unintentionally.

```sh
ssh -p 2222 podman@127.0.0.1
# Or use the VPN address if configured.
```

Verify the server fingerprint against `ssh-keygen -lf
~/.config/podman-dev/ssh/ssh_host_ed25519_key.pub` on the host before accepting it.

## Configuration and storage

The `podman-data` named volume preserves the development home, including nested
images, containers and configuration. Runtime files live in temporary filesystems.
The SSH keys are mounted separately, read-only. Use a fresh named volume on first
start; older volumes may contain incompatible ownership or SSH configuration.
The nested ID range must fit inside the outer user namespace; do not recursively
chown existing container storage to UID 1000.

## Security and compatibility

The Quadlet is a restrictive starting profile, not a tested universal recipe.
It avoids privileged mode, host engine sockets, host networking and blanket
security-policy exceptions. The outer container remains rootless, but shares the
host kernel. Treat SSH clients and nested workloads as trusted development users.

Unlike ordinary application containers, nested Podman needs working setuid
`newuidmap`/`newgidmap` helpers. Therefore the default capability bounding set is
retained and `NoNewPrivileges` is not enabled. Default seccomp, masked paths and
SELinux/AppArmor policies are kept initially. Nested mounts, networking and cgroups
may require host-specific adjustments; investigate denials before relaxing them.
The original deployment used broader capabilities, unconfined seccomp and unmasked
paths; these are deliberately not enabled by default in this profile.

## Verification and maintenance

After connecting over SSH, test the nested engine:

```sh
podman info
podman unshare cat /proc/self/uid_map
podman run --rm docker.io/library/alpine:latest echo OK
```

If cgroup management fails, test a workload without per-container cgroups:

```sh
podman --cgroup-manager=cgroupfs run --cgroups=disabled --rm \
  docker.io/library/alpine:latest echo OK
```

This is a diagnostic fallback, not equivalent to full nested cgroup support.
If rootless storage fails, check the volume ownership, ID mappings, `/dev/fuse`
and the storage driver. For noninteractive SSH commands, set
`XDG_RUNTIME_DIR=/run/user/1000` explicitly if it is not inherited.

```sh
journalctl --user -u podman.service -f
```

Rebuild the image and restart `podman.service` to update it. The home volume and
SSH identity persist. To start at boot without an active login, enable lingering
for the host user if appropriate.

See [Podman Quadlet documentation](https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html) and [Podman inside a container](https://www.redhat.com/en/blog/podman-inside-container) for further details.