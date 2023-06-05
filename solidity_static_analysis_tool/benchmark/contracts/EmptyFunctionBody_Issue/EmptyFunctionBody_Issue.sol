pragma solidity ^0.8.0;

interface Test1 {
    function good() external returns (uint);
}

contract Test2 {
    constructor() {}

    function bad() external returns (uint256) {
        //leak
    }
}

library Test3 {
    function bad() external returns (uint256) {
        //leak
    }
}
