#!/bin/bash
DOWNLOAD_FILE="jdk-8u40-linux-x64.tar.gz"
DOWNLOAD_URL="http://download.oracle.com/otn-pub/java/jdk/8u40-b25/$DOWNLOAD_FILE"
EXTRACTION_DIRECTORY="jdk1.8.0_40"
# Download from Oracle
if [ ! -f $DOWNLOAD_FILE ]; then
	echo "Downloading and installing java from $DOWNLOAD_URL"
	wget --quiet --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" "$DOWNLOAD_URL"
fi

# Untar
echo "Extracting"
tar -xzf "$DOWNLOAD_FILE"
#rm -f "$DOWNLOAD_FILE"


# Move to /opt and create symlink
echo "Moving $EXTRACTION_DIRECTORY to /opt/java"
if [ ! -d "/opt/java" ]; then
	mkdir -p "/opt/java"
fi
cp -rf $EXTRACTION_DIRECTORY /opt/java/
rm -rf $EXTRACTION_DIRECTORY
if [ -h /opt/java/latest ]; then
	echo "Symbolic link already existing. Resetting."
	rm -f "/opt/java/latest"
fi
echo "Creating symlink /opt/java/latest linking to /opt/java/$EXTRACTION_DIRECTORY"
ln -s "/opt/java/$EXTRACTION_DIRECTORY" "/opt/java/latest"

# Update alternatives
echo "Updating alternatives..."
update-alternatives --install "/usr/bin/java" "java" "/opt/java/latest/bin/java" 1
update-alternatives --install "/usr/bin/javac" "javac" "/opt/java/latest/bin/javac" 1
update-alternatives --install "/usr/bin/javaws" "javaws" "/opt/java/latest/bin/javaws" 1
update-alternatives --install "/usr/bin/jar" "jar" "/opt/java/latest/bin/jar" 1
update-alternatives --install "/usr/lib/mozilla/plugins/mozilla-javaplugin.so" "mozilla-javaplugin.so" "/opt/java/latest/jre/lib/amd64/libnpjp2.so" 1
update-alternatives --config java
update-alternatives --config javac
update-alternatives --config javaws
update-alternatives --config jar
update-alternatives --config mozilla-javaplugin.so

# Finish up
echo "finished."
echo "Dont forget to add JAVA_HOME to your .bashrc etc..."
echo ">       JAVA_HOME=/opt/java/latest"
echo ">       export JAVA_HOME"
echo ""
