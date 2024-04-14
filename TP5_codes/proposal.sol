// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/governance/Governor.sol";
import "@openzeppelin/contracts/governance/IGovernor.sol";

contract ProposalCreation {
    IGovernor public governor;
    address public target;  
    uint public value = 0; 
    string public signature = "changeParameter(uint256)"; 
    bytes public data; 

    constructor(address _governor, address _target) {
        governor = IGovernor(_governor);
        target = _target;
    }

    function prepareProposal(uint256 newValue) public returns (uint256 proposalId) {
        data = abi.encodeWithSignature(signature, newValue);

        string memory description = "Proposal to change parameter to new value.";

        address[] memory targets = new address[](1);
        uint[] memory values = new uint[](1);
        bytes[] memory calldatas = new bytes[](1);

        targets[0] = target;
        values[0] = value;
        calldatas[0] = data;

        proposalId = governor.propose(targets, values, calldatas, description);
        return proposalId;
    }
}
