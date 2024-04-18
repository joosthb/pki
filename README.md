# Public key infrastructure

Example application of Mutual TLS infra based on EJBCA.

Features:
- Containerized
- Auto enrollment/rotation
- 


# Setup
Start with `docker compose up -d` and follow deployment with `docker compose logs -f` until initial login info is presented like:
```
jadsklsfjaskldfj
```


- Login with presented initial password
- Download (RSA2048) certificate in PKCS#12 format.
- Import certificate in browser (win/linux) or keychain (in user - login certs) and trust(MacOS)
- restart browser (seems to be necesary for certs to be recognized)
- head to [https://localhost/ejbca/adminweb/](https://localhost/ejbca/adminweb/)
