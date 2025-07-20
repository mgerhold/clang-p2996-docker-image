# 🛠 clang-p2996 Dev Container

A **prebuilt Docker-based development environment** for working with [Bloomberg’s `clang-p2996`](https://github.com/bloomberg/clang-p2996) on Ubuntu 24.04.

This container includes:

- Clang built from source (with `clang-p2996` patches)
- Latest CMake from Kitware
- Ninja build system
- Python 3.13 (via Deadsnakes)
- GNU Debugger (`gdb`)
- `uv` package manager
- Configured `PATH` and `LD_LIBRARY_PATH`

## 📦 Available as a Public Image

Pull the latest image from GitHub Container Registry:

```bash
docker pull ghcr.io/mgerhold/clang-p2996:latest
```

## 🚀 Quickstart

Run the container interactively:

```bash
docker run -it --rm ghcr.io/mgerhold/clang-p2996:latest /bin/bash
```

From here, you can clone your project and build it using clang, CMake, Ninja, etc.

Ideally, you'd use this image as a base for a dev container.
