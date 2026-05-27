// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title SimpleStorage - CodeAlpha Internship Task 1
/// @notice A simple smart contract to store, increment and decrement an integer value
contract SimpleStorage {

    uint256 public storedValue;

    event ValueIncremented(uint256 newValue, address indexed by);
    event ValueDecremented(uint256 newValue, address indexed by);
    event ValueSet(uint256 newValue, address indexed by);

    constructor() {
        storedValue = 0;
    }

    /// @notice Increments the stored value by 1
    function increment() external {
        storedValue += 1;
        emit ValueIncremented(storedValue, msg.sender);
    }

    /// @notice Decrements the stored value by 1
    /// @dev Reverts if storedValue is already 0 to prevent underflow
    function decrement() external {
        require(storedValue > 0, "SimpleStorage: Value cannot go below zero");
        storedValue -= 1;
        emit ValueDecremented(storedValue, msg.sender);
    }

    /// @notice Sets the stored value to a specific number
    function setValue(uint256 _value) external {
        storedValue = _value;
        emit ValueSet(storedValue, msg.sender);
    }

    /// @notice Returns the current stored value
    function getValue() external view returns (uint256) {
        return storedValue;
    }

    /// @notice Resets the stored value to 0
    function reset() external {
        storedValue = 0;
        emit ValueSet(0, msg.sender);
    }
}
