#!/usr/bin/env bash

# Check if root
if [ "$UID" -eq 0 ]; then
	echo ERROR!: The local installer is meant to be run by a user, not an administrative account \(root\)!
	exit 1
fi

# Check if "usr" exists; copy to local prefix if it does
if [ -d "usr" ]; then
	# Modify desktop file to point to local references
	sed -i "s|^\(Exec=\).*|\1$HOME/.local/bin/pipewire-config|" ./usr/share/applications/pipewireconfig.desktop

	# Copy application files to local prefix
	echo Copying application files...
	rsync -auP usr/* "$HOME/.local/"
	echo Finished copying application files!
# Check if "pipewire-config" exists; update if it does
elif [ -d "pipewire-config" ]; then
	# Check if git is installed
	if [ -x /usr/bin/git ]; then
		echo Updating pipewire-config...
		pushd pipewire-config
		git pull
		echo Finished updating pipewire-config!

		# Modify desktop file to point to local references
		sed -i "s|^\(Exec=\).*|\1$HOME/.local/bin/pipewire-config|" ./usr/share/applications/pipewireconfig.desktop

		# Copy application files to local prefix
		echo Copying application files...
		rsync -auP usr/* "$HOME/.local/"
		echo Finished copying application files!
	else
		echo "ERROR!: \`git\` must be installed, but it cannot be found."
		exit 2
	fi
# Clone files if "usr" and "pipewire-config" both do not exist
else
	#Check if git is installed
	if [ -x /usr/bin/git ]; then
		echo Downloading application files...
		git clone https://github.com/nickgirga/pipewire-config.git
		echo Finished downloading application files...

		# Modify desktop file to point to local references
		sed -i "s|^\(Exec=\).*|\1$HOME/.local/bin/pipewire-config|" ./pipewire-config/usr/share/applications/pipewireconfig.desktop

		# Copy application files to local prefix
		echo Copying application files...
		rsync -auP pipewire-config/usr/* "$HOME/.local/"
		echo Finished copying application files!
	else
		echo "ERROR!: \`git\` must be installed, but it cannot be found."
		exit 2
	fi
fi