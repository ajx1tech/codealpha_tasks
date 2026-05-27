// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title PollingSystem - CodeAlpha Internship Task 3
/// @notice A decentralized on-chain polling system with time-locked voting
/// @dev Supports multiple polls, one-vote-per-address enforcement, and winner determination
contract PollingSystem {

    struct Poll {
        uint256 id;
        string title;
        string[] options;
        uint256 endTime;
        address creator;
        bool exists;
    }

    uint256 public pollCount;
    mapping(uint256 => Poll) public polls;
    mapping(uint256 => mapping(uint256 => uint256)) public voteCounts;
    mapping(uint256 => mapping(address => bool)) public hasVoted;
    mapping(uint256 => mapping(address => uint256)) public voterChoice;

    event PollCreated(uint256 indexed pollId, string title, address indexed creator, uint256 endTime);
    event VoteCast(uint256 indexed pollId, address indexed voter, uint256 optionIndex, string optionName);
    event WinnerDeclared(uint256 indexed pollId, uint256 winningOptionIndex, string winningOption, uint256 winningVoteCount);

    /// @notice Creates a new poll
    /// @param _title The question or title for the poll
    /// @param _options Array of option strings (min 2, max 10)
    /// @param _durationSeconds How long the poll should remain open (in seconds)
    function createPoll(string calldata _title, string[] calldata _options, uint256 _durationSeconds) external returns (uint256) {
        require(bytes(_title).length > 0, "PollingSystem: Title cannot be empty");
        require(_options.length >= 2, "PollingSystem: Minimum 2 options required");
        require(_options.length <= 10, "PollingSystem: Maximum 10 options allowed");
        require(_durationSeconds >= 60, "PollingSystem: Minimum duration is 60 seconds");

        uint256 newPollId = pollCount;
        uint256 endTime = block.timestamp + _durationSeconds;

        polls[newPollId] = Poll({
            id: newPollId,
            title: _title,
            options: _options,
            endTime: endTime,
            creator: msg.sender,
            exists: true
        });

        pollCount++;

        emit PollCreated(newPollId, _title, msg.sender, endTime);
        return newPollId;
    }

    /// @notice Casts a vote on an active poll
    /// @param _pollId The ID of the poll to vote on
    /// @param _optionIndex The index of the chosen option (0-based)
    function vote(uint256 _pollId, uint256 _optionIndex) external {
        Poll storage poll = polls[_pollId];

        require(poll.exists, "PollingSystem: Poll does not exist");
        require(block.timestamp < poll.endTime, "PollingSystem: Voting period has ended");
        require(!hasVoted[_pollId][msg.sender], "PollingSystem: You have already voted");
        require(_optionIndex < poll.options.length, "PollingSystem: Invalid option index");

        hasVoted[_pollId][msg.sender] = true;
        voterChoice[_pollId][msg.sender] = _optionIndex;
        voteCounts[_pollId][_optionIndex]++;

        emit VoteCast(_pollId, msg.sender, _optionIndex, poll.options[_optionIndex]);
    }

    /// @notice Returns the winning option after poll ends
    function getWinner(uint256 _pollId) external returns (uint256 winnerIndex, string memory winnerName, uint256 winnerVotes) {
        Poll storage poll = polls[_pollId];
        require(poll.exists, "PollingSystem: Poll does not exist");
        require(block.timestamp >= poll.endTime, "PollingSystem: Poll has not ended yet");

        uint256 highestVotes = 0;
        uint256 winningIndex = 0;

        for (uint256 i = 0; i < poll.options.length; i++) {
            if (voteCounts[_pollId][i] > highestVotes) {
                highestVotes = voteCounts[_pollId][i];
                winningIndex = i;
            }
        }

        emit WinnerDeclared(_pollId, winningIndex, poll.options[winningIndex], highestVotes);

        return (winningIndex, poll.options[winningIndex], highestVotes);
    }

    /// @notice Returns full details of a poll
    function getPoll(uint256 _pollId) external view returns (uint256 id, string memory title, string[] memory options, uint256 endTime, address creator, bool isActive) {
        Poll storage poll = polls[_pollId];
        require(poll.exists, "PollingSystem: Poll does not exist");

        return (
            poll.id,
            poll.title,
            poll.options,
            poll.endTime,
            poll.creator,
            block.timestamp < poll.endTime
        );
    }

    /// @notice Returns all vote counts for a given poll
    function getResults(uint256 _pollId) external view returns (string[] memory optionNames, uint256[] memory counts) {
        Poll storage poll = polls[_pollId];
        require(poll.exists, "PollingSystem: Poll does not exist");

        uint256 len = poll.options.length;
        counts = new uint256[](len);
        optionNames = poll.options;

        for (uint256 i = 0; i < len; i++) {
            counts[i] = voteCounts[_pollId][i];
        }
    }

    /// @notice Checks if a specific address has voted on a poll
    function checkIfVoted(uint256 _pollId, address _voter) external view returns (bool voted, uint256 chosenOption) {
        return (hasVoted[_pollId][_voter], voterChoice[_pollId][_voter]);
    }

    /// @notice Returns time remaining for a poll (0 if ended)
    function timeRemaining(uint256 _pollId) external view returns (uint256) {
        Poll storage poll = polls[_pollId];
        require(poll.exists, "PollingSystem: Poll does not exist");
        if (block.timestamp >= poll.endTime) return 0;
        return poll.endTime - block.timestamp;
    }
}
