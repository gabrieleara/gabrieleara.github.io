---
date: 2021-11-04
authors:
  - gabrieleara
---

# Linux kernel development in a containerized environment using VS Code

This short guide will let you create your own containerized environment to
develop and tinker with the Linux kernel without having to install any
particular software/tool on your machine that you may not already have.

<!-- more -->

## Requirements

This guide will require little to no tools installed on your machine. However,
some tools will have to be installed to work properly.

First of all, you need an OS. Any Linux desktop distribution will do. For other
OSes (Windows or macOS) instructions may pop out in this section
soon^:material-trademark:^.

In addition, you need the following tools installed on your machine inside the
OS of choice:

 1. [Visual Studio Code][url-vscode]
 2. [Docker][url-docker]

Since you are on this page, you most likely are already interested in developing
stuff inside VS Code in containerized environments, so you should have both
already installed. If not, do it.

That's it, I told you that there wouldn't be many requirements for this guide to
work! :wink:

## Setting up your workspace

First of all you need to create an empty directory in which you plan to work and
to open it as a workspace inside VS Code. For my examples, the directory will be
simply called `kernel_dev`.

!!! note

    You can also do this by cloning the Linux kernel from your relevant source
    and opening it inside VS Code. In this guide, I will use a separate
    directory for the kernel source inside the base directory of the project.
    This will be useful if one wants to develop its own modules inside the
    workspace without tainting the kernel directory structure.

<!-- ### Creating the container configuration -->

Once you have it open, create the following directory structure:

    kernel_dev
    └── .devcontainer
        ├── devcontainer.json
        └── Dockerfile

