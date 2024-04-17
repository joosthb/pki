# pki
Example of an OpenSSL based public key infrastructure for education purposes.


Thanks to [Millie Smith](https://superuser.com/a/1590560).


## Directory structure
```
ca.ext              # the extensions required for a CA certificate for signing certs
intermediate.config # configuration for the intermediate CA
root.config         # configuration for the root CA

leaf_req.config         # configuration for the leaf cert's csr
intermediate_req.config # configuration for the intermediate CA's csr
root_req.config         # configuration for the root CA's csr

intermediate_ca/    # state files specific to the intermediate CA
    index           # a text database of issued certificates
    serial          # an auto-incrementing serial number for issued certificates
root_ca/            # state files specific to the root CA
    index           # a text database of issued certificates
    serial          # an auto-incrementing serial number for issued certificates
```

## Commands
```
# create the private key for the root CA
openssl genrsa 
    -out root.key # output file
    2048          # bitcount

# create the csr for the root CA
openssl req 
    -new 
    -key root.key           # private key associated with the csr
    -out root.csr           # output file
    -config root_req.config # contains config for generating the csr such as the distinguished name

# create the root CA cert
openssl ca 
    -in root.csr        # csr file
    -out root.pem       # output certificate file
    -config root.config # CA configuration file
    -selfsign           # create a self-signed certificate
    -extfile ca.ext     # extensions that must be present for CAs that sign certificates
    -days 1095          # 3 years

# create the private key for the intermediate CA
openssl genrsa 
    -out intermediate.key # output file
    2048                  # bitcount

# create the csr for the intermediate CA
openssl req 
    -new 
    -key intermediate.key           # private key associated with the csr
    -out intermediate.csr           # output file
    -config intermediate_req.config # contains config for generating the csr such as the distinguished name

# create the intermediate CA cert
openssl ca 
    -in intermediate.csr  # csr file
    -out intermediate.pem # output certificate file
    -config root.config   # CA configuration file (note: root is still issuing)
    -extfile ca.ext       # extensions that must be present for CAs that sign certificates
    -days 730             # 2 years

# create the private key for the leaf certificate
openssl genrsa 
    -out leaf.key # output file
    2048          # bitcount

# create the csr for the leaf certificate
openssl req 
    -new 
    -key leaf.key           # private key associated with the csr
    -out leaf.csr           # output file
    -config leaf_req.config # contains config for generating the csr such as the distinguished name

# create the leaf certificate (note: no ca.ext. this certificate is not a CA)
openssl ca 
    -in leaf.csr                # csr file
    -out leaf.pem               # output certificate file
    -config intermediate.config # CA configuration file (note: intermediate is issuing)
    -days 365                   # 1 year

# verify the certificate chain
openssl verify 
    -x509_strict                # strict adherence to rules
    -CAfile root.pem            # root certificate
    -untrusted intermediate.pem # file with all intermediates
    leaf.pem                    # leaf certificate to verify
```