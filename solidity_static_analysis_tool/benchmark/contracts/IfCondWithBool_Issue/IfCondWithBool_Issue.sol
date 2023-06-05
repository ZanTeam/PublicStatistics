pragma solidity ^0.4.25;

contract A {
    uint x;
    bool y;

    function bad0() public {
        if (y == true) { //leak
            x = 1;
        }
    }

    function bad1() public {
        if (true) { //leak
            x = 2;
        }
    }

    function bad2() public {
        if (y || false) { //leak
            x = 3;
        }
    }

    function bad3(bool b) public returns (bool) {
        return (b == true); //leak
    }

    function bad4(bool a) public returns (bool) {
        uint256 b = 0;
        while (a && true) { //leak
            b++;
        }
        return true;
    }

    function good0(bool foo) public returns (bool) {
        if (foo) {
            return true;
        }
        return false;
    }

    function good1(bool x, uint8 y) public returns (bool) {
        while (x == (y > 0)) {
            return true;
        }
        return false;
    }

    function good2() public returns (bool) {
        return true;
    }
}
