pragma solidity ^0.8.0;

abstract contract ReentrancyGuard {
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    modifier nonReentrant() {
        require(_status != _ENTERED, "reentrant call");

        _status = _ENTERED;

        _;

        _status = _NOT_ENTERED;
    }
}

contract Test is ReentrancyGuard {
    constructor() {}

    function called1(
        address payable recipient,
        uint256 num
    ) public nonReentrant {
        recipient.call{value: num}("");
    }

    function bad1(
        address payable[] memory recipients,
        uint256[] memory num
    ) external nonReentrant {
        require(num.length == recipients.length, "inconsistent length");
        for (uint i; i < recipients.length; i++) {
            called1(recipients[i], num[i]); //leak
        }
    }

    function called2(address payable recipient, uint256 num) internal {
        recipient.call{value: num}("");
    }

    function good(
        address payable[] memory recipients,
        uint256[] memory num
    ) external nonReentrant {
        require(num.length == recipients.length, "inconsistent length");
        for (uint i; i < recipients.length; i++) {
            called2(recipients[i], num[i]);
        }
    }

    function called4(
        address payable recipient,
        uint256 num
    ) public nonReentrant {
        recipient.call{value: num}("");
    }

    function called3(address payable recipient, uint256 num) public {
        called4(recipient, num); //leak
    }

    function bad2(
        address payable[] memory recipients,
        uint256[] memory num
    ) external nonReentrant {
        require(num.length == recipients.length, "inconsistent length");
        for (uint i; i < recipients.length; i++) {
            called3(recipients[i], num[i]);
        }
    }
}
