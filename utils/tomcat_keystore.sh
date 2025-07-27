#!/bin/bash
openssl=$(which openssl)
keytool=$(which keytool)

if [ -z "$openssl" ] || [ -z "$keytool" ]; then
  echo "OpenSSL or Keytool not found. Please install them first."
  exit 1
fi
openssl genrsa -out testCA.key 2048
openssl req -x509 -new -nodes -key testCA.key -sha256 -days 3650 -out testCA.crt -config localhost.cnf -extensions v3_ca -subj "/CN=PHAMCS Test CA"
# Create Server certificate
openssl genrsa -out localhost.key 2048
openssl req -new -key localhost.key -out localhost.csr -config localhost.cnf -extensions v3_req
openssl x509 -req -in localhost.csr -CA testCA.crt -CAkey testCA.key -CAcreateserial -out localhost.crt -days 3650 -sha256 -extfile localhost.cnf -extensions v3_req
openssl pkcs12 -export -out localhost.p12 -in localhost.crt -inkey localhost.key -certfile testCA.crt -password pass:changeme
if [ $? -ne 0 ]; then
  echo "Failed to create PKCS12 file."
  exit 1
fi
keytool -importkeystore -srckeystore localhost.p12 -srcstoretype PKCS12 -srcstorepass changeme -destkeystore tomcat.keystore -deststorepass P@ssw0rd
if [ $? -ne 0 ]; then
  echo "Failed to import keystore."
  exit 1
fi
keytool -import -alias tomcat -keystore tomcat.keystore -trustcacerts -file testCA.crt -noprompt
read -p "Enter Tomcat SSL config path: " TC_SSL
mkdir -p $TC_SSL
mv -f tomcat.keystore $TC_SSL/tomcat.keystore
if [ $? -ne 0 ]; then
  echo "Failed to move keystore to Tomcat conf directory."
  exit 1
fi
echo "Tomcat keystore created and configured successfully."
echo "You can now configure your Tomcat server to use this keystore."
echo "Following these steps below:"
echo "1. Set tomcat:tomcat ownership for the keystore."
echo "2. Set the keystore password in your Tomcat server configuration."
echo "3. Setup tomcat connector to use custom keystore in server.xml."
echo "Example: <Connector port="8443" maxThreads="200" scheme="https" secure="true" SSLEnabled="true" keystoreFile="conf/ssl/tomcat.keystore" keystorePass="Your-Dest-Password" clientAuth="false" sslProtocol="TLS">"
echo "All steps are done."
echo "You can now start your Tomcat server."
