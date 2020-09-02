

all: build

codegen:
	npx graph codegen subgraph.ropsten.yaml

build: codegen
	npx graph build subgraph.ropsten.yaml

deploy: codegen
	npx graph deploy --debug --node https://api.thegraph.com/deploy/ --ipfs https://api.thegraph.com/ipfs/ sulliwane/mcdex-ropsten-subgraph subgraph.ropsten.yaml
