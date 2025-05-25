# Utworzenie pliku do podpisania
echo $'Tworzenie dokumentu\n'
echo "To jest ważny dokument z Politechniki Gdańskiej" > document.txt

# Podpisanie pliku kluczem prywatnym
echo $'\nPodpisanie pliku kluczem prywatnym'
openssl dgst -sha256 -sign client/client-key.pem -out document.sig document.txt

# Weryfikacja podpisu
echo $'\nWeryfikacja podpisu'
openssl dgst -sha256 -verify <(openssl x509 -in client/client-cert.pem -pubkey -noout) \
    -signature document.sig document.txt

# Szyfrowanie pliku dla określonego odbiorcy
echo $'\nSzyfrowanie pliku dla określonego odbiorcy'
openssl rsautl -encrypt -pubin \
    -inkey <(openssl x509 -in server/server-cert.pem -pubkey -noout) \
    -in document.txt -out document.encrypted

# Odszyfrowanie pliku
echo $'\nOdszyfrowanie pliku'
openssl rsautl -decrypt -inkey server/server-key.pem \
    -in document.encrypted -out document.decrypted