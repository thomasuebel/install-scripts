#!/bin/bash
JAVA_FILE = jdk-8u40-linux-x64.tar.gz
wget --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u40-b25/$JAVA_FILE"
tar -xzvf $JAVA_FILE


