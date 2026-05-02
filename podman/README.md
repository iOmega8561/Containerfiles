# Podman

A minimal, rootless **Alpine‑based** image that bundles:

* **Podman** (and `podman‑compose`) – a container engine that runs without root.
* **OpenSSH‑server** – so you can SSH into the container and run Podman commands.
* A **default user `podman`** (UID 1000) with `sudo` privileges and a **pre‑generated RSA host key**.

The image is intentionally tiny – only the packages required for Podman, SSH and a few utilities (`nano`, `sudo`). It is designed to be a drop‑in “Podman‑in‑a‑container” for homelabs, CI pipelines or any environment where you want to run Podman from inside a container.

> [!WARNING]
> **Security note** – The container ships with a known password (`podman`) and a default RSA host key.  
> If you expose it to the internet or a shared network, **change both** before use.

---

## Features

| Feature | Description |
|---------|-------------|
| **Alpine base** | Small, glibc‑free, secure |
| **Rootless Podman** | Runs as UID 1000 with sub‑uid/gid mapping (`10000–14999`) |
| **SSH server** | `sshd` listening on port `22` (configurable via port mapping) |
| **Default credentials** | `podman` user, password `podman`; RSA host key generated at build time |
| **Convenience tools** | `nano`, `sudo` |
| **Lightweight** | ~140 MB |

---

The entrypoint simply starts `sshd` under `sudo` so that the container can accept connections as root (required by OpenSSH) while still running user commands as the `podman` account.

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
  --security-opt label=disable \
  --userns=keep-id
  -p 2222:22 \
  -v podman-data:/home/podman \
  -v podman-ssh-config:/etc/ssh \
  localhost/podman:latest
```

---

## Customizing Credentials

### Changing the User Password

1. **Inside the container** at runtime:

```bash
podman exec -it my-podman-container-name passwd podman
```

2. **Or pre‑configure** by creating a `passwd` file and mounting it:

```bash
podman run -it --rm \
  ... (other arguments)
  -v ./mypassword:/etc/shadow \
  -p 2222:22 localhost/podman:latest
```

### Replacing the RSA Host Key

Mount your own key at `/etc/ssh/ssh_host_rsa_key` **before** the container starts:

```bash
podman run -it --rm \
  ... (other arguments)
  -v ./my_rsa_key:/etc/ssh/ssh_host_rsa_key \
  -p 2222:22 localhost/podman:latest
```

> If you need to regenerate keys on the host, simply replace the mounted file.

---