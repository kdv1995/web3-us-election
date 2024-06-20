// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract USElection {
    address public owner;

    struct Voter {
        bool voted; // if true, that person already voted
        address delegate; // person delegated to
        uint vote; // index of the voted proposal
    }
    struct Proposal {
        uint vote;
        string fullName;
        string party;
        uint age;
        string nationality;
        string education;
        bool isMarried;
    }
    mapping(address => Voter) public voters;

    Proposal[] public candidates;

    constructor(Proposal[] memory proposals) {
        for (uint i = 0; i < proposals.length; i++) {
            candidates.push(
                Proposal({
                    fullName: proposals[i].fullName,
                    vote: 0,
                    party: proposals[i].party,
                    age: proposals[i].age,
                    nationality: proposals[i].nationality,
                    education: proposals[i].education,
                    isMarried: proposals[i].isMarried
                })
            );
        }
    }

    function vote(uint proposal) public {
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "Already voted.");
        sender.voted = true;
        sender.vote = proposal;
        candidates[proposal].vote += 1;
    }

    function winningProposal() public view returns (uint winningProposal_) {
        uint winningVoteCount = 0;
        for (uint p = 0; p < candidates.length; p++) {
            if (candidates[p].vote > winningVoteCount) {
                winningVoteCount = candidates[p].vote;
                winningProposal_ = p;
            }
        }
    }

    function winnerName() public view returns (string memory winnerName_) {
        winnerName_ = candidates[winningProposal()].fullName;
    }

    function winnerParty() public view returns (string memory winnerParty_) {
        winnerParty_ = candidates[winningProposal()].party;
    }

    function winnerAge() public view returns (uint winnerAge_) {
        winnerAge_ = candidates[winningProposal()].age;
    }

    function getProposals() public view returns (Proposal[] memory) {
        return candidates;
    }

    function getProposal(uint index) public view returns (Proposal memory) {
        return candidates[index];
    }
}
