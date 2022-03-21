// ·--------------------------------|----------------------------|-------------|-----------------------------·
// |      Solc version: 0.8.4       ·  Optimizer enabled: false  ·  Runs: 200  ·  Block limit: 30000000 gas  │
// ·································|····························|·············|······························
// |  Methods                                                                                                │
// ···············|·················|··············|·············|·············|···············|··············
// |  Contract    ·  Method         ·  Min         ·  Max        ·  Avg        ·  # calls      ·  eur (avg)  │
// ···············|·················|··············|·············|·············|···············|··············
// |  Foundation  ·  closeProposal  ·           -  ·          -  ·      29232  ·            1  ·          -  │
// ···············|·················|··············|·············|·············|···············|··············
// |  Foundation  ·  init           ·           -  ·          -  ·     119366  ·            1  ·          -  │
// ···············|·················|··············|·············|·············|···············|··············
// |  Foundation  ·  setTime        ·           -  ·          -  ·      46195  ·            1  ·          -  │
// ···············|·················|··············|·············|·············|···············|··············
// |  Foundation  ·  votePropose    ·       54369  ·      91391  ·      73350  ·            3  ·          -  │
// ···············|·················|··············|·············|·············|···············|··············
// |  Deployments                   ·                                          ·  % of limit   ·             │
// ·································|··············|·············|·············|···············|··············
// |  Foundation                    ·           -  ·          -  ·    1219647  ·        4.1 %  ·          -  │
// ·--------------------------------|--------------|-------------|-------------|---------------|-------------·



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

    function init(string memory _name, string memory description) public {
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
        if (proposal.votesFor > proposal.votesAgainst) proposal.state = State.Accepted;
        else proposal.state = State.Rejected;
    }

    function getProposal() public view returns (Proposal memory) {
        return proposal;
    }
    function getProposalDescription() public view returns (string memory) {
        return proposal.description;
    }
    // function getProposalState() public view returns ( ) {  
    //     return proposal.state;
    // }
    function getProposalVotesFor() public view returns (uint8) {
        return proposal.votesFor;
    }
    function getProposalVotesAgainst() public view returns (uint8) {
        return proposal.votesAgainst;
    }
    function getProposalTimestamp() public view returns (uint) {
        return proposal.timestamp;
    }
}