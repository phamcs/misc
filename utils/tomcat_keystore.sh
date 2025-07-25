#!/bin/bash
CA="/etc/pki/tls/certs/ca-bundle.crt"
TC_SSL="/usr/share/tomcat/conf/ssl"
openssl=$(which openssl)
keytool=$(which keytool)

if [ -z "$openssl" ] || [ -z "$keytool" ]; then
  echo "OpenSSL or Keytool not found. Please install them first."
  exit 1
fi
openssl req -x509 -newkey rsa:4096 -keyout localhost-rsa-key.pem -out localhost-rsa-cert.pem -days 3650
openssl pkcs12 -export -in localhost-rsa-cert.pem -inkey localhost-rsa-key.pem -out localhost.p12 -name tomcat -chain -CAfile $CA
if [ $? -ne 0 ]; then
  echo "Failed to create PKCS12 file."
  exit 1
fi
read -p -s "Enter destination key password: " DSTKEYPASS
read -p -s "Enter source key password: " SRCKEYPASS
keytool -importkeystore -deststorepass $DSTKEYPASS -destkeypass $DSTKEYPASS -destkeystore tomcat.keystore -srckeystore localhost.p12 -srcstoretype PKCS12 –srcstorepass $SRCPASS -alias tomcat
if [ $? -ne 0 ]; then
  echo "Failed to import keystore."
  exit 1
fi
keytool -import -alias tomcat -keystore tomcat.keystore -trustcacerts -file $CA -noprompt
mkdir -p $TC_SSL
mv tomcat.keystore $TC_SSL/tomcat.keystore
if [ $? -ne 0 ]; then
  echo "Failed to move keystore to Tomcat conf directory."
  exit 1
fi
chown tomcat:tomcat $TC_SSL/tomcat.keystore
if [ $? -ne 0 ]; then
  echo "Failed to change ownership of the keystore."
  exit 1
fi
echo "Tomcat keystore created and configured successfully."
echo "You can now configure your Tomcat server to use this keystore."
echo "Remember to set the keystore password in your Tomcat server configuration."
echo "Remember to setup tomcat connector to use custom keystore in server.xml."
echo "<Connector port="8443" maxThreads="200" scheme="https" secure="true" SSLEnabled="true" keystoreFile="conf/ssl/tomcat.keystore" keystorePass="Your-Dest-Password" clientAuth="false" sslProtocol="TLS">"
echo "Done."
echo "You can now start your Tomcat server."


