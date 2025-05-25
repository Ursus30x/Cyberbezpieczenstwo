#sudo apt-get update 
#sudo apt-get upgrade
#sudo apt-get install openssl

mkdir -p openssl-project/{ca/{private,certs,newcerts,crl},server,client,conversions}
cd openssl-project 
chmod 700 ca/private

touch ca/index.txt
echo 1000 > ca/serial
echo 1000 > ca/crlnumber

echo "Skopiuj openssl_client.cnf do ca/"
echo "Skopiuj openssl_server.cnf do ca/"