The two created files will instruct VS Code how to treat your directory as a
Development Container workspace. I will not go into much details of how the
process of developing workspaces inside a container with VS Code works. For
that, see the [official
documentation](https://code.visualstudio.com/docs/remote/containers).

For the sake of this discussion it will suffice to say that using these files VS
Code is able to detect whether a workspace should be opened inside a container,
bring up the container, mount the workspace folder as a shared folder inside the
automatically instantiated container. Once the automated process is done, it
will look and feel as if you are working on a folder in your host, but in
reality you are developing inside a container. Magic! :magic_wand:

The content of the two files should be the following:

=== "Dockerfile"

    ```dockerfile

    # Base image for the container environment
    FROM gabrieleara/dev_environment:kernel

    # You can place other dependencies here if you want.
    # The container is a standard debian image, so you can
    # use apt-get freely to install more dependencies.

    # Also, you can copy scripts to run at boot of this
    # container image by using COPY commands with the
    # directory /opt/startup-scripts as destination

    ```

=== "devcontainer.json"

    ```json

    // Configuration of the development container
    {
        "name": "Kernel",
        "build": {
            // Use the Dockerfile in the same directory as container image
            "dockerfile": "Dockerfile"
        },
        // Arguments provided to the docker run command by VS Code.
        // Each and every one of them is necessary for the project
        // to work properly. You may not need some options if you only
        // develop and build the kernel in this container, but if you
        // need to run and debug it inside QEMU they are *ALL* necessary.
        "runArgs": [
            "-e",
            "DISPLAY=${env:DISPLAY}",
            "-v",
            "/tmp/.X11-unix:/tmp/.X11-unix",
            "-e",
            "QT_GRAPHICSSYSTEM=native",
            "--device=/dev/dri:/dev/dri",
            "--cap-add=SYS_PTRACE",
            "--security-opt",
            "seccomp=unconfined",
            "--privileged",
            "-v",
            "/var/run/libvirt:/var/run/libvirt"
        ],
        // List of VS Code extension IDs that will be automatically
        // installed inside the container instance
        "extensions": [
            "ms-vscode.cpptools",
            "ms-vscode.cmake-tools",
            "eamodio.gitlens"
        ],
        // Important: use this to login as vscode user, rather than root
        "remoteUser": "vscode",
        // This option is necessary. The image that i built needs to run
        // some commands at container startup and for that I had to set
        // the ENTRYPOINT of the Docker container accordingly.
        "overrideCommand": false,
    }
    ```

!!! note

    While I write this document, the options in the `devcontainer.json` file
    listed here are all accurate. However, I cannot guarantee that it will
    always be the case.

    For a more recent version of this file, refer to
    [this link][url-devcontainer] to my GitHub repository where I keep all these
    virtualized environments configurations.

## Opening the workspace in the container

Once the content of the two files is filled accordingly, open VS Code command
palette ++ctrl+shift+p++ and use the following command to reopen your
workspace inside the specified container:

    Remote-Containers: Rebuild and Reopen in Container

Once started, this command will build the relevant container image and bring up
the workspace in the new environment. This may take a while. Once this process
is done you should get your workspace now open inside the container. If you open
a terminal from inside VS Code you should get a prompt from inside the container
and everything.

At this point if you are not working from inside the kernel directory already
you should clone the Linux kernel code form your relevant source and place it
somewhere inside the workspace. For me, that directory will be called
(unsurprisingly) `linux`. However, keep it in mind for the next steps.

For the sake of clarity, this is the content of my workspace at the end of this
step:

    kernel_dev
    ├── .devcontainer
    │   ├── Dockerfile
    │   └── devcontainer.json
    └── linux
        └── ...

## Configuring and building the Linux kernel

Now it's time to configure and build the Linux kernel. This can be done by using
the terminal inside VSCode, but for further convenience here is a configuration
file that can be used to run build tasks from VS Code command palette.

This file must be placed inside the `.vscode` directory in the root of the
workspace and each mention of the path `${workspaceFolder}/linux` **must** be
adapted to reflect the actual location of your Linux source tree inside your
workspace.

=== "tasks.json"

    ```json
    {
        "version": "2.0.0",
        "tasks": [
            {
                // Generates a new configuration file for the
                // Linux kernel using the default one.
                "label": "defconfig",
                "type": "shell",
                "command": "make -C ${workspaceFolder}/linux defconfig",
                "problemMatcher": [],
            },
            {
                // Re-configures the Linux kernel by checking the modifications in
                // the .config file.
                "label": "oldconfig",
                "type": "shell",
                "command": "make -C ${workspaceFolder}/linux oldconfig",
                "problemMatcher": [],
            },
            {
                // Builds the entire Linux kernel using several parallel jobs.
                "label": "build",
                "type": "shell",
                "command": "make -C ${workspaceFolder}/linux -j $(nproc)",
                "problemMatcher": [],
                "group": {
                    "kind": "build",
                    "isDefault": true
                }
            },
        ]
    }
    ```

Now you can use VS Code Command Palette to run these tasks. First, use the
`defconfig` task to generate a default config (if you don't already have a
`.config` task specific for your purposes).

After that you have to append the following lines at the end of the `.config`
file generated inside Linux source tree root. In the listing, the options marked
as "optional" can be omitted if not necessary. Feel free to make any other
modification that you like to the `.config` configuration as long as you
maintain the mandatory options.

```bash
# Mandatory options:
CONFIG_DEBUG_INFO=y             # Enable debug information

# Optional options:
CONFIG_READABLE_ASM=y           # Generates more readable ASM instructions
CONFIG_DEBUG_SECTION_MISMATCH=y # Enables mismatch analysis
```

You can then use the `oldconfig` task to check that your kernel configuration is
correct or to check whether you need to supply other information. During the
execution of this task, you may be prompted yes/no questions. If you don't
really know what you're doing you can simply type ++enter++ for each of them and
accept the default values.

!!! note

    Typically, one would disable `CONFIG_RANDOMIZE_MEMORY` to debug the Linux
    kernel, otherwise debug symbols will be scrambled each time it boots, making
    it impossible to debug.

    For this guide, I prefer to fiddle as little as possible with the kernel
    configuration and use instead a boot argument to disable address
    randomization inside the kernel, so you can leave it enabled.

Now that your kernel is configured, it is time to build it. You can use the
`build` task above to do it in a parallel fashion. It is also configured as the
default build task for the workspace, so you can use ++ctrl+shift+b++ to start
the whole build process.

Once the build task is done you have your own build of the Linux kernel that you
can run and debug.

## Running and debugging the Linux kernel

At this point all is left is to run and debug the build Linux kernel. Beware
though that you need a proper filesystem image to run Linux, otherwise the Linux
kernel will not be able to find appropriate tools to start processes and such.

You can find a minimal image built using BusyBox [here][url-tinyfs]. Download it
and place it inside your workspace. I will put mine in the workspace root
folder.

Now all you need is a launch configuration file for VS Code. You can use the
following one and place it inside the `.vscode` directory as well. In the file,
the location of the Linux kernel directory `${workspaceFolder}/linux` and the
file system to use `${workspaceFolder}/tinyfs.gz` must be changed according to
where you placed them in your workspace.

=== "launch.json"

    ```json
    {
        "version": "0.2.0",
        "configurations": [
            {
                // Use this launch configuration first to run QEMU using the
                // kernel built at the previous step. It will also automatically
                // invoke the build process before running, so you can just
                // start this launch configuration whenever you are done typing
                // code and it will automatically do everything for you.
                "name": "(gdb) Start Kernel in QEMU",
                "type": "cppdbg",
                "request": "launch",
                "program": "/usr/bin/qemu-system-x86_64",
                // Do not fiddle with these arguments if you do not know
                // what you're doing!
                "args": [
                    "-s",
                    "-S",
                    "-kernel",
                    "${workspaceFolder}/linux/arch/x86_64/boot/bzImage",
                    "-append",
                    "nokaslr",
                    "-initrd",
                    "${workspaceFolder}/tinyfs.gz",
                ],
                "stopAtEntry": false,
                "cwd": "${fileDirname}",
                "environment": [],
                "externalConsole": false,
                "preLaunchTask": "${defaultBuildTask}",
            },
            {
                // Once the previous launch succeeded and you see on screen the
                // QEMU window waiting for the debugger, run this configuration,
                // which will attach the visual debugger of VS Code to your
                // kernel instance running in the emulator.
                "name": "(gdb) Attach to QEMU Kernel",
                "type": "cppdbg",
                "request": "launch",
                "program": "${workspaceFolder}/linux/vmlinux",
                "args": [],
                "stopAtEntry": false,
                "cwd": "${fileDirname}",
                "environment": [],
                "externalConsole": false,
                "MIMode": "gdb",
                "symbolSearchPath": "${fileDirname}",
                "miDebuggerServerAddress": "localhost:1234",
                "setupCommands": [
                    {
                        "description": "Enable pretty-printing for gdb",
                        "text": "-enable-pretty-printing",
                        "ignoreFailures": true
                    },
                ],
            },
        ]
    }
    ```

Follow the instructions in the comments above to launch the kernel instance
inside the emulator and attach the VS Code debugger to it. After that the kernel
will start running and you can stop it using breakpoints wherever in your kernel
code.

Both launch configurations shall be running at the same time for the process to
work, and you shall always start the first one before the other. Unfortunately,
as far as I know there is no automated way to run them both at the same time,
but it's not particularly tedious to do after all the work I did for you. :wink:

Just to recap, this is the final tree of the workspace directory once everything
is set in place. You may have some files placed differently, but as long as you
substitute all the paths accordingly in the `tasks.json` and `launch.json`
configuration files you are good. :smile:

Happy Linux Kernel Hacking with VS Code! :penguin:

    kernel_dev
    .devcontainer
    │   ├── devcontainer.json
    │   └── Dockerfile
    ├── linux
    ├── tinyfs.gz
    └── .vscode
        ├── launch.json
        └── tasks.json

<!------------------------- Urls ------------------------->

[url-docker]: https://www.docker.com

[url-vscode]: https://code.visualstudio.com

[url-devcontainer]:
https://github.com/gabrieleara/dev_environment/blob/kernel/kernel/devcontainer.json

[url-tinyfs]: /assets/misc/tinyfs.gz
