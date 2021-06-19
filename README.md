# dawidr/minecraft-docker
A simple docker container that automatically installs java and downloads and starts a minecraft server.

## Usage
Forward the port 25565 and mount a read/write volume to `/data`, to persist worlds and server settings. If the volume already contains worlds, config files or plugins/mods the server will use those and they will be updated during runtime. It is not possible to change server config using environment variables, please use the regular server config files in the volume.

## Environment
| Name                   | Default value                    | Description                                                                                                                                                             |
| ---------------------- | -------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| TYPE                   | paper                            | Which server jar to use. Currently supported: paper, fabric, spigot, forge, waterfall, custom (see [Using custom jars](#using-custom-jars))                             |
| VERSION                | 1.16.5                           | Which Minecraft version to use                                                                                                                                          |
| EULA                   | false                            | If you accept Mojang's EULA                                                                                                                                             |
| JAVA_VERSION           | 11.0.11                          | Which Java version to use                                                                                                                                               |
| JAVA_VM                | hs                               | Which Java vm to use: "hs" for HotSpot and "j9" for Openj9                                                                                                              |
| MEMORY                 | 4096                             | How much RAM to allocate for the server (in MB)                                                                                                                         |
| DEFAULT_ARGS           | TRUE                             | Which arguments to pass to the Java process. Depending on the container it uses them from https://mcflags.emc.gs or https://steinborn.me/posts/tuning-minecraft-openj9/ |
| ADDITIONAL_ARGS        |                                  | Additional arguments if you don't want to overwrite the whole ARGS                                                                                                      |
| WORLDS                 | world,world_nether,world_the_end | Which world directories to use (ignored when using waterfall)                                                                                                           |
| FORCE_DOWNLOAD         | false                            | If set to "false", no server jar will be downloaded if there is already one present from a previous run                                                                 |
| AUTO_UPDATE_VIAVERSION | false                            | If set to "true", the latest version of ViaVersion will be downloaded and put into the plugins or mods folder                                                           |
| JAR_NAME               | runme.jar                        | Name of the jar to run. Only might need changing for `TYPE: custom`, see [Using custom jars](#using-custom-jars)                                                        |
| PLUGINS_FOLDER_NAME    | plugins                          | Name of the folder to use for plugins or mods. Only might need changing for `TYPE: custom`, see [Using custom jars](#using-custom-jars)                                 |
| JAVA_DIST              | adpt                             | Identifier for the java vendor, e.g. "adpt" for AdoptOpenJDK                                                                                                            |

### Choosing the correct java version
Until Minecraft 1.16.5 the oficially recommended Java version was 8, since Minecraft 1.17 Java 16 is required. Some server types don't support the newest version yet, some only support it for recent versions. I would suggest to use the latest LTS version (11.0.11 at the time of writing) for Minecraft until 1.16.5 and the current version (16.0.1 at the time of writing) for Minecraft 1.17 and up.  
Also please keep in mind that AdoptOpenJDK might not provide an Openj9 build for every version and every architecture, e.g. there is no Openj9 build for Java 16.0.1 for the ARM architecture.

### Using custom jars
It is possible to run server types that are not supported out of the box by using `TYPE: custom`. Then you just have to provide a jar-file that matches `JAR_NAME` in the root of the bound volume.
If you want to use plugins or mods, make sure `PLUGINS_FOLDER_NAME` is correct.

Variables `VERSION` and `FORCE_DOWNLOAD` don't have any effect when using `TYPE: custom`.

## Example docker-compose
```yaml
version: '3'

services:
    my-minecraft:
        image: dawidr/minecraft-docker
        environment:
            TYPE: "paper"
            VERSION: "1.16.5"
            EULA: "true"
            JAVA_VERSION: "16.0.1"
            JAVA_VM: "hs"
            MEMORY: 3072
            DEFAULT_ARGS: "true"
            WORLDS: "world,world_nether,world_the_end,world_creative"
            FORCE_DOWNLOAD: "false"
            AUTO_UPDATE_VIAVERSION: "true"
        ports:
            - "25565:25565"
        volumes:
            - "~/my-minecraft:/data"
```
