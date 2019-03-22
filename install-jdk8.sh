#!/bin/bash
set -u

if [ "$EUID" -ne 0 ]
  then echo "Script requires administrative privileges. sudo ./install-openjdk.sh"
  exit
fi

DOWNLOAD_FILE="OpenJDK8U-jdk_x64_linux_hotspot_8u202b08.tar.gz"
DOWNLOAD_URL="https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u202-b08/$DOWNLOAD_FILE"
OPT_PATH="/opt/java/"
BASH_RC="/home/$SUDO_USER/.bashrc"

# Download
if [ ! -f $DOWNLOAD_FILE ]; then
	echo "Downloading and installing $DOWNLOAD_FILE..."
	wget --quiet --no-cookies --no-check-certificate "$DOWNLOAD_URL"
fi

# Untar
EXTRACTION_DIRECTORY="$(tar tfz $DOWNLOAD_FILE | head -1 | cut -d '/' -f1)"
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

# Finish up
echo "Adding JAVA_HOME to $BASH_RC etc."
cat <<EOF >> "$BASH_RC"
export JAVA_HOME=/opt/java/latest
export PATH=\$JAVA_HOME/bin:\$PATH
EOF

echo "finished."
