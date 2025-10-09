-include .env

.PHONY: all test clean deploy fund help install snapshot format anvil scopefile flatten encryptKey zkbuild zktest zkdeploy

DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
DEFAULT_ZKSYNC_LOCAL_KEY := 0x7726827caac94a7f9e1b160f7ea819f172f7b6f9d2a97f992c38edeab82d4110
CONTRACT_DEPLOYER_MAINNET := 0x0000000000000000000000000000000000008006

all: remove install build

# Clean the repo
clean :; forge clean

# Remove modules
remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

install:
	@echo "📦 Installing dependencies..."
	@forge install foundry-rs/forge-std@v1.8.2 --no-commit
	@forge install openzeppelin/openzeppelin-contracts@v5.0.2 --no-commit
	@forge install eth-infinitism/account-abstraction@v0.7.0 --no-commit
	@forge install cyfrin/foundry-era-contracts@0.0.3 --no-commit
	@forge install cyfrin/foundry-devops@0.2.2 --no-commit
	@echo "✅ All dependencies installed successfully!"

# Update Dependencies
update:; forge update

format :; forge fmt

anvil :; anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

slither :; slither . --config-file slither.config.json 

aderyn :; aderyn .

scope :; tree ./src/ | sed 's/└/#/g; s/──/--/g; s/├/#/g; s/│ /|/g; s/│/|/g'

scopefile :; @tree ./src/ | sed 's/└/#/g' | awk -F '── ' '!/\.sol$$/ { path[int((length($$0) - length($$2))/2)] = $$2; next } { p = "src"; for(i=2; i<=int((length($$0) - length($$2))/2); i++) if (path[i] != "") p = p "/" path[i]; print p "/" $$2; }' > scope.txt

# /*//////////////////////////////////////////////////////////////
#                               EVM
# //////////////////////////////////////////////////////////////*/
build:; forge build 

test :; forge test

# Run specific test pattern
test-pattern:
	@echo "Usage: make test-pattern PATTERN=testOwnerCanExecuteCommands"
	@if [ -z "$(PATTERN)" ]; then echo "❌ Please provide PATTERN=<test_name>"; exit 1; fi
	@forge test --mt $(PATTERN) -vvv

testFork :; forge test --fork-url mainnet

snapshot :; forge snapshot 

# /*//////////////////////////////////////////////////////////////
#                          EVM - SCRIPTS
# //////////////////////////////////////////////////////////////*/
# How we got the mock entrypoint contract so quick
getEntryPoint :; forge clone -c 1 --etherscan-api-key ${ETHERSCAN_API_KEY} 0x0000000071727De22E5E9d8BAf0edAc6f37da032 --no-git

flattenClone :; forge flatten src/core/EntryPoint.sol > MockEntryPoint.sol

deployEth :; @echo "⚠️  WARNING: This will deploy to a live network. Make sure you're using test funds only!" && forge script script/DeployMinimal.s.sol --rpc-url arbitrum --sender ${SMALL_MONEY_SENDER} --account smallmoney --broadcast --verify -vvvv

verify :; forge verify-contract --etherscan-api-key ${ETHERSCAN_API_KEY} --rpc-url ${MAINNET_RPC_URL} XXX <PATH_TO_CONTRACT>

getCalldata :; cast calldata "approve(address,uint256)" 0x9EA9b0cc1919def1A3CfAEF4F7A66eE3c36F86fC 100000000000000000000

estimate :; cast estimate "approve(address,uint256)" "approve(address,uint256)" 0x9EA9b0cc1919def1A3CfAEF4F7A66eE3c36F86fC 100000000000000000000

sendUserOp :; @echo "⚠️  WARNING: This will send a real transaction. Make sure you're using test funds only!" && forge script script/SendPackedUserOp.s.sol --rpc-url arbitrum --sender ${SMALL_MONEY_SENDER} --account smallmoney --broadcast -vvvv

# /*//////////////////////////////////////////////////////////////
#                              ZKSYNC
# //////////////////////////////////////////////////////////////*/
zkbuild:; foundryup-zksync && forge build --zksync && foundryup

zktest :; foundryup-zksync && forge test --zksync --system-mode=true && foundryup

# /*//////////////////////////////////////////////////////////////
#                         ZKSYNC -SCRIPTS
# //////////////////////////////////////////////////////////////*/
zkanvil :; npx zksync-cli dev start

flatten :; tail -n +4 <(forge flatten src/zksync/ZkMinimalAccount.sol) > ZkMinimalFlat.sol

encryptKey :; yarn encryptKey

zkdeploy :; yarn deploy 

sendTx :; yarn sendTx

# /*//////////////////////////////////////////////////////////////
#                              HELP
# //////////////////////////////////////////////////////////////*/
help:
	@echo "Account Abstraction Demo Project Commands:"
	@echo ""
	@echo "🔧 Setup Commands:"
	@echo "  make install     - Install all dependencies"
	@echo "  make build       - Build the project"
	@echo "  make clean       - Clean build artifacts"
	@echo "  make update      - Update dependencies"
	@echo ""
	@echo "🧪 Testing Commands:"
	@echo "  make test        - Run all Ethereum tests"
	@echo "  make zktest      - Run zkSync tests"
	@echo "  make snapshot    - Generate gas snapshots"
	@echo ""
	@echo "🚀 Deployment Commands:"
	@echo "  make deployEth   - Deploy to Ethereum networks (⚠️ Use test funds only!)"
	@echo "  make zkdeploy    - Deploy to zkSync"
	@echo "  make sendUserOp  - Send UserOperation (⚠️ Use test funds only!)"
	@echo ""
	@echo "🔍 Utility Commands:"
	@echo "  make zkbuild     - Build for zkSync"
	@echo "  make anvil       - Start local Ethereum node"
	@echo "  make zkanvil     - Start local zkSync node"
	@echo "  make flatten     - Flatten zkSync contract"
	@echo "  make format      - Format code"
	@echo ""
	@echo "⚠️  SECURITY WARNING: This is for DEMO purposes only!"
	@echo "   Never use private keys with real funds!"

# Shortcut commands for common workflows
dev: install build test
	@echo "✅ Development environment ready!"

ethereum-test: build test
	@echo "✅ Ethereum tests completed!"

zksync-test: zkbuild zktest
	@echo "✅ zkSync tests completed!"