# Wine-Gaming

This container provides a pre-configured environment for gaming with **Wine** using a custom build from **Glorious Eggroll**, complete with **dxvk** and **vkd3d-proton**. The image is based on `archlinux:base-devel` and packages the necessary tools for running and configuring games. 

> [!WARNING]
>
> Since when this Containerfile was written, many things have changed for Linux gaming.  
> This may still work, but it's not supported anymore!

## Use Case
This container is designed to support multiple games, but games and their respective launchers must be manually installed within the container's environment.

## Setting Up the Container

Create your container with the following command. If you don't have an NVIDIA GPU, omit the lines related to NVIDIA devices.

```bash
podman container create --replace --name my-container \
    --userns=keep-id \
    -v /where_games_are_stored:/games \
    -v $XDG_RUNTIME_DIR:/run/user/1000:rslave \
    -v /tmp:/tmp:rslave \
    -e DISPLAY="$DISPLAY" \
    -v /dev/dri:/dev/dri:rslave \
    -v /dev/nvidia0:/dev/nvidia0 \
    -v /dev/nvidiactl:/dev/nvidiactl \
    -v /dev/nvidia-modeset:/dev/nvidia-modeset \
    -v /dev/nvidia-uvm:/dev/nvidia-uvm \
    -v /dev/nvidia-uvm-tools:/dev/nvidia-uvm-tools \
    localhost/wine-gaming:latest
```

### Starting the Container

Once created, start the container. It will remain active in a dormant state, ready for use:
```bash
podman start my-container
```

## Installing NVIDIA Userspace Drivers

If you have an NVIDIA GPU, install the required userspace drivers using the included helper script:
```bash
podman exec -it my-container ct-nvidiasetup
```

## Setting Up a WINE Prefix for a Game

To create a new WINE prefix for a game:
1. Specify the game name using the `GAME` environment variable.
2. Use the bundled `ct-winesetup` helper script.

Example:
```bash
podman exec -it -e GAME="GameName" my-container ct-winesetup
```

The WINE prefix will be created at `/where_games_are_stored/$GAME_NAME/prefix`.

## Installing Games and Launchers

Access the container's shell to manually install games or their required launchers:
```bash
podman exec -it my-container bash
```

Install your game or launcher as needed within the WINE environment.

## Running a Game

After installing a game, create a wrapper script in the game directory (e.g., `/where_games_are_stored/$GAME_NAME/wrapper.sh`) to simplify launching. The wrapper script should handle the game-specific startup logic.

Run the game with:
```bash
podman exec -it -e GAME="GameName" my-container ct-entrypoint arg1 arg2 ... argN
```

This command will execute your wrapper script and pass any arguments to it.

This container provides a streamlined and flexible environment for running games with Wine. By combining the power of custom Wine builds with containerized isolation, you can manage and run multiple games efficiently.
