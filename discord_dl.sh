#!/bin/bash

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

sudo ln -sf "$APP_DIRECTORY/$APP_NAME/$APP_NAME" /usr/bin/discord

