# Account Abstraction Demo Project

A comprehensive demonstration of **ERC-4337 Account Abstraction** implementation using Foundry, supporting both Ethereum and zkSync networks. This project showcases smart contract wallets that enable gasless transactions, batch operations, and enhanced user experiences.

> ⚠️ **IMPORTANT SECURITY NOTICE**  
> This project is for **EDUCATIONAL AND DEMO PURPOSES ONLY**. Never use private keys with real funds. All examples use test networks and dummy accounts.

## 🎯 What is Account Abstraction?

Account Abstraction (ERC-4337) allows smart contracts to act as wallets, enabling:

- **Gasless Transactions**: Users can pay gas fees with any ERC-20 token
- **Batch Operations**: Execute multiple transactions in a single operation
- **Social Recovery**: Implement custom recovery mechanisms
- **Enhanced Security**: Programmable transaction validation and execution

## 📚 Learning Credits

This project is based on educational content from **[Cyfrin Updraft](https://updraft.cyfrin.io/)**. Special thanks to the Cyfrin team for their excellent blockchain development courses.

## 🏗️ Project Structure

```
├── src/
│   ├── ethereum/           # Ethereum-compatible Account Abstraction
│   │   └── MinimalAccount.sol
│   └── zksync/            # zkSync-specific implementation
│       └── ZkMinimalAccount.sol
├── script/
│   ├── DeployMinimal.s.sol    # Deployment script
│   ├── HelperConfig.s.sol     # Network configuration
│   └── SendPackedUserOp.s.sol # UserOperation execution
├── test/
│   ├── ethereum/          # Ethereum tests
│   └── zksync/           # zkSync tests
└── lib/                  # Dependencies
```

## 🚀 Quick Start

### Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- [Node.js](https://nodejs.org/) (for zkSync)
- [Yarn](https://yarnpkg.com/) (for zkSync scripts)

### Installation

1. **Clone and setup dependencies:**

   ```bash
   git clone <repository-url>
   cd account-abstraction
   make install
   ```

2. **Build the project:**

   ```bash
   make build
   ```

3. **Run tests:**
   ```bash
   make test
   ```

## 🧪 Testing

### Ethereum Tests

```bash
# Run all Ethereum tests
forge test

# Run specific test
forge test --mt testOwnerCanExecuteCommands

# Run with verbose output
forge test -vvv
```

### zkSync Tests

```bash
# Build for zkSync
make zkbuild

# Run zkSync tests
make zktest

# Run specific zkSync test
foundryup-zksync && forge test --mt testZkOwnerCanExecuteCommands --zksync --system-mode=true && foundryup
```

## 📋 Available Commands

### General Commands

- `make install` - Install all dependencies
- `make build` - Build the project
- `make test` - Run all tests
- `make clean` - Clean build artifacts

### Ethereum Commands

- `make deployEth` - Deploy to Ethereum networks
- `make sendUserOp` - Send a UserOperation
- `make getCalldata` - Generate function calldata

### zkSync Commands

- `make zkbuild` - Build for zkSync
- `make zktest` - Run zkSync tests
- `make zkanvil` - Start zkSync local node
- `make zkdeploy` - Deploy to zkSync

## 🔧 Configuration

### Network Setup

The project supports multiple networks configured in `HelperConfig.s.sol`:

- **Local (Anvil)**: Chain ID 31337
- **Ethereum Sepolia**: Chain ID 11155111
- **zkSync Sepolia**: Chain ID 300
- **Avalanche Fuji**: Chain ID 43113

### Environment Variables

Create a `.env` file:

```env
ETHERSCAN_API_KEY=your_etherscan_api_key
MAINNET_RPC_URL=your_mainnet_rpc_url
SMALL_MONEY_SENDER=your_test_wallet_address
```

## 🏃‍♂️ Running Examples

### 1. Deploy MinimalAccount

```bash
# Deploy to Sepolia
make deployEth

# Deploy to zkSync
make zkdeploy
```

### 2. Send UserOperation

```bash
# Execute ERC-20 approval via Account Abstraction
make sendUserOp
```

### 3. Test Signature Recovery

```bash
# Test ECDSA signature validation
forge test --mt testRecoverSignedOp -vvv
```

## 🔍 Key Components

### MinimalAccount.sol

- Implements ERC-4337 IAccount interface
- Validates user operations with ECDSA signatures
- Executes transactions on behalf of users
- Supports ETH and ERC-20 interactions

### ZkMinimalAccount.sol

- zkSync-specific Account Abstraction implementation
- Handles zkSync transaction types
- Integrates with zkSync system contracts
- Supports native account abstraction features

### UserOperation Flow

1. **Create UserOperation**: Encode transaction data
2. **Sign Operation**: Generate ECDSA signature
3. **Submit to EntryPoint**: Send via bundler
4. **Validate**: Smart contract validates signature
5. **Execute**: Transaction executes on behalf of user

## 🌐 Supported Networks

### Testnet

- ✅ Ethereum Sepolia
- ✅ zkSync Sepolia
- ✅ Avalanche Fuji
- ✅ Local Anvil

### Mainnet (Demo Only)

- ⚠️ Ethereum Mainnet (use test funds only)
- ⚠️ Arbitrum (use test funds only)

## 🛡️ Security Considerations

### For Development

- Use test networks only
- Never commit private keys
- Use environment variables for sensitive data
- Test thoroughly before mainnet deployment

### Smart Contract Security

- Signature validation prevents unauthorized access
- EntryPoint contract handles gas payments
- Owner-only functions protect critical operations
- Reentrancy protection where applicable

## 🐛 Troubleshooting

### Common Issues

1. **"Stack too deep" error:**

   ```bash
   # Ensure via-ir is enabled in foundry.toml
   [profile.default]
   via-ir = true
   ```

2. **zkSync compilation errors:**

   ```bash
   # Use foundryup-zksync
   foundryup-zksync
   forge build --zksync
   foundryup
   ```

3. **Missing dependencies:**
   ```bash
   make clean
   make install
   ```

## 📖 Additional Resources

- [ERC-4337 Official Specification](https://eips.ethereum.org/EIPS/eip-4337)
- [Cyfrin Updraft Courses](https://updraft.cyfrin.io/)
- [Account Abstraction Documentation](https://docs.alchemy.com/docs/account-abstraction-overview)
- [zkSync Account Abstraction](https://docs.zksync.io/build/developer-reference/account-abstraction)

## 🤝 Contributing

This is a demo project for educational purposes. Feel free to:

- Fork and experiment
- Submit issues for bugs
- Suggest improvements
- Share your learning experience

## ⚠️ Disclaimer

This project is for educational purposes only. The code has not been audited and should not be used in production with real funds. Always use test networks and dummy accounts when experimenting with blockchain development.

---
