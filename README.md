
# Containerfiles

This repository contains a collection of Containerfiles I’ve built to run various services in my Homelab. Each Containerfile serves a specific purpose, like running a DNS server or setting up an AirPlay service. Most of these are designed to work with **rootless Podman**, aligning with my Homelab's setup for enhanced security and flexibility.

The goal is to leverage the benefits of Podman (especially rootless Podman) to keep services lightweight, secure, and easy to manage.

> [!WARNING]
> **These Containerfiles are tailored for my specific environment.**  
> While I’m sharing them in case they’re helpful to others, please keep in mind:
> - They are configured to suit my personal setup and workflow, which may differ from yours.
> - Some adjustments might be necessary to make them compatible with your environment.
> - Test thoroughly before deploying these in your systems.
>
> Feel free to open an issue, but remember that these Containerfiles reflect my specific use case

## Why Podman?

> [!TIP]
> These files should also work perfectly fine with Docker after <strong>minor</strong> or <strong>none</strong> adjustments 

I’ve built these Containerfiles with Podman in mind because it offers:
- **Rootless Operation**: Enhances security by running containers without root privileges.
- **Docker-Compatible Commands**: Transitioning from Docker is seamless.
- **Lightweight and Flexible**: No daemon, no fuss.

## Getting Started

### How to Use This Repository

Each directory in this repository contains:
- A **Containerfile** with the build instructions for creating the container image.
- A **README.md** specific to that service, detailing setup instructions, usage, and configuration options.

To use these Containerfiles:
1. **Navigate to the desired directory**.
2. **Refer to the README.md file inside** for detailed instructions.

This approach keeps the focus on individual services, making it easier for you to find what you need.

### How to Use Prebuilt Images

1. **Find the Image**: Refer to the service's README.md file in this repository for the corresponding GHCR.io image name and tag.
2. **Pull the Image**:
   ```bash
   podman pull ghcr.io/iomega8561/service-name:tag
   ```
   Replace `service-name` and `tag` with the specific service and version.
3. **Run the Container**:
   ```bash
   podman run -d --name your-container-name ghcr.io/iomega8561/service-name:tag
   ```

Prebuilt images save time and ensure compatibility with the configuration provided in the Containerfiles.
