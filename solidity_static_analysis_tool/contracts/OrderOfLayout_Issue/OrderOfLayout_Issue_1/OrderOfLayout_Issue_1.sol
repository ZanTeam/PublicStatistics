pragma solidity 0.8.10; //leak

import "./IERC721.sol";

library Test {
    function isETH(address _tokenAddress) internal pure returns (bool) {
        return
            (_tokenAddress == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE) ||
            (_tokenAddress == 0x0000000000000000000000000000000000000000);
    }
}

interface IERC20 {
    function balanceOf(address a) external returns (uint256);
}

contract Bad1 {
    //leak

    event logUint(uint256);

    uint256 _a;

    address _owner;

    modifier onlyOwner() {
        require(msg.sender == _owner, "only owner can call the function");
        _;
    }

    constructor() {
        _owner = msg.sender;
    }

    function func1(uint256 a, uint256 b) internal view returns (uint256) {
        return a + b;
    }

    function func2(address _toAddress) external onlyOwner {
        if (Test.isETH(_toAddress)) {
            _toAddress.call{value: 1}("");
        }
    }
}

contract Bad2 {
    //leak

    uint256 _a;

    address _owner;

    event logUint(uint256);

    modifier onlyOwner() {
        require(msg.sender == _owner, "only owner can call the function");
        _;
    }

    constructor() {
        _owner = msg.sender;
    }

    function func1(uint256 a, uint256 b) internal view returns (uint256) {
        return a + b;
    }

    function func2(address _toAddress) external onlyOwner {
        if (Test.isETH(_toAddress)) {
            _toAddress.call{value: 1}("");
        }
    }
}
