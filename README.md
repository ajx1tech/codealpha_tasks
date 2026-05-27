# codealpha_tasks

# CodeAlpha Blockchain Internship Tasks

This repository contains the smart contract projects developed during the **Blockchain Development Internship** at **CodeAlpha**. The internship focuses on building decentralized applications (DApps), writing secure smart contracts, and understanding core Ethereum mechanics.

Each task is contained within its own directory, complete with the Solidity source code and a detailed README explaining its specific features, deployment steps, and test cases.

## 📂 Repository Structure

```text
codealpha_tasks/
├── CodeAlpha_SimpleStorage/   # Task 1
├── CodeAlpha_MultiSend/       # Task 2
├── CodeAlpha_PollingSystem/   # Task 3
└── CodeAlpha_CryptoLocking/   # Task 4

🚀 Projects Overview
Task 1: Simple Storage Smart Contract
A foundational smart contract demonstrating state variable management on the Ethereum blockchain. It includes basic arithmetic operations (increment/decrement with underflow protection), custom value setting, and event emission for state changes.

Task 2: Multi-Send Smart Contract
A gas-optimized contract designed to accept Ether and distribute it equally across an array of recipient addresses in a single transaction. It features automatic remainder refunds, zero-address validation, and strictly implements the Checks-Effects-Interactions (CEI) security pattern.

Task 3: Polling System Smart Contract
A fully decentralized, trustless voting system. Users can deploy polls with custom durations and options. The contract enforces a one-vote-per-address limit, uses block.timestamp for secure voting windows, and automatically tallies the winning option once the deadline passes.

Task 4: Crypto Locking (Portfolio) Smart Contract
A personal time-locked Ethereum vault. Users can deposit ETH with a custom time lock. Withdrawals are algorithmically blocked until the block.timestamp exceeds the user's unlock time. Includes reentrancy protection and strict fallback prevention.

🛠️ Tech Stack
Language: Solidity ^0.8.0

Environment: Remix IDE

Network: Ethereum (Sepolia Testnet)

Blockchain Internship - CodeAlpha
Author: Ajit Sharma.
