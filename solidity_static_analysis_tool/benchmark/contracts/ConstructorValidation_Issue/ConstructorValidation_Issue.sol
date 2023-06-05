pragma solidity ^0.4.24;

interface Test1 {
    function func1(uint amount) external pure returns (uint);
}

contract Test2 {

} //leak

contract Test3 is Test2 {
    constructor() public Test2() {}
}
