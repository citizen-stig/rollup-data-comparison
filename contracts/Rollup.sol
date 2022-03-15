// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.12;


contract Rollup {

    bytes32 rootHashBytes;
    uint256 rootHashU256;

    bool something;
    // "Raw" section


    function submitBatchRaw(
        bytes32 rootHash,
        bytes calldata transactions
    ) external {
        rootHashBytes = rootHash;
    }


    // "Parsed" section
    function submitBatchPreParsed(
        uint256 rootHash,
        uint256[] calldata transactions
    ) external {
        rootHashU256 = rootHash;
    }
}
