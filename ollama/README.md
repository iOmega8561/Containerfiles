# Ollama (CPU-only)

A minimal **CPU-only Ollama runtime** based on **Debian stable-slim**. It removes the GPU libraries (CUDA, MLX and Vulkan) from the official binary distribution, resulting in a smaller and simpler image for CPU inference, and ships with a rootless Quadlet.

## Features

- CPU-only runtime: GPU libraries are removed.
- Minimal Debian base with glibc.
- Rootless Quadlet: non-root user, read-only root filesystem, zero Linux capabilities and no new privileges.
- Models, key pair and cache in a single named volume.
- API published on the host loopback only.

## Requirements

- Linux with systemd and Podman with Quadlet support.
- Enough memory for the models you run: they are memory-mapped from the volume.

Run all deployment commands as your regular user, without `sudo`.

## Quick Start

Build the image:

```sh
podman build --pull=always -t localhost/ollama:latest .
```

Install and start the Quadlet:

```sh
install -Dm644 ollama.container -t ~/.config/containers/systemd/
systemctl --user daemon-reload
systemctl --user start ollama.service
```

Pull and run a model:

```sh
podman exec -it ollama ollama pull qwen3:0.6b
podman exec -it ollama ollama run qwen3:0.6b
curl http://127.0.0.1:11434/api/tags
```

To start at boot without an active login, enable lingering with `loginctl enable-linger "$USER"`.

## Configuration

| Setting | Default |
| --- | --- |
| API | `127.0.0.1:11434` |
| Persistent state | `ollama-data` volume at `/home/ollama/.ollama` |
| Temporary files | 256 MiB tmpfs at `/tmp`, `noexec` |
| Memory / CPU / PIDs | 8 GiB / 4 CPU equivalents / 512 |

`MemoryMax` must leave room for the largest model you load and its context. Ollama settings such as `OLLAMA_KEEP_ALIVE` or `OLLAMA_NUM_PARALLEL` go in the Quadlet as `Environment=` lines. After editing the installed Quadlet, reload systemd and restart the service.

The API has no authentication. Keep it on loopback and reach it from other containers through a shared Quadlet network, or put a reverse proxy with authentication in front of it. To serve a VPN, replace `127.0.0.1` in `PublishPort` with the VPN address and restrict it with the host firewall.

## Runtime Verification

```sh
podman exec ollama grep -E '^(Cap|NoNewPrivs)' /proc/1/status   # all zero, NoNewPrivs 1
podman exec ollama mount | grep ' on / '                          # ro
journalctl --user -u ollama.service -f
```

## Security

Ollama runs as the image's `ollama` user (UID 1000). The root filesystem is read-only; the volume and a `noexec` tmpfs are the only writable paths, and model runners are started from the read-only binary, never from `/tmp`. A minimal init reaps them. Podman's default seccomp profile and SELinux labeling stay enabled.

The image downloads the latest Ollama release at build time, without a pinned version or checksum, and is not part of the monthly rebuild: rebuild it yourself to update.