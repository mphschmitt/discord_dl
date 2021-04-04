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

APP_DIRECTORY="/opt"
APP_NAME="Discord"

DOWNLOAD_DIRECTORY="/tmp"
DOWNLOAD_PARAMETERS="stable?platform=linux&format=tar.gz"
URL="https://discord.com/api/download/$DOWNLOAD_PARAMETERS"

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

	wget "$URL" -P "$DOWNLOAD_DIRECTORY"
else
	curl -L "$URL" -o "$DOWNLOAD_DIRECTORY/$APP_NAME.tar.gz"
fi

tar -zxvf "/tmp/$APP_NAME.tar.gz" -C /tmp
sudo rm -rf "$APP_DIRECTORY/$APP_NAME"
sudo mv "$DOWNLOAD_DIRECTORY/$APP_NAME" "$APP_DIRECTORY/$APP_NAME"

if [ -f /usr/bin/$PROGRAM_NAME ]
then
	sudo rm "/usr/bin/$PROGRAM_NAME"
fi
sudo ln -s "$APP_DIRECTORY/$APP_NAME/$APP_NAME" "/usr/bin/$PROGRAM_NAME"

