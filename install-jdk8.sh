#!/bin/bash
DOWNLOAD_FILE="jdk-8u171-linux-x64.tar.gz"
DOWNLOAD_URL="http://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/$DOWNLOAD_FILE"
EXTRACTION_DIRECTORY="jdk1.8.0_171"
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
