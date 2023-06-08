pragma solidity 0.8.0;

import "./ReentrancyGuard.sol";

contract Test is ReentrancyGuard {
    function _revertWithData(bytes memory data) internal pure {
        assembly {
            revert(add(data, 32), mload(data))
        }
    }

    function _returnWithData(bytes memory data) internal pure {
        assembly {
            return(add(data, 32), mload(data))
        }
    }

    function _stop(bytes memory data) internal pure {
        assembly {
            stop()
        }
    }

    function bad1(
        bool success,
        bytes calldata resultData
    ) external nonReentrant { //leak
        if (!success) {
            _revertWithData(resultData);
        }

        _returnWithData(resultData);
    }

    function bad2(
        bool success,
        bytes calldata resultData
    ) external nonReentrant { //leak
        if (!success) {
            _revertWithData(resultData);
        }

        _stop(resultData);
    }

    function bad3(bool success, bytes calldata resultData) external {
        if (!success) {
            _revertWithData(resultData);
        }

        _stop(resultData);
    }

    function bad4() external {
        delegatedFwd2(loadImplementation(), msg.data);
    }

    function good1(
        bool success,
        bytes calldata resultData
    ) external nonReentrant {
        if (!success) {
            _revertWithData(resultData);
        }
    }

    function good2(
        bool success,
        bytes calldata resultData
    ) external nonReentrant returns (bytes memory) {
        if (success) {
            return resultData;
        }
    }

    function good3(
        bool success,
        bytes calldata resultData
    ) external nonReentrant {
        if (!success) {
            revert(string(resultData));
        }
    }

    function loadImplementation() internal view returns (address) {
        address _impl;
        bytes32 position = keccak256("qom.network.proxy.implementation");
        assembly {
            _impl := sload(position)
        }
        return _impl;
    }

    function delegatedFwd1(address _dst, bytes memory _calldata) internal {
        assembly {
            let result := delegatecall(
                sub(gas(), 10000),
                _dst,
                add(_calldata, 0x20),
                mload(_calldata),
                0,
                0
            )
            let size := returndatasize()

            let ptr := mload(0x40)
            returndatacopy(ptr, 0, size)

            switch result
            case 0 {
                revert(ptr, size)
            }
            default {
                return(ptr, size)
            }
        }
    }

    function delegatedFwd2(address _dst, bytes memory _calldata) internal {
        assembly {
            let result := delegatecall(
                sub(gas(), 10000),
                _dst,
                add(_calldata, 0x20),
                mload(_calldata),
                0,
                0
            )
            let size := returndatasize()

            let ptr := mload(0x40)
            returndatacopy(ptr, 0, size)

            if eq(result, 0) {
                return(ptr, size)
            }
        }
    }

    fallback() external payable {
        delegatedFwd1(loadImplementation(), msg.data);
    }
}
