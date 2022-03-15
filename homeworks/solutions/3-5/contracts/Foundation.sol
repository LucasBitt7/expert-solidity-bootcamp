// SPDX-License-Identifier: MIT
pragma solidity >0.4.23 <0.9.0;

contract Foundation {
    string public name;
    address public owner;

    mapping(address => bool) public vote;
    mapping(address => bool) internal hasVoted;

    enum State {
        Voting,
        Accepted,
        Rejected
    }
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    struct Proposal {
        string name;
        string description;
        State state;
        uint8 votesFor;
        uint8 votesAgainst;
        uint timestamp;
    }
    Proposal  proposal;

    function init(string memory _name, string memory description) public onlyOwner {
        require(bytes(name).length == 0); // ensure not init'd already.
        require(bytes(_name).length > 0);

        name = _name;
        owner = msg.sender;
          proposal = Proposal({
            name: _name,
            description: description,
            state: State.Voting,
            votesFor: 0,
            votesAgainst: 0,
            timestamp: 0
        });
    }

    function setOwner(address _newOwner) public onlyOwner {
        owner = _newOwner;
    }

    function votePropose(bool _vote) public {
        require(hasVoted[msg.sender] == false);
        require(proposal.state == State.Voting);
        require(block.timestamp < proposal.timestamp); //  86400 = 1 day
        vote[msg.sender] = _vote;
        hasVoted[msg.sender] = true;
        if (_vote == true) {
            proposal.votesFor++;
        } else {
            proposal.votesAgainst++;
        }
    }

    function setTime(uint _time) public onlyOwner {
        require(_time > 0);
        proposal.timestamp = block.timestamp + _time;
    }

    function closeProposal() public onlyOwner {
        require(proposal.state == State.Voting);
        require(proposal.votesFor > proposal.votesAgainst);
        require(block.timestamp > proposal.timestamp);
        proposal.state = State.Accepted;
    }

}