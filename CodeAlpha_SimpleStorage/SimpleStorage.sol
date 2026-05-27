// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title SimpleStorage - CodeAlpha Internship Task 1
/// @author Your Name
/// @notice A simple smart contract to store, increment and decrement an integer value
/// @dev Demonstrates basic Solidity state variable management and functions

contract SimpleStorage {

    // -------------------------------------------------------
    // State Variables
    // -------------------------------------------------------

    /// @notice The stored integer value (publicly readable)
    uint256 public storedValue;

    /// @notice The address of the contract owner
    address public owner;

    // -------------------------------------------------------
    // Events
    // -------------------------------------------------------

    /// @notice Emitted when the value is incremented
    event ValueIncremented(uint256 newValue, address indexed by);

    /// @notice Emitted when the value is decremented
    event ValueDecremented(uint256 newValue, address indexed by);

    /// @notice Emitted when the value is manually set
    event ValueSet(uint256 newValue, address indexed by);

    // -------------------------------------------------------
    // Constructor
    // -------------------------------------------------------

    /// @notice Initializes the contract with a starting value of 0
    constructor() {
        storedValue = 0;
        owner = msg.sender;
    }

    // -------------------------------------------------------
    // Core Functions
    // -------------------------------------------------------

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
    /// @param _value The new value to store
    function setValue(uint256 _value) external {
        storedValue = _value;
        emit ValueSet(storedValue, msg.sender);
    }

    /// @notice Returns the current stored value
    /// @return The current value of storedValue
    function getValue() external view returns (uint256) {
        return storedValue;
    }

    /// @notice Resets the stored value to 0
    function reset() external {
        storedValue = 0;
        emit ValueSet(0, msg.sender);
    }
}
