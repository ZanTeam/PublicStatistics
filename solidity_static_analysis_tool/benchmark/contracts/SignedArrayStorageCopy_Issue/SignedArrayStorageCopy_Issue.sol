pragma solidity 0.4.25; //0.4.7 - 0.5.9

contract Test {
    int[3] a;

    function bad1() public {
        a = [-1, -2, -3]; //leak
    }

    function bad2(int8[3] memory b) public {
        a = b; //leak
    }

    function good1() public {
        a[0] = -2;
    }
}
