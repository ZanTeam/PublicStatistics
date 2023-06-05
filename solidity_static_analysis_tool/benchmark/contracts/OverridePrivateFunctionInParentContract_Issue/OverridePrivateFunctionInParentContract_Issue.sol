pragma solidity 0.5.0;

contract A {
    function bad1(uint a) private returns (uint) {
        return a + 10;
    }
}

contract B is A {
    function bad1(uint a) private returns (uint) { //leak
        return a + 1;
    }
}
