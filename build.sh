#! /bin/bash
rm -rf data

mkdir -p data/{intermediate_ca,root_ca}

echo -n "[empty]" > data/root_ca/index
echo -n "[empty]" > data/intermediate_ca/index
echo -n "00" > data/root_ca/serial
echo -n "00" > data/intermediate_ca/serial

openssl genrsa -out data/root_ca/root.key 2048
openssl req -new -key data/root_ca/root.key -out data/root_ca/root.csr -config root_req.config
openssl ca -in data/root_ca/root.csr -out data/root_ca/root.pem -config root.config -selfsign -extfile ca.ext -days 1095

openssl genrsa -out data/intermediate_ca/intermediate.key 2048
openssl req -new -key data/intermediate_ca/intermediate.key -out data/intermediate_ca/intermediate.csr -config intermediate_req.config
openssl ca -in data/intermediate_ca/intermediate.csr -out data/intermediate_ca/intermediate.pem -config root.config -extfile ca.ext -days 730

openssl genrsa -out data/leaf.key 2048
openssl req -new -key data/leaf.key -out data/leaf.csr -config leaf_req.config
openssl ca -in data/leaf.csr -out data/leaf.pem -config intermediate.config -days 365

openssl verify -x509_strict -CAfile data/root_ca/root.pem -untrusted data/intermediate_ca/intermediate.pem data/leaf.pem