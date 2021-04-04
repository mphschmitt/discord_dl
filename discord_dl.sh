#!/bin/bash

# discord_dl Download and update discord for Linux
# Copyright (C) 2021  Mathias Schmitt
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

PROGRAM_NAME="discord"
VERSION="1.0.0"

APP_DIRECTORY="/opt"
APP_NAME="Discord"

DOWNLOAD_DIRECTORY="/tmp"
URL_PTB="https://discord.com/api/download?platform=linux&format=tar.gz"
URL_CANARY="https://canary.discord.com/api/download?platform=linux&format=tar.gz"

version () {
	printf "discord_dl $VERSION\n"
	printf "\n"
	printf "Copyright (C) 2021 Mathias Schmitt\n"
	printf "License GPLv3+: GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>.\n"
	printf "This is free software, and you are welcome to change and redistribute it\n"
	printf "This program comes with ABSOLUTELY NO WARRANTY.\n"
}

usage () {
	printf "Usage: discord_dl [OPTIONS]\n"
	printf "Download and update discord for Linux\n"
	printf "  -h  --help       display this help message and exit\n"
	printf "  -p  --ptb        install the ptb version\n"
	printf "  -c  --canary     install the canary version\n"
	printf "  -v  --version    output version information and exit\n"
}

get_distribution () {
	OS="UNKNOWN"

	if [ -f /etc/os-release ]
	then
		. /etc/os-release
		OS=$NAME
	fi
	echo "$OS"
}

get_package_manager () {
	PKG="UNKNOWN"

	if [[ $(command -v "apt-get") != "" ]]
	then
		PKG="apt-get"
	elif [[ $(command -v "dnf") != "" ]]
	then
		PKG="dnf"
	elif [[ $(command -v "pacman") != "" ]]
	then
		PKG="pacman"
	elif [[ $(command -v "zypper") != "" ]]
	then
		PKG="pacman"
	elif [[ $(command -v "yum") != "" ]]
	then
		PKG="yum"
	fi

	echo "$PKG"
}

get_cmd () {
	CMD="$1 install curl wget"

	if [ "$1" == "pacman" ]
	then
		CMD="$1 -Sy curl wget"
	fi

	echo "$CMD"
}

install () {
	printf "Installing discord %b\n" $1

	if [[ $(command -v curl) == ""  ]]
	then
		echo "curl not found, trying wget..."

		if [[ $(command -v wget) == "" ]]
		then
			echo "wget not found..."
			DISTRIBUTION=$(get_distribution)
			echo "Linux distribution => $DISTRIBUTION"

			PKG_MNGR=$(get_package_manager "$DISTRIBUTION")
			echo "package manager => $PKG_MNGR"
			if [ "$PKG_MNGR" == "UNKNOWN" ]
			then
				echo "discord_dl could not detect your package manager."
				echo "Please, install either curl or wget with your distribution's package manager, and relaunch discord_dl"
				exit
			fi
			CMD=$(get_cmd $PKG_MNGR)
			echo "It seems curl and wget aren't installed on your system. Please, run '$CMD' and relaunch discord_dl"
			exit
		fi

		wget "$1" -P "$DOWNLOAD_DIRECTORY"
	else
		curl -L "$1" -o "$DOWNLOAD_DIRECTORY/$APP_NAME.tar.gz"
	fi

	tar -zxvf "$DOWNLOAD_DIRECTORY/$APP_NAME.tar.gz" -C /tmp
	sudo rm -rf "$APP_DIRECTORY/$APP_NAME"
	sudo mv "$DOWNLOAD_DIRECTORY/$APP_NAME" "$APP_DIRECTORY/$APP_NAME"

	if [ -f /usr/bin/$PROGRAM_NAME ]
	then
		sudo rm "/usr/bin/$PROGRAM_NAME"
	fi
	sudo ln -s "$APP_DIRECTORY/$APP_NAME/$APP_NAME" "/usr/bin/$PROGRAM_NAME"
}

if [ $# -eq 0 ]
then
	install $URL_PTB
elif [ $# -eq 1 ]
then
	if [ "$1" == "-v" ] || [ "$1" == "--version" ]
	then
		version
		exit
	elif [ "$1" == "-c" ] || [ "$1" == "--canary" ]
	then
		install $URL_CANARY
	elif [ "$1" == "-p" ] || [ "$1" == "--ptb" ]
	then
		install $URL_PTB
	elif [ "$1" == "-h" ] || [ "$1" == "--help" ]
	then
		usage
	else
		printf "Invalid argument: %b\n" "$1"
		usage
	fi
else
	printf "Too many arguments\n"
	usage
fi

