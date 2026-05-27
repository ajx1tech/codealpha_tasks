# Crypto Locking Smart Contract

A personal time-locked Ethereum vault smart contract. Users can deposit Ether with a custom lock duration, and withdrawals are strictly enforced on-chain using `block.timestamp`. Early withdrawals are algorithmically blocked until the specified time expires. Developed as Task 4 for the CodeAlpha Blockchain Internship.

## Features
- Deposit any amount of ETH with a custom, user-defined lock duration (minimum 60 seconds).
- Enforced on-chain time-lock utilizing Solidity's `block.timestamp`.
- Immutable early withdrawal prevention.
- Ability to extend an active lock duration at any time.
- Status query functionality to check deposited amount, unlock timestamp, and remaining seconds.
- `canWithdraw()` helper function to instantly verify eligibility.

## Security Implementations
- **Reentrancy Protection:** State variables are cleared *before* the ETH transfer is executed, strictly adhering to the **Checks-Effects-Interactions (CEI)** pattern.
- **Fallback Prevention:** The `receive()` fallback function explicitly rejects accidental direct ETH transfers.
- **State Validation:** Prevents double deposits if an active lock already exists to avoid overwriting state.

## Tech Stack
- **Language:** Solidity ^0.8.0
- **Environment:** Remix IDE / Ethereum (Sepolia Testnet)

## Deployment & Testing

1. Open [Remix IDE](https://remix.ethereum.org).
2. Create a new file named `CryptoLocking.sol` and paste the contract code.
3. Navigate to the **Solidity Compiler** tab, select version `0.8.0`, and compile.
4. Navigate to the **Deploy & Run Transactions** tab and select Environment: `Remix VM (Cancun)`.
5. Deploy the contract.
6. **To Test Time-Locking:**
   - In the Deploy panel, set the **VALUE** field to `10000000000000000` Wei (which equals 0.01 ETH).
   - Call `deposit(120)` to lock the funds for 120 seconds (2 minutes).
   - Immediately try calling `withdraw()`. The transaction will revert.
   - Check your status by calling `getDepositInfo` with your active address.
   - Wait for 2 minutes to pass, then call `withdraw()` again. The ETH will be successfully returned to your wallet.

## Test Cases

| Action | Expected Result |
|--------|-----------------|
| Deposit 0 ETH | Transaction Reverts |
| Deposit with < 60s lock duration | Transaction Reverts |
| Attempt to withdraw before unlock time | Transaction Reverts |
| Withdraw after unlock time | Success (ETH returned) |
| Attempt double deposit (active lock exists) | Transaction Reverts |
| Extend lock duration | Success (Unlock time updated) |
| Send ETH directly to contract address | Transaction Reverts |

## License
MIT License
