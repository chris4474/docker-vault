#!/bin/bash
export VAULT_ADDR=https://vault.symphorines.home:8200
secrets=~/vault.sealkeys.json

echo "[*] - $(date) - Wait for Vault to start"
while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' ${VAULT_ADDR}/v1/sys/health)" != "501" ]] && \
      [[ "$(curl -s -o /dev/null -w ''%{http_code}'' ${VAULT_ADDR}/v1/sys/health)" != "503" ]] && \
      [[ "$(curl -s -o /dev/null -w ''%{http_code}'' ${VAULT_ADDR}/v1/sys/health)" != "200" ]]
do 
   sleep 3
done
echo "[+] - $(date) - Vault has started"

# Check if Vault has been initialized
if [ $(curl -s ${VAULT_ADDR}/v1/sys/health | jq .initialized) = "false" ]
then
  echo "[+] - $(date) - Initializing vault now"
  vault operator init -format=json > ${secrets}
else
  echo "[+] - $(date) - Vault already initialized"
fi

if [ $(curl -s ${VAULT_ADDR}/v1/sys/health | jq .sealed) = "true" ]
then
  echo "[+] - $(date) - unsealing vault now"
  count=$( cat ${secrets} | jq -r .unseal_threshold )
  for (( i = 0 ; i < $count ; i++ ))
  do
    vault operator unseal $(cat ${secrets} | jq -r .unseal_keys_hex[$i])
  done
fi

token=$(cat ${secrets} | jq -r .root_token)
vault login ${token}

