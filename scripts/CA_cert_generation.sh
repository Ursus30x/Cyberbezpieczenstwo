
# Generacja klucza prywatnego CA
echo $'\n\nGeneracja klucza prywatnego CA\n'
openssl genrsa -aes256 -passout pass:2137 -out ca/private/ca-key.pem 4096

# Weryfikacja klucza
echo $'\n\nWerifikacja klucza (z blednym haslem)\n'
openssl rsa -in ca/private/ca-key.pem -text -noout -passin pass:420
# Bład!!!

echo $'\n\nWerifikacja klucza (z dobrym haslem)\n'
openssl rsa -in ca/private/ca-key.pem -text -noout -passin pass:2137
# Sukces


echo $'\n\nUtworzenie certyfikatu CA\n'
openssl req -config ca/openssl_client.cnf \
    -key ca/private/ca-key.pem \
    -new -x509 -days 7300 -sha256 \
    -extensions v3_ca \
    -out ca/certs/ca-cert.pem \
    -passin pass:2137


# Wyświetlenie szczegółów certyfikatu CA

echo $'\n\nWyswietlenie szczegółow certyfikatu CA\n'
openssl x509 -noout -text -in ca/certs/ca-cert.pem

# Sprawdzenie ważności certyfikatu

echo $'\n\nSprawdzenie jego ważności\n'
openssl x509 -in ca/certs/ca-cert.pem -noout -dates

# Wyświetlenie odcisku palca

echo $'\n\nSprawdzenie odcisku palca\n'
openssl x509 -noout -fingerprint -sha256 -in ca/certs/ca-cert.pem