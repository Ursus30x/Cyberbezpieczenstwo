# Generowanie klucza prywatnego serwera
echo $'\n Generowanie klucza prywatnego serwera \n\n'
openssl genrsa -out server/server-key.pem 2048

# Generowanie CSR dla serwera
echo $'\n Generowanie CSR dla serwera \n\n'
openssl req -config ca/openssl_server.cnf \
    -key server/server-key.pem \
    -new -sha256 -out server/server-csr.pem 

# Podpisanie certyfikatu serwera
echo $'\n Podpisanie certyfikatu serwera \n\n'
openssl ca -config ca/openssl_server.cnf \
    -extensions server_cert -days 375 -notext -md sha256 \
    -in server/server-csr.pem \
    -out server/server-cert.pem \
    -passin pass:2137 \
    -batch



# Weryfikacja certyfikatu serwera
echo $'\n Weryfikacja certyfikatu serwera \n\n'
openssl x509 -noout -text -in server/server-cert.pem

# Generowanie klucza prywatnego klienta
echo $'\n Generowanie klucza prywatnego klienta \n\n'
openssl genrsa -out client/client-key.pem 2048

# Generowanie CSR dla klienta
echo $'\n Generowanie CSR dla klientaa \n\n'
openssl req -config ca/openssl_client.cnf \
    -key client/client-key.pem \
    -new -sha256 -out client/client-csr.pem

# Podpisanie certyfikatu klienta
echo $'\n Podpisanie certyfikatu klienta \n\n'
openssl ca -config ca/openssl_client.cnf \
    -extensions client_cert -days 375 -notext -md sha256 \
    -in client/client-csr.pem \
    -out client/client-cert.pem \
    -passin pass:2137 \
    -batch


# Utworzenie pełnego łańcucha dla serwera
echo $'\n Utworzenie pełnego łańcucha dla serwera \n\n'
cat server/server-cert.pem ca/certs/ca-cert.pem > server/server-chain.pem

# Utworzenie pełnego łańcucha dla klienta  
echo $'\n  Utworzenie pełnego łańcucha dla klienta   \n\n'
cat client/client-cert.pem ca/certs/ca-cert.pem > client/client-chain.pem