#!/bin/bash
set -eu

DOWNLOAD_FILE="gradle-4.10.3-bin.zip"
DOWNLOAD_URL="https://services.gradle.org/distributions/$DOWNLOAD_FILE"
EXTRACTION_DIRECTORY="gradle-4.10.3"
OPT_PATH="/opt/gradle/"
SYMLINK="latest"

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Download
if [ ! -f $DOWNLOAD_FILE ]; then
        echo "Downloading and installing $DOWNLOAD_FILE from $DOWNLOAD_URL"
        wget --quiet --no-cookies --no-check-certificate "$DOWNLOAD_URL"
fi

# Untar
echo "Extracting"
unzip "$DOWNLOAD_FILE"
rm -f "$DOWNLOAD_FILE"

# Move to /opt and create symlink
echo "Moving $EXTRACTION_DIRECTORY to $OPT_PATH"
if [ ! -d $OPT_PATH ]; then
        mkdir -p "$OPT_PATH"
fi
cp -rf $EXTRACTION_DIRECTORY $OPT_PATH
rm -rf $EXTRACTION_DIRECTORY
if [ -h "$OPT_PATH$SYMLINK" ]; then
        echo "Symbolic link already existing. Resetting."
        rm -f "$OPT_PATH$SYMLINK"
fi
echo "Creating symlink $OPT_PATH$SYMLINK linking to $OPT_PATH$EXTRACTION_DIRECTORY"
ln -s "$OPT_PATH$EXTRACTION_DIRECTORY" "$OPT_PATH$SYMLINK"

echo "Done."
echo "Add $OPT_PATH$SYMLINK/bin to your PATH variable"

