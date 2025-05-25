# Generowanie klucza prywatnego serwera
openssl genrsa -out server/server-key.pem 2048

# Generowanie CSR dla serwera
openssl req -config ca/openssl.cnf \
    -key server/server-key.pem \
    -new -sha256 -out server/server-csr.pem

# Przykładowe dane:
# Country Name: PL
# State: Pomorskie
# City: Gdansk  
# Organization: Politechnika Gdanska
# Organizational Unit: IT Department
# Common Name: www.pg.edu.pl
# Email: webmaster@pg.edu.pl

# Podpisanie certyfikatu serwera
openssl ca -config ca/openssl.cnf \
    -extensions server_cert -days 375 -notext -md sha256 \
    -in server/server-csr.pem \
    -out server/server-cert.pem

# Weryfikacja certyfikatu serwera
openssl x509 -noout -text -in server/server-cert.pem