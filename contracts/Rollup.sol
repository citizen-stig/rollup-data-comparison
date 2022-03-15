// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.12;

contract Rollup {

    bytes32 rootHashBytes;
    uint256 rootHashU256;

    bool something;
    // "Raw" section

    event Done(uint256 rootHash, bool result);

    function submitBatchRaw(
        bytes32 rootHash,
        bytes calldata
    ) external {
        rootHashBytes = rootHash;
        uint256[] memory parsed = parseRawTransactions();

        bool result = processParsed(parsed);

        emit Done(uint256(rootHash), result);
    }

    function parseRawTransactions() internal pure returns (uint256[] memory parsed) {

        uint offset = 100;
        bytes memory temp = new bytes(32);
        copyFromCallData(temp, offset);

        (uint16 transactionsCount, uint256 bytesRead) = readU16(temp, 0);
        offset += bytesRead;

        parsed = new uint256[](transactionsCount);

        uint16 element;
        for (uint16 i = 0; i < transactionsCount; i++) {
            copyFromCallData(temp, offset);
            (element, bytesRead) = readU16(temp, 0);
            offset += bytesRead;
            parsed[i] = uint256(element);
        }

        return parsed;
    }

    function copyFromCallData(bytes memory temp, uint256 _offset) internal pure {
        assembly {
            calldatacopy(add(temp, 32), _offset, 0x2)
        }
    }

    function readU16(bytes memory _bytes, uint256 _offset)
    internal
    pure
    returns (uint16, uint256)
    {
        require(_bytes.length >= _offset + 2, "slicing out of range");
        uint16 x;
        assembly {
            x := mload(add(_bytes, add(0x2, _offset)))
        }
        return (x, _offset + 2);
    }

    function processParsed(uint256[] memory transactions) internal pure returns (bool) {
        uint256 counter = 0;
        bool result = false;
        for (uint i = 0; i < transactions.length; i++) {
            if (transactions[i] % 2 == 0) {
                counter += 1;
            }
        }
        if (counter % 2 == 0) {
            result = true;
        }
        return result;
    }


    // "Parsed" section
    function submitBatchPreParsed(
        uint256 rootHash,
        uint256[] calldata transactions
    ) external {
        rootHashU256 = rootHash;
        bool result = processCallData(transactions);

        emit Done(rootHash, result);
    }

    function processCallData(uint256[] calldata transactions) internal pure returns (bool) {
        uint256 counter = 0;
        bool result = false;
        for (uint i = 0; i < transactions.length; i++) {
            if (transactions[i] % 2 == 0) {
                counter += 1;
            }
        }
        if (counter % 2 == 0) {
            result = true;
        }
        return result;
    }
}
