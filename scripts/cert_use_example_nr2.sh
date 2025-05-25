# Test połączenia SSL z serwerem
openssl s_client -connect www.pg.edu.pl:443 -CAfile ca/certs/ca-cert.pem

# Test z certyfikatem klienta
openssl s_client -connect www.pg.edu.pl:443 \
    -CAfile ca/certs/ca-cert.pem \
    -cert client/client-cert.pem \
    -key client/client-key.pem

# Sprawdzenie szczegółów SSL
echo | openssl s_client -connect www.pg.edu.pl:443 2>/dev/null | \
    openssl x509 -noout -text