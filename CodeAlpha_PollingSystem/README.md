# Polling System Smart Contract

A fully decentralized on-chain polling system built in Solidity. Users can create polls with custom options and deadlines, cast votes securely, and retrieve the winning option after the poll ends—all without relying on a central authority. Developed as Task 3 for the CodeAlpha Blockchain Internship.

## Features
- Create polls with custom titles, dynamic options (2–10), and strict time durations.
- Enforce one-vote-per-address limits to prevent double voting.
- Time-based voting lock mechanism utilizing `block.timestamp`.
- Live vote count tracking mapped per option.
- Automatic and secure winner determination after the polling period concludes.
- Full result query capabilities, returning both option names and vote counts.
- Time remaining query helper function.

## Tech Stack
- **Language:** Solidity ^0.8.0
- **Environment:** Remix IDE / Ethereum (Sepolia Testnet)

## Deployment & Testing

1. Open [Remix IDE](https://remix.ethereum.org).
2. Create a new file named `PollingSystem.sol` and paste the contract code.
3. Navigate to the **Solidity Compiler** tab, select version `0.8.0`, and compile.
4. Navigate to the **Deploy & Run Transactions** tab and select Environment: `Remix VM (Cancun)`.
5. Deploy the contract.
6. **To Test Polling:**
   - Create a poll by expanding `createPoll` and passing the following parameters (300 seconds = 5 minutes):
     `"Best Programming Language?", ["Solidity","Python","JavaScript"], 300`
   - Switch to a different account in Remix (Account 1). Vote for Solidity by calling:
     `vote(0, 0)`
   - Switch to another account (Account 2). Vote for Python by calling:
     `vote(0, 1)`
   - Attempt to vote again with Account 1. The transaction will revert.
   - Check current results by calling `getResults(0)`.
   - Wait for the 5-minute duration to pass, then call `getWinner(0)` to retrieve the winning option.

## Test Cases

| Action | Expected Result |
|--------|---------|
| Create poll with 1 option | Transaction Reverts |
| Vote before deadline | Success |
| Vote after deadline | Transaction Reverts |
| Vote twice from same address | Transaction Reverts |
| Get winner before poll ends | Transaction Reverts |
| Get winner after poll ends | Returns Winner Index, Name, and Votes |

## License
MIT License
