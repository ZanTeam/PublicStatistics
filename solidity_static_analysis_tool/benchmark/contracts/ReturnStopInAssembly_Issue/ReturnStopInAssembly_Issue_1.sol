// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

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

    function bad3(bool success, bytes calldata resultData) external { //leak
        if (!success) {
            _revertWithData(resultData);
        }

        _stop(resultData);
    }

    function good1(
        bool success,
        bytes calldata resultData
    ) external nonReentrant {
        if (!success) {
            _revertWithData(resultData);
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

    function delegatedFwd(address _dst, bytes memory _calldata) internal {
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

    fallback() external payable { //leak
        delegatedFwd(loadImplementation(), msg.data);
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

            if eq(result, 0) {
                return(ptr, size)
            }
        }
    }

    function bad3() external { //leak
        delegatedFwd1(loadImplementation(), msg.data);
    }
}
