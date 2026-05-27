# 🔷 Simple Storage Smart Contract — CodeAlpha Task 1

A beginner-friendly Solidity smart contract that demonstrates state variable 
management with increment, decrement, set, and read functionality on the Ethereum blockchain.

## 📋 Features
- Store an integer value on-chain
- Increment the value by 1
- Decrement the value by 1 (with underflow protection)
- Set any custom value
- Read the current value (public visibility)
- Reset the value to zero
- Emits events for every state change

## 🛠️ Tech Stack
- Solidity ^0.8.0
- Remix IDE
- Ethereum (Sepolia Testnet)

## 🚀 Deployment Steps

### Using Remix IDE
1. Open [https://remix.ethereum.org](https://remix.ethereum.org)
2. Create a new file: `SimpleStorage.sol`
3. Paste the contract code
4. Go to **Solidity Compiler** tab → Select version `0.8.0` → Click **Compile**
5. Go to **Deploy & Run Transactions** tab
6. Select Environment: `Remix VM (Cancun)` for local testing
7. Click **Deploy**
8. Test all functions in the deployed contract panel

## 🧪 Test Cases
| Function | Input | Expected Result |
|----------|-------|----------------|
| `getValue()` | — | `0` (initial) |
| `increment()` | — | `storedValue = 1` |
| `increment()` | — | `storedValue = 2` |
| `decrement()` | — | `storedValue = 1` |
| `setValue(10)` | `10` | `storedValue = 10` |
| `reset()` | — | `storedValue = 0` |
| `decrement()` at 0 | — | ❌ Reverts with error |

## 📸 Contract Functions
- `increment()` — Adds 1 to stored value
- `decrement()` — Subtracts 1 (reverts at 0)
- `setValue(uint256)` — Sets a specific value
- `getValue()` — Returns current value
- `reset()` — Resets to 0

## 📄 License
MIT License — CodeAlpha Internship 2026
