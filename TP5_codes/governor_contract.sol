// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/governance/Governor.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorTimelockControl.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/governance/TimelockController.sol";

contract MyGovernor is Governor, GovernorCountingSimple, GovernorVotes, GovernorTimelockControl {
    constructor(ERC20Votes _token, TimelockController _timelock)
        Governor("MyGovernor")
        GovernorVotes(_token)
        GovernorTimelockControl(_timelock)
    {}

    // The following functions are overrides required by Solidity.

    function proposalThreshold() public view override returns (uint256) {
        return 1000 * 10 ** 18; // 1000 tokens required to create a proposal.
    }

    function votingDelay() public view override returns (uint256) {
        return 1; // 1 block delay before voting starts on a proposal.
    }

    function votingPeriod() public view override returns (uint256) {
        return 45818; // ~1 week in blocks (assuming 15 second blocks)
    }

    function quorum(uint256 blockNumber) public view override returns (uint256) {
        return 100 * 10 ** 18; // 100 tokens required 
    }


    

    function _execute(uint256 proposalId, address target, uint256 value, bytes memory data, bytes32 predecessor, bytes32 salt)
        internal
        override(Governor, GovernorTimelockControl)
    {
        super._execute(proposalId, target, value, data, predecessor, salt);
    }

    function _cancel(address target, uint256 value, bytes memory data, bytes32 predecessor, bytes32 salt)
        internal
        override(Governor, GovernorTimelockControl)
        returns (uint256)
    {
        return super._cancel(target, value, data, predecessor, salt);
    }

    function _executor() internal view override returns (address) {
        return address(this);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(Governor, GovernorCountingSimple, GovernorVotes, GovernorTimelockControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
