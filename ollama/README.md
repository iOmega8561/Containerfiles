# Ollama (CPU-only)

This container provides a minimal **CPU-only Ollama runtime** based on **Debian stable-slim**.  
It removes all GPU-related dependencies (CUDA and Vulkan) from the official binary distribution, resulting in a **smaller and simpler image** suitable for CPU inference workloads.

The container is designed for **homelab environments** and works well with **rootless container runtimes** such as Podman.

## Features

- **CPU-only runtime** – GPU libraries (CUDA/Vulkan) are removed
- **Minimal Debian base** – stable, glibc-based environment
- **Rootless execution** – runs as a non-root user for improved security
- **Persistent model directory** – models stored in a dedicated path
- **Simple deployment** – exposes the standard Ollama API

## Building the Image

Build the container image with:

```bash
podman build --tag ollama-cpu:latest .
````

## Running the Container

Run the container with:

```bash
podman run -it --rm \
    -p 11434:11434 \
    localhost/ollama-cpu:latest
```

### Example Usage

* Maps port **11434** inside the container to **11434** on the host.
* The Ollama API will be available at:

```
http://localhost:11434
```

You can then interact with the API or CLI to download and run models.

## Persistent Models

By default, Ollama stores models in:

```
/home/ollama/.ollama/models
```

You may want to persist this directory using a volume.

### Example

```bash
podman run -it --rm \
    -p 11434:11434 \
    -v /path/to/models:/home/ollama/.ollama/models \
    localhost/ollama-cpu:latest
```

### Notes

* **Persistent Storage**: Mounting the models directory prevents re-downloading models after container recreation.
* **Rootless Friendly**: The container runs as UID `1000`, which works well with rootless Podman setups.
* **CPU-only Environment**: GPU acceleration is intentionally removed to keep the image lightweight and reduce complexity.

## Use Case

This container is ideal for:

* Homelab deployments
* CPU-only servers
* Rootless container environments
* Lightweight Ollama API services
