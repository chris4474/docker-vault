Adapted from https://github.com/CptOfEvilMinions/BlogProjects/Docker-vault.
Change consists in running the vault server using TLS certificates
1) store the TLS certificate chain (server certificates + chain of intermediate CAs) under ./conf/vault/cert.pem
2) store the corressponding TLS key under ./conf/vault/key.pem. The key must NOT be encrypted
then docker-compose up -build
