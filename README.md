# Table of Contents

- [About the project](#discord_dl)
- [Install](#installation)
- [Usage](#usage)
- [How does it work](#how-does-it-work)
- [License](#license)
- [Contact](#contact)


# discord_dl

Discord installation management for Linux.

discord_dl downloads, installs and updates Discord on a Linux system. This avoid the hassle of manual installation and updates.
Discord is also added to your *$PATH*, so that it can be launched easily.

# Installation

discord_dl uses either *curl* or *wget* to download Discord, depending on what is installed on your computer. Make sure at least one of them is installed:

For Fedora:
```
sudo dnf install curl wget
```

For Debian
```
sudo apt-get install curl wget
```

Install discord_dl on your system

```
sudo make install
```

By default, discord_dl is installed in `/usr/local/bin/discord_dl`.

A manual is also installed, in both english and french in `/usr/local/share/man`. You can read it with the following command:
```
man discord_dl
```

# Usage

discord_dl is a pretty simple tool.

Install Discord:

```
discord_dl
```

Update Discord:

```
discord_dl
```

You can choose between two different versions of Discord:
- ptb (stable)
- canary (alpha)

The canary build offers more features and bug fixes, but is also likely less stable (thus the name).
By default, discord_dl installs the ptb build, but you can switch between versions anytime you want.

To install the canary build:

```
discord_dl --canary
```

To reinstall the ptb build:

```
discord_dl
```

To obtain help, you can type:

```
discord_dl --help
```

To launch discord, type:

```
discord
```

Uninstall discord_dl:

```
sudo make uninstall
```

# How does it work

Discord is downloaded and installed in `/opt/Discord`.

By default, Discord is blocking, and displays output to the stdout.
To avoid that, discord_dl creates a wrapper aroung Discord, launching it as a background process and redirecting its output to */dev/null*.

When calling `discord`, you are actually calling `/opt/discord_wrapper.sh` symlinked to `/usr/bin/discord`.

# License

Distributed under GPL License. See `COPYING` for more information.

# Contact

Mathias Schmitt - mathiaspeterhorst@gmail.com     
Project link: https://github.com/mphschmitt/discord_dl
