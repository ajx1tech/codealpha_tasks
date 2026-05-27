// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title CryptoLocking - CodeAlpha Internship Task 4
/// @notice A time-locked ETH vault — users deposit ETH with a lock period, and can only withdraw after the lock expires.
/// @dev Uses block.timestamp for time enforcement and per-user mappings
contract CryptoLocking {

    struct Deposit {
        uint256 amount;       // ETH locked in wei
        uint256 unlockTime;   // UNIX timestamp when withdrawal is allowed
        bool exists;          // Whether a deposit record exists
    }

    address public owner;
    mapping(address => Deposit) public deposits;
    uint256 public totalLocked;

    event Deposited(address indexed user, uint256 amount, uint256 unlockTime);
    event Withdrawn(address indexed user, uint256 amount, uint256 withdrawnAt);
    event LockExtended(address indexed user, uint256 newUnlockTime);

    modifier onlyOwner() {
        require(msg.sender == owner, "CryptoLocking: Not the owner");
        _;
    }

    modifier hasDeposit() {
        require(
            deposits[msg.sender].exists && deposits[msg.sender].amount > 0,
            "CryptoLocking: No active deposit found"
        );
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Deposits ETH with a time lock
    /// @param _lockDurationSeconds Number of seconds to lock the ETH
    /// @dev A user can only have ONE active deposit at a time
    function deposit(uint256 _lockDurationSeconds) external payable {
        require(msg.value > 0, "CryptoLocking: Must deposit more than 0 ETH");
        require(_lockDurationSeconds >= 60, "CryptoLocking: Minimum lock duration is 60 seconds");
        require(
            !deposits[msg.sender].exists || deposits[msg.sender].amount == 0,
            "CryptoLocking: You already have an active deposit. Withdraw first."
        );

        uint256 unlockTime = block.timestamp + _lockDurationSeconds;

        deposits[msg.sender] = Deposit({
            amount: msg.value,
            unlockTime: unlockTime,
            exists: true
        });

        totalLocked += msg.value;

        emit Deposited(msg.sender, msg.value, unlockTime);
    }

    /// @notice Withdraws ETH after the lock period has expired
    /// @dev Enforces time-lock with block.timestamp comparison and includes reentrancy protection
    function withdraw() external hasDeposit {
        Deposit storage userDeposit = deposits[msg.sender];

        require(block.timestamp >= userDeposit.unlockTime, "CryptoLocking: Funds are still locked");

        uint256 amountToWithdraw = userDeposit.amount;

        // Clear the deposit BEFORE transfer (Checks-Effects-Interactions pattern)
        userDeposit.amount = 0;
        userDeposit.exists = false;
        totalLocked -= amountToWithdraw;

        (bool success, ) = payable(msg.sender).call{value: amountToWithdraw}("");
        require(success, "CryptoLocking: Withdrawal transfer failed");

        emit Withdrawn(msg.sender, amountToWithdraw, block.timestamp);
    }

    /// @notice Extends the lock period for an existing deposit
    /// @param _additionalSeconds Extra seconds to add to the current unlock time
    function extendLock(uint256 _additionalSeconds) external hasDeposit {
        require(_additionalSeconds > 0, "CryptoLocking: Must add at least 1 second");

        deposits[msg.sender].unlockTime += _additionalSeconds;

        emit LockExtended(msg.sender, deposits[msg.sender].unlockTime);
    }

    /// @notice Returns deposit info for a user
    function getDepositInfo(address _user) external view returns (uint256 amount, uint256 unlockTime, bool isLocked, uint256 secondsRemaining) {
        Deposit storage d = deposits[_user];
        bool locked = d.exists && block.timestamp < d.unlockTime;
        uint256 remaining = locked ? d.unlockTime - block.timestamp : 0;
        return (d.amount, d.unlockTime, locked, remaining);
    }

    /// @notice Checks if the caller can withdraw right now
    function canWithdraw() external view returns (bool) {
        Deposit storage d = deposits[msg.sender];
        return d.exists && d.amount > 0 && block.timestamp >= d.unlockTime;
    }

    /// @notice Returns the ETH balance of the contract
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    /// @notice Fallback to reject direct ETH transfers without function call
    receive() external payable {
        revert("CryptoLocking: Use deposit() function");
    }
}
