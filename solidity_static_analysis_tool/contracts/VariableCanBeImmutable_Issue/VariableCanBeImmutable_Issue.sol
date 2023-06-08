pragma solidity 0.6.5;

contract Test {
    uint decimal;
    uint totalSupply; //leak
    address immutable proxy;
    address owner; //leak
    bytes32 immutable name;
    string a;

    constructor(uint decimals_, address proxy_) public {
        decimal = decimals_;
        owner = msg.sender;
        proxy = proxy_;
        name = keccak256("abc");
        a = "token";
        totalSupply = 10000;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner.");
        _;
    }

    function setDecimal(uint decimals_) external onlyOwner {
        decimal = decimals_;
    }
}

abstract contract ReentrancyGuard {
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() public {
        _status = _NOT_ENTERED;
    }

    modifier nonReentrant() {
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
        _status = _ENTERED;
        _;
        _status = _NOT_ENTERED;
    }
}
