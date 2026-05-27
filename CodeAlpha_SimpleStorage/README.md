# Simple Storage Smart Contract

A Solidity smart contract demonstrating state variable management with basic arithmetic and read/write functionality on the Ethereum blockchain. Developed as Task 1 for the CodeAlpha Blockchain Internship.

## Features
- Store and manage an integer value on-chain.
- Increment and decrement functionality (with underflow protection).
- Set custom values and reset to zero.
- Public visibility for current state reading.
- Event emission for complete state change tracking.

## Tech Stack
- **Language:** Solidity ^0.8.0
- **Environment:** Remix IDE / Ethereum (Sepolia Testnet)

## Deployment & Testing

1. Open [Remix IDE](https://remix.ethereum.org).
2. Create a new file named `SimpleStorage.sol` and paste the contract code.
3. Navigate to the **Solidity Compiler** tab, select version `0.8.0`, and compile.
4. Navigate to the **Deploy & Run Transactions** tab.
5. Select Environment: `Remix VM (Cancun)`.
6. Click **Deploy** and interact with the contract functions.

## Test Cases

| Function | Input | Expected Result |
|----------|-------|----------------|
| `getValue()` | None | `0` (initial state) |
| `increment()` | None | `storedValue = 1` |
| `decrement()` | None | `storedValue = 0` |
| `decrement()` (at 0) | None | Transaction reverts |
| `setValue(42)` | `42` | `storedValue = 42` |
| `reset()` | None | `storedValue = 0` |

## License
MIT License
