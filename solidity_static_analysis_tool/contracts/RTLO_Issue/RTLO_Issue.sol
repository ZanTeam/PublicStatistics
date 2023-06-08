pragma solidity ^0.4.24;

contract A {
    function sum(uint a, uint b, uint c) internal pure returns (uint) {
        return a + b + c;
    }

    function bad0() public pure {
        sum(/*A‮/*B*/ 2, 1 /*‭ //leak
		        /*C */, 3);
    }

    function bad1() public {
        sum(/*A‮/*B*/ 2, 1, 3); //leak
    }

    function bad2() public returns (uint) {
        return /*A‮/*B*/ 2; //leak
    }

    //
    function good0() public pure {
        sum(2, 1 /*C */, 3);
    }

    function good1() public {
        sum(/*A*B*/ 2, 1, 3);
    }

    function good2() public returns (uint) {
        return /*A/*B*/ 2;
    }
}
