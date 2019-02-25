# Day 2, deliverable 1: The "forgotten" Dockerfile instructions
> Find and explain examples where the following instructions are useful.
> * ARG
> * ONBUILD
> * STOPSIGNAL
> * HEALTHCHECK
> * SHELL

## ARG
The `ARG` instruction defines a variable that users can pass at build-time to the builder with the docker build command using the `--build-arg <varname>=<value>` flag. 

FROM instructions support variables that are declared by any ARG instructions that occur before the first FROM.

You can use an ARG instruction to specify variables that are available to the RUN instruction, but unlike unlike an ENV instruction, ARG values are never persisted in the built image.

#### Example: Indicate the version of the base image
```Dockerfile
ARG VERSION=latest
FROM bitnami/minideb:${VERSION}
ARG VERSION
RUN echo $VERSION > image_version
```
An ARG declared before a FROM is outside of a build stage, so it can’t be used in any instruction after a FROM. To use the default value of an ARG declared before the first FROM use an ARG instruction without a value inside of a build stage.

If an ARG instruction has a default value and if there is no value passed at build-time, the builder uses the default. 

```bash
$ docker build --build-arg VERSION=stretch .
```


## ONBUILD
The `ONBUILD` instruction adds to the image a trigger instruction to be executed at a later time, when the image is used as the base for another build. The trigger will be executed in the context of the downstream build, as if it had been inserted immediately after the FROM instruction in the downstream Dockerfile.

#### Example: A reusable Python application builder
Imagine your image is a reusable Python application builder, so it will require application source code to be added in a particular directory, and it might require a build script to be called after that. You can’t just call ADD and RUN now, because you don’t yet have access to the application source code, and it will be different for each application build. You could simply provide application developers with a boilerplate Dockerfile to copy-paste into their application, but that is inefficient, error-prone and difficult to update because it mixes with application-specific code.

The solution is to use `ONBUILD` to register advance instructions to run later, during the next build stage.

Here’s how it works:

1. When it encounters an `ONBUILD` instruction, the builder adds a trigger to the metadata of the image being built. The instruction does not otherwise affect the current build.
2. At the end of the build, a list of all triggers is stored in the image manifest, under the key `OnBuild`. They can be inspected with the `docker inspect` command.
3. Later the image may be used as a base for a new build, using the `FROM` instruction. As part of processing the `FROM` instruction, the downstream builder looks for `ONBUILD` triggers, and executes them in the same order they were registered. If any of the triggers fail, the `FROM` instruction is aborted which in turn causes the build to fail. If all triggers succeed, the FROM instruction completes and the build continues as usual.
4. Triggers are cleared from the final image after being executed. In other words they are not inherited by “grand-children” builds.

For example, you might add something like this:
```Dockerfile
[...]
ONBUILD ADD . /app/src
ONBUILD RUN /usr/local/bin/python-build --dir /app/src
[...]
```

## STOPSIGNAL
The `STOPSIGNAL` instruction sets the system call signal that will be sent to the container to exit. This signal can be a valid unsigned number that matches a position in the kernel’s syscall table, for instance 9, or a signal name in the format SIGNAME, for instance SIGKILL.

When you do `docker stop`, the Docker daemon sends a signal to the process running the container to stop, and by default that signal is SIGTERM. However, if your application is configured to listen to a different signal in order to exit, you may use the `STOPSIGNAL` instruction to indicate such signal.

**For instance, in your Dockerfile:**
```Dockerfile 
STOPSIGNAL 12 
```
or
```Dockerfile 
STOPSIGNAL SIGUSR2
```

## HEALTHCHECK
The `HEALTHCHECK` instruction tells Docker how to test a container to check that it is still working. This can detect cases such as a web server that is stuck in an infinite loop and unable to handle new connections, even though the server process is still running.

When a container has a healthcheck specified, it has a health status in addition to its normal status. This status is initially starting. Whenever a health check passes, it becomes healthy (whatever state it was previously in). After a certain number of consecutive failures, it becomes unhealthy.

#### Example: Test a web server periodically
To check every five minutes or so that a web-server is able to serve the site’s main page within three seconds:
```Dockerfile
HEALTHCHECK --interval=5m --timeout=3s --retries=3 \
    CMD curl -f http://localhost/ || exit 1
```
The command’s exit status indicates the health status of the container.
+ 0: success - the container is healthy and ready for use.
+ 1: unhealthy - the container is not working correctly.

If a single run of the check takes longer than 3 seconds (`--timeout=3s`) then the check is considered to have failed. 
In this example, it will take 3 consecutive failures (`--retries=3`) of the health check for the container to be considered unhealthy.

## SHELL
The `SHELL` instruction allows the default shell used for the shell form of commands to be overridden. The default shell on Linux is `["/bin/sh", "-c"]`, and on Windows is `["cmd", "/S", "/C"]`. The `SHELL` instruction must be written in JSON form in a Dockerfile.

The `SHELL` instruction is particularly useful on Windows where there are two commonly used and quite different native shells: `cmd` and `powershell`, as well as alternate shells available including `sh`.

The `SHELL` instruction can appear multiple times. Each `SHELL` instruction overrides all previous `SHELL` instructions, and affects all subsequent instructions. 

**For example:**

```Dockerfile
FROM microsoft/windowsservercore

# Executed as cmd /S /C echo default
RUN echo default

# Executed as cmd /S /C powershell -command Write-Host default
RUN powershell -command Write-Host default

# Executed as powershell -command Write-Host hello
SHELL ["powershell", "-command"]
RUN Write-Host hello

# Executed as cmd /S /C echo hello
SHELL ["cmd", "/S", "/C"]
RUN echo hello
```