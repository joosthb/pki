# Create the necessary directory structure
mkdir ./data

# Create CA CSR and key - empty CN
openssl req -new -newkey rsa:4096 -nodes \
    -keyout data/ca-key.pem \
    -out data/ca-csr.pem \
    -subj "/C=NL/ST=GE/L=Nijmegen/O=ACME/CN=*.localhost"
    # -addext basicConstraints=critical,CA:TRUE,pathlen:1 \

# Sign certificate through CSR.
openssl x509 -req \
    -in data/ca-csr.pem \
    -signkey data/ca-key.pem \
    -out data/ca-cert.pem \
    -days 365 -sha256

# Create server CSR and key - Organisation: server, CN: localhost
openssl req -newkey rsa:4096 -nodes \
    -keyout data/server-key.pem \
    -out data/server-csr.pem \
    -subj "/C=NL/ST=GE/L=Nijmegen/O=server/CN=server.localhost"

# Sign server cert and create serial file
openssl x509 -req -days 365 \
    -in data/server-csr.pem \
    -CA data/ca-cert.pem \
    -CAkey data/ca-key.pem \
    -CAcreateserial -out data/server-cert.pem

# Create client CSR and key - Organisation: client, CN: localhost
openssl req -newkey rsa:4096 -nodes \
    -keyout data/client-key.pem \
    -out data/client-csr.pem \
    -subj "/C=NL/ST=GE/L=Nijmegen/O=client/CN=client.localhost"

# Sign client CSR using serial file
openssl x509 -req -days 365 \
    -in data/client-csr.pem \
    -CA data/ca-cert.pem \
    -CAkey data/ca-key.pem \
    -CAserial data/ca-cert.srl \
    -out data/client-cert.pem