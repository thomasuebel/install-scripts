#!/bin/bash
DOWNLOAD_FILE="jdk-8u40-linux-x64.tar.gz"
DOWNLOAD_URL="http://download.oracle.com/otn-pub/java/jdk/8u40-b25/$DOWNLOAD_FILE"
EXTRACTION_DIRECTORY="jdk1.8.0_40"
echo "Downloading and installing java from $DOWNLOAD_URL"
wget --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" "$DOWNLOAD_URL"
tar -xzvf $DOWNLOAD_FILE
rm -f $DOWNLOAD_FILE
mv $EXTRACTION_DIRECTORY /opt/java/$EXTRACTION_DIRECTORY
if [ -h /opt/java/latest ]; then
	echo "Symbolic link already existing. Resetting."
	rm -f "/opt/java/latest"
fi
ln -s "/opt/java/$EXTRACTION_DIRECTORY" "/opt/java/latest"
