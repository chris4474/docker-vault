vault secrets enable --path intca pki
vault write intca/config/ca pem_bundle=@/home/chris/rootca/ca/intca/private/bundle-key-cert-cachain.pem
vault secrets tune -max-lease-ttl=87600h intca
vault write intca/roles/symphorines allowed_domains="symphorines.home" allow_subdomains=true max_ttl=8760h # TTL = 1 an
vault write -format=json intca/issue/symphorines \
            common_name=foo1.symphorines.home \
            alt_names="foo2.symphorines.home,foo3.symphorines.home" >/tmp/res.json
cat /tmp/res.json | jq -r .data.certificate | openssl x509 -text -noout | head -24
