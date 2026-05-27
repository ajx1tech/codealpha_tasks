# Multi-Send Smart Contract

A Solidity smart contract designed to accept Ether and distribute it equally to multiple Ethereum addresses in a single transaction, optimizing gas usage and simplifying bulk payments. Developed as Task 2 for the CodeAlpha Blockchain Internship.

## Features
- Batch ETH transfers to multiple addresses simultaneously.
- Equal distribution logic with automatic remainder refunds to the sender.
- Zero-address validation for all recipients to prevent lost funds.
- `calculateShare()` preview function for pre-flight split checks.
- Owner-only emergency recovery function.
- Implements the **Checks-Effects-Interactions (CEI)** pattern for secure state management and reentrancy protection.

## Tech Stack
- **Language:** Solidity ^0.8.0
- **Environment:** Remix IDE / Ethereum (Sepolia Testnet)

## Deployment & Testing

1. Open [Remix IDE](https://remix.ethereum.org).
2. Create a new file named `MultiSend.sol` and paste the contract code.
3. Navigate to the **Solidity Compiler** tab, select version `0.8.0`, and compile.
4. Navigate to the **Deploy & Run Transactions** tab and select Environment: `Remix VM (Cancun)`.
5. Deploy the contract.
6. **To Test Distribution:**
   - In the Deploy panel, set the **VALUE** field to `30000000000000000` Wei (which equals 0.03 ETH).
   - Expand the `multiSend` function input.
   - Pass an array of 3 valid Remix test addresses, formatted exactly like this:
     `["0x5B38Da6a701c568545dCfcB03FcB875f56beddC4", "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2", "0x4B20993Bc481177ec7E8f571ceC841f6A746CE6A"]`
   - Click **transact**. Each address will receive exactly 0.01 ETH.

## Test Cases

| Scenario | Recipients | ETH Sent | Per Address | Expected Result |
|----------|-----------|---------|-------------|-----------------|
| 3 equal recipients | 3 | 0.03 ETH | 0.01 ETH | Success |
| 5 recipients | 5 | 0.05 ETH | 0.01 ETH | Success |
| Remainder check | 3 | 0.01 ETH | ~0.0033 ETH | Success (+ remainder refunded) |
| Zero address | Includes 0x0 | Any | N/A | Transaction Reverts |
| No ETH sent | 3 | 0 ETH | N/A | Transaction Reverts |

## Contract Functions
- `multiSend(address[])` — Main payable distribution function.
- `calculateShare(uint256, uint256)` — Previews the split amount before sending.
- `getContractBalance()` — Checks the current ETH balance of the contract.
- `recoverStuckETH()` — Owner-only emergency recovery for trapped funds.

## License
MIT License
