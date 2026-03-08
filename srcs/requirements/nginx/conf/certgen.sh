#!/bin/bash

CERT_KEY="/etc/ssl/private/cert.key"
CERT_CRT="/etc/ssl/certs/cert.pem"

if [ -f "$CERT_KEY" ] && [ -f "$CERT_CRT" ]; then
    echo "Certificate already created(skipping)"
else
    echo "Generating certificate..."
    
    openssl ecparam -name prime256v1 -genkey -noout -out "$CERT_KEY"
    
    openssl req -new -x509 \
        -key "$CERT_KEY" \
        -out "$CERT_CRT" \
        -days 365 \
        -subj "/C=BR/ST=RJ/L=Rio de Janeiro/O=42/OU/RIO/CN=${WP_HOST}"
fi
