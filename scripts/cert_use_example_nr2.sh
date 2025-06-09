# Test z certyfikatem klienta
openssl s_client -connect www.pg.edu.pl:443 \
    -cert client/client-cert.pem \
    -key client/client-key.pem
