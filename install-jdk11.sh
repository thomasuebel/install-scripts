#!/bin/bash

DOWNLOAD_FILE="OpenJDK11U-jdk_x64_linux_hotspot_11.0.5_10.tar.gz"
DOWNLOAD_URL="https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.5%2B10/$DOWNLOAD_FILE"
EXTRACTION_DIRECTORY="jdk11.0.5_10"
OPT_PATH="/opt/java/"

# Download from Oracle
if [ ! -f $DOWNLOAD_FILE ]; then
	echo "Downloading and installing java from $DOWNLOAD_URL"
	wget --quiet --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" "$DOWNLOAD_URL"
fi

# Untar
echo "Extracting"
tar -xzf "$DOWNLOAD_FILE"
rm -f "$DOWNLOAD_FILE"

# Move to /opt and create symlink

echo "Moving $EXTRACTION_DIRECTORY to $OPT_PATH"
if [ ! -d $OPT_PATH ]; then
	mkdir -p "$OPT_PATH"
fi
cp -rf $EXTRACTION_DIRECTORY $OPT_PATH
rm -rf $EXTRACTION_DIRECTORY
if [ -h /opt/java/latest ]; then
	echo "Symbolic link already existing. Resetting."
	rm -f "/opt/java/latest"
fi
echo "Creating symlink /opt/java/latest linking to $OPT_PATH$EXTRACTION_DIRECTORY"
ln -s "$OPT_PATH$EXTRACTION_DIRECTORY" "/opt/java/latest"

# Update alternatives
echo "Creating symlinks..."
ln -s /opt/java/latest/bin/java /usr/bin/java
ln -s /opt/java/latest/bin/javac /usr/bin/javac
ln -s /opt/java/latest/bin/javaws /usr/bin/javaws
ln -s /opt/java/latest/bin/jar /usr/bin/jar
