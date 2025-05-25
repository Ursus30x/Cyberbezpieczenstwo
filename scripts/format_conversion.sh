#!/bin/bash

# Konwersja certyfikatu CA z PEM do DER
echo $'\n Konwersja certyfikatu CA z PEM do DER \n\n'
openssl x509 -outform der -in ca/certs/ca-cert.pem -out conversions/ca-cert.der
echo "ca/certs/"
ls -l ca/certs
echo $'\nconversions/'
ls -l conversions/

# Konwersja certyfikatu serwera z PEM do DER
echo $'\n Konwersja certyfikatu serwera z PEM do DER \n\n'
openssl x509 -outform der -in server/server-cert.pem -out conversions/server-cert.der
echo $'\nserver/'
ls -l server/
echo $'\nconversions/'
ls -l conversions/

# Konwersja z DER do PEM
echo $'\n Konwersja z DER do PEM \n\n'
openssl x509 -inform der -in conversions/ca-cert.der -out conversions/ca-cert-from-der.pem
echo $'\nconversions/'
ls -l conversions/

# Konwersja do formatu PKCS#12 (zawiera klucz prywatny i certyfikat)
echo $'\n Konwersja do formatu PKCS#12  \n\n'
openssl pkcs12 -export -out conversions/server.p12 \
    -inkey server/server-key.pem \
    -in server/server-cert.pem \
    -certfile ca/certs/ca-cert.pem \
    -name "PG Server Certificate" \
    -passin pass:2137 \
    -passout pass:2137

# Konwersja klienta do PKCS#12
echo $'\n Konwersja klienta do PKCS#12  \n\n'
openssl pkcs12 -export -out conversions/client.p12 \
    -inkey client/client-key.pem \
    -in client/client-cert.pem \
    -certfile ca/certs/ca-cert.pem \
    -name "PG Client Certificate" \
    -passin pass:2137 \
    -passout pass:2137

# Konwersja klucza z PEM do DER
echo $'\n Konwersja klucza z PEM do DER \n\n'
openssl rsa -in server/server-key.pem -passin pass:2137 -outform DER -out conversions/server-key.der
echo $'\nserver/'
ls -l server/
echo $'\nconversions/'
ls -l conversions/

# Konwersja klucza z DER do PEM
echo $'\n Konwersja klucza z DER do PEM \n\n'
openssl rsa -in conversions/server-key.der -inform DER -out conversions/server-key-from-der.pem
echo $'\nconversions/'
ls -l conversions/

# Szyfrowanie klucza prywatnego (z podaniem hasła 2137)
echo $'\n Szyfrowanie klucza prywatnego  \n\n'
openssl rsa -aes256 -in server/server-key.pem -passin pass:2137 -passout pass:2137 \
    -out conversions/server-key-encrypted.pem
echo $'\nserver/'
ls -l server/
echo $'\nconversions/'
ls -l conversions/

# Wyświetlenie informacji o różnych formatach
echo $'\n\n================================== Format PEM ==================================\n'
file ca/certs/ca-cert.pem
head -3 ca/certs/ca-cert.pem

echo $'\n\n================================== Format DER ==================================\n'
file conversions/ca-cert.der
hexdump -C conversions/ca-cert.der | head -3

echo $'\n\n================================ Format PKCS#12 ================================\n'
file conversions/server.p12
openssl pkcs12 -info -in conversions/server.p12 -passin pass:2137 -noout
