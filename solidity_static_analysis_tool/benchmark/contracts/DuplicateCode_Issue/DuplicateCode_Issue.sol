pragma solidity 0.8.0;

contract Test1 {
    address _owner;

    constructor() {
        _owner = msg.sender;
    }

    function bad1(uint256 a, uint256 b) internal view returns (uint256) {
        return a + b;
    }

    function sub(uint256 a, uint256 b) external view returns (uint256) {
        return a - b;
    }
}

contract Test2 {
    address _owner;

    constructor() {
        _owner = msg.sender;
    }

    //leak
    function bad1(uint256 a, uint256 b) internal view returns (uint256) {
        return a + b;
    }
}
