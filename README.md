# Scotch CMake build

NOTE: Scotch 7.0 added the native ability to build with CMake, so this project is archived.

---

![ci](https://github.com/scivision/scotch-cmake/workflows/ci/badge.svg)

Building
[Scotch](https://gitlab.inria.fr/scotch/scotch)
as a CMake ExternalProject for easier use in CMake projects on Linux and MacOS.
Windows has platform-specific issues, so it is probably easier to use Scotch via Windows Subsystem for Linux.

The CMake script uses GNU Make to build Scotch.

## Usage

As with most CMake projects:

```sh
cmake -B build
cmake --build build
```

Since this project consumes Scotch as an
[ExternalProject](https://cmake.org/cmake/help/latest/module/ExternalProject.html),
Scotch is downloaded, built, and tested on the `cmake --build` command.

### Artifacts

Binary artifacts (test executables) are created under "build/".

* bin: test exectuables
* include: *.h headers
* lib: esmumps, scotch, scotcherr, scotcherrexist, scotchmetis

## Prereqs

A C99 compiler.

### Linux

The names of these packages vary slightly depending on Linux distro. On Ubuntu:

```sh
apt install gcc cmake make
```

### MacOS

assuming Homebrew is used:

```sh
brew install gcc cmake make
```
