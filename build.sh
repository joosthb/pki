#! /bin/bash
rm -rf data

mkdir -p data/{intermediate_ca,root_ca}

echo -n "[empty]" > data/root_ca/index
echo -n "[empty]" > data/intermediate_ca/index
echo -n "00" > data/root_ca/serial
echo -n "00" > data/intermediate_ca/serial

# Root CA
openssl req -newkey rsa:2048 -noenc \
    -keyout data/root_ca/root.key \
    -out data/root_ca/root.csr \
    -subj "/C=NL/CN=Test Root CA"
openssl ca -batch -in data/root_ca/root.csr \
    -out data/root_ca/root.pem \
    -config root.config \
    -selfsign -extfile ca.ext -days 1095

# Intermediate CA
openssl req -newkey rsa:2048 -noenc \
    -keyout data/intermediate_ca/intermediate.key \
    -out data/intermediate_ca/intermediate.csr \
    -subj "/C=NL/CN=Test Intermediate CA"
openssl ca -batch -in data/intermediate_ca/intermediate.csr \
    -out data/intermediate_ca/intermediate.pem \
    -config root.config -extfile ca.ext -days 730

# Leaf certificate
openssl req -newkey rsa:2048 -noenc \
    -keyout data/leaf.key \
    -out data/leaf.csr \
    -subj "/C=NL/CN=Test Leaf"
openssl ca -batch -in data/leaf.csr \
    -out data/leaf.pem \
    -config intermediate.config -days 365

# TODO expand fields later: "/C=NL/ST=GE/L=Nijmegen/O=server/CN=server.localhost"

# Verify certs
openssl verify -x509_strict -CAfile data/root_ca/root.pem -untrusted data/intermediate_ca/intermediate.pem data/leaf.pem