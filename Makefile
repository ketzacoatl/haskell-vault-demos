MAKEFLAGS = -s 
.DEFAULT_GOAL = help

export VAULT_VERSION = 1.1.3
export VAULT_ROOT_TOKEN = xyzrootoken
export VAULT_ADDR = http://127.0.0.1:8200

require-%:
	if [ "${${*}}" = "" ]; then \
		echo "ERROR: Environment variable not set: \"$*\""; \
		exit 1; \
	fi

## Use stack to continuously rebuild/run the tool, for dev
feedback-loop:
	stack install --file-watch --ghc-options=-freverse-errors --fast --exec='./run.sh'

## Use ghcid to continuously rebuild/run the tool, for dev, for sublime
ghcid-loop:
	ghcid -o src/ghcid.txt --command 'stack repl --test --ghc-options=-O0' --restart *.cabal --restart package.yaml --restart stack.yaml

## Use stack to build the hcron tool (for CI/etc)
build:
	stack build --install-ghc --pedantic --test

## Use wget to download the vault executable
get-vault:
	wget -O ./vault.zip https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip
	unzip ./vault.zip
	mv ./vault ./vault-${VAULT_VERSION}
	chmod +x ./vault-${VAULT_VERSION}
	rm -f ./vault.zip

## Run vault in dev mode
run-vault:
	./vault-${VAULT_VERSION} server -dev -config=vault-config.hcl -dev-root-token-id=${VAULT_ROOT_TOKEN}

## use kv get to retrieve the named secret
get-kv-secret: require-KEY
	./vault-${VAULT_VERSION} kv get ${KEY}

## write some foo to secret/hello in the vault
write-hello-secret:
	./vault-${VAULT_VERSION} kv put secret/hello foo=world excited=yes

## write some foo to secret/hello in the vault
read-hello-secret:
	$(MAKE) get-kv-secret KEY=secret/hello

## Run 'vault status'
status:
	./vault-${VAULT_VERSION} status

## Run 'vault list' with ARGS
list: require-ARGS
	./vault-${VAULT_VERSION} list ${ARGS}

## Run 'vault kv list' with ARGS
kv-list: require-ARGS
	./vault-${VAULT_VERSION} kv list ${ARGS}

## Show help screen.
help:
	echo "Please use \`make <target>' where <target> is one of\n\n"
	awk '/^[a-zA-Z\-\_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "%-30s %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)
