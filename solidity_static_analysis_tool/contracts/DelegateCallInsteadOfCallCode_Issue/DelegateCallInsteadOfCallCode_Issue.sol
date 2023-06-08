pragma solidity ^0.4.25;

contract Test {
    function bad(address addr, uint256 a, uint256 b) external {
        addr.callcode(abi.encodeWithSignature("add(uint256,uint256)", a, b)); //leak
    }

    function good(address addr, uint256 a, uint256 b) external {
        addr.delegatecall(
            abi.encodeWithSignature("add(uint256,uint256)", a, b)
        );
    }
}

contract A {
    function add(uint256 a, uint256 b) external returns (uint256) {
        return a + b;
    }
}
