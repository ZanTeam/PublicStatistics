pragma solidity ^0.4.24;

contract BaseContract {
    uint x = 5;
    uint y = 5; //leak
}

contract ExtendedContract is BaseContract {
    uint _x = 7;

    function z() public pure {}

    event v();
}

contract FurtherExtendedContract is ExtendedContract {
    uint __x = 7; //leak

    modifier w() {
        assert(msg.sender != address(0));
        _;
    }

    function shadowingParent(uint __x) public pure {
        int y;
        uint z;
        uint w;
        uint v;
    }
}

contract ShadowingInFunctions {
    uint n = 2; //leak
    uint x = 3; //leak

    function g1() constant returns (uint n) {
        return n; // Will return 0
    }

    function g2() constant returns (uint n) {
        n = 1;
        return n; // Will return 1
    }

    function f1() constant returns (uint) {
        uint n = 4;
        uint x = 0;
        return n + x; // Will return 4
    }
}
