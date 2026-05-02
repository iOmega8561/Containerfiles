# Podman (rootless Podman-in-Podman)

A minimal, rootless **Debian-based** image that bundles:

* **Podman** (and `podman‑compose`) – a container engine that runs without root.
* **OpenSSH‑server** – so you can SSH into the container and run Podman commands.
* A **default user `podman`** (UID 1000) without privilege escalation tools.

The image is intentionally tiny – only the packages required for Podman and SSH. It is designed to be a drop‑in “Podman‑in‑a‑container” for homelabs, CI pipelines or any environment where you want to run Podman from inside a container.

> [!WARNING]
> **Security note** – The container ships with a default RSA host key.  
> If you expose it to the internet or a shared network, **change it** before use.

---

## Features

| Feature | Description |
|---------|-------------|
| **Debian base** | Small, secure, rock-solid |
| **Rootless Podman** | Runs as UID 1000 with sub‑uid/gid mapping (`10000–14999`) |
| **SSH server** | `sshd` listening on port `22` (configurable via port mapping) |
| **Default credentials** | `podman` user, RSA host key generated at build time |
| **Lightweight** | ~330 MB |

---

## Building the Image

```bash
# Build the image locally
podman build --tag localhost/podman:latest .
```

---

## Running the Container

```bash
podman run -it --rm \
  --device=/dev/fuse \      # Needed for overlayFS
  --device=/dev/net/tun \   # Needed for netavark bridges
  --cap-add=SYS_ADMIN \
  --cap-add=NET_ADMIN \     # Allow the container to manage its netowork namespace
  --security-opt seccomp=unconfined \
  --security-opt unmask=ALL \
  --userns=keep-id
  -p 2222:22 \
  -v podman-data:/home/podman \
  -v podman-ssh-config:/opt/sshd \
  localhost/podman:latest
```

### Replacing the RSA Host Key

Mount your own key at `/opt/sshd/rsa_key` **before** the container starts:

```bash
podman run -it --rm \
  ... (other arguments)
  -v ./my_rsa_key:/opt/sshd/rsa_key \
  -p 2222:22 localhost/podman:latest
```

> If you need to regenerate keys on the host, simply replace the mounted file.

---