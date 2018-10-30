.DEFAULT_GOAL = help

## Use stack to continuously rebuild/run the demo web service
feedback-loop:
	@stack install hsv:exe:hsv-exe --file-watch --ghc-options=-freverse-errors --fast --exec='./run.sh'

install-vault:
	@wget --continue https://releases.hashicorp.com/vault/0.11.4/vault_0.11.4_linux_amd64.zip
	@unzip vault_0.11.4_linux_amd64.zip
	@mv vault ~/bin/vault-0.11.4
	@ln -sf ~/bin/vault-0.11.4 ~/bin/vault

VAULT_ADDR=http://127.0.0.1:8200

run-vault:
	@vault server -dev

init-vault:
	@VAULT_ADDR=http://127.0.0.1:8200 vault operator init -format=json > init-response.json

vault-list:
	@VAULT_ADDR=http://127.0.0.1:8200 vault kv list

vault-read-hsv-secret:
	@VAULT_ADDR=http://127.0.0.1:8200 vault read secret/data/hsv

vault-enable-transit:
	@VAULT_ADDR=http://127.0.0.1:8200 vault secrets enable transit

vault-encrypt-transit:
	@VAULT_ADDR=http://127.0.0.1:8200 vault write -format=json transit/encrypt/hsv @plaintext.json | jl '_.data' > ciphertext.json

vault-decrypt-transit:
	@VAULT_ADDR=http://127.0.0.1:8200 vault write -format=json transit/decrypt/hsv @ciphertext.json | jl '_.data.plaintext' | sed 's/"//g' | base64 --decode

## Show help screen.
help:
	@echo "Please use \`make <target>' where <target> is one of\n\n"
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "%-30s %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)
