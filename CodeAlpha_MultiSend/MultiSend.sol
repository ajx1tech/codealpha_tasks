// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title MultiSend - CodeAlpha Internship Task 2
/// @notice A smart contract that distributes Ether equally to multiple addresses
/// @dev Accepts an array of recipient addresses and splits incoming ETH equally
contract MultiSend {

    address public owner;
    uint256 public totalDistributed;

    event EtherDistributed(address indexed sender, uint256 totalAmount, uint256 perAddressAmount, uint256 recipientCount);
    event TransferSent(address indexed recipient, uint256 amount);
    event LeftoverReturned(address indexed to, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "MultiSend: Caller is not the owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Distributes sent Ether equally among all provided addresses
    /// @param recipients An array of Ethereum addresses to receive equal shares
    function multiSend(address[] calldata recipients) external payable {
        require(recipients.length > 0, "MultiSend: No recipients provided");
        require(msg.value > 0, "MultiSend: Must send ETH with this call");
        require(
            msg.value >= recipients.length,
            "MultiSend: Not enough ETH to distribute (min 1 wei per address)"
        );

        uint256 totalRecipients = recipients.length;
        uint256 amountPerAddress = msg.value / totalRecipients;
        uint256 remainder = msg.value % totalRecipients;

        // Validate no zero-address recipients
        for (uint256 i = 0; i < totalRecipients; i++) {
            require(
                recipients[i] != address(0),
                "MultiSend: Recipient address cannot be zero address"
            );
        }

        // State update BEFORE external transfers (Checks-Effects-Interactions pattern)
        totalDistributed += (msg.value - remainder);

        // Distribute ETH to each recipient
        for (uint256 i = 0; i < totalRecipients; i++) {
            (bool success, ) = payable(recipients[i]).call{value: amountPerAddress}("");
            require(success, "MultiSend: Transfer failed");
            emit TransferSent(recipients[i], amountPerAddress);
        }

        // Return any remainder dust to the sender
        if (remainder > 0) {
            (bool refundSuccess, ) = payable(msg.sender).call{value: remainder}("");
            require(refundSuccess, "MultiSend: Refund of remainder failed");
            emit LeftoverReturned(msg.sender, remainder);
        }

        emit EtherDistributed(msg.sender, msg.value, amountPerAddress, totalRecipients);
    }

    /// @notice Calculates the per-address share for a given total and recipient count
    function calculateShare(uint256 totalWei, uint256 recipientCount) external pure returns (uint256 perAddress, uint256 remainder) {
        require(recipientCount > 0, "MultiSend: Recipient count must be > 0");
        perAddress = totalWei / recipientCount;
        remainder = totalWei % recipientCount;
    }

    /// @notice Returns the current ETH balance of this contract
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    /// @notice Allows owner to recover any accidentally stuck ETH
    function recoverStuckETH() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "MultiSend: No ETH to recover");
        (bool success, ) = payable(owner).call{value: balance}("");
        require(success, "MultiSend: Recovery failed");
    }

    /// @notice Fallback to reject direct ETH transfers without function call
    receive() external payable {
        revert("MultiSend: Use multiSend() function to send ETH");
    }
}
