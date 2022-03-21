// SPDX-License-Identifier: MIT
pragma solidity >0.4.23 <0.9.0;
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
contract Foundation is Initializable {

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
/////////////////////////////////
    function initialize(string memory _name, string memory description, uint _time) initializer public {
        owner = msg.sender;
        proposal.name = _name;
        proposal.description = description;
        proposal.timestamp =  _time;
        proposal.state = State.Voting;
        proposal.votesFor = 0;
        proposal.votesAgainst = 0;
    }
    ///////////////////////////////////////
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
    function closeProposal() public onlyOwner {
        require(proposal.state == State.Voting);
        if (proposal.votesFor > proposal.votesAgainst) proposal.state = State.Accepted;
        else proposal.state = State.Rejected;
    }

/////////////////////////////////////////////////////////////////////
    function getProposal() public view returns (Proposal memory) {
        return proposal;
    }
    function getProposalDescription() public view returns (string memory) {
        return proposal.description;
    }

    function getProposalVotesFor() public view returns (uint8) {
        return proposal.votesFor;
    }
    function getProposalVotesAgainst() public view returns (uint8) {
        return proposal.votesAgainst;
    }
    function getProposalTimestamp() public view returns (uint) {
        return proposal.timestamp;
    }
    function getProposalState() public view returns (State) {
        return proposal.state;
    }
    function getProposalName() public view returns (string memory) {
        return proposal.name;
    }
}