
echo $'\nWeryfikacja certyfikatów:'
# Weryfikacja certyfikatu serwera względem CA
openssl verify -CAfile ca/certs/ca-cert.pem server/server-cert.pem

# Weryfikacja certyfikatu klienta względem CA
openssl verify -CAfile ca/certs/ca-cert.pem client/client-cert.pem

# Weryfikacja łańcucha certyfikatów
openssl verify -CAfile ca/certs/ca-cert.pem -untrusted server/server-cert.pem server/server-chain.pem

# Sprawdzenie dat ważności
echo $'\n=== Ważność CA ==='
openssl x509 -in ca/certs/ca-cert.pem -noout -dates

echo $'\n=== Ważność serwera ==='
openssl x509 -in server/server-cert.pem -noout -dates

echo $'\n=== Ważność klienta ==='
openssl x509 -in client/client-cert.pem -noout -dates

# Sprawdzenie podpisu certyfikatu serwera
echo $'\nSprawdzenie podpisu certyfikatu serwera:'
openssl x509 -in server/server-cert.pem -noout -text | grep -A5 "Signature Algorithm"

# Porównanie kluczy publicznych
#echo $'\n=== Klucz publiczny z certyfikatu ==='
openssl x509 -in server/server-cert.pem -noout -pubkey > /tmp/pub-from-cert.pem

#echo $'\n=== Klucz publiczny z klucza prywatnego ==='
openssl rsa -in server/server-key.pem -pubout > /tmp/pub-from-key.pem

# Porównanie
echo $'\n=== Porownanie kluczy publicznych wygenerowanych z certyfikatu oraz klucza prywatnego ==='
diff /tmp/pub-from-cert.pem /tmp/pub-from-key.pem
echo "Status porównania: $?"

# Generowanie listy odwołanych certyfikatów
echo $'\n=== Generacja CRL ==='
openssl ca -config ca/openssl_server.cnf -gencrl -out ca/crl/ca-crl.pem -passin pass:2137

# Sprawdzenie CRL
openssl crl -in ca/crl/ca-crl.pem -noout -text

echo $'\n=== Weryfikacja z uwzglednieniem CRL przed odwolaniem ==='
openssl verify -CAfile ca/certs/ca-cert.pem -CRLfile ca/crl/ca-crl.pem -crl_check server/server-cert.pem

# Odwołanie certyfikatu (symulacja)
openssl ca -config ca/openssl_server.cnf -revoke server/server-cert.pem -passin pass:2137

# Wygenerowanie nowej CRL
openssl ca -config ca/openssl_server.cnf -gencrl -out ca/crl/ca-crl.pem

echo $'\n=== Weryfikacja z uwzglednieniem CRL po odwolaniem ==='
openssl verify -CAfile ca/certs/ca-cert.pem -CRLfile ca/crl/ca-crl.pem -crl_check server/server-cert.pem
