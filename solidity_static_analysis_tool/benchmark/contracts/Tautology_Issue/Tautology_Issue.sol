pragma solidity ^0.8.2;
pragma experimental ABIEncoderV2;

contract Test {
    function good1(uint a) public {
        if (a > 0) {}
    }

    function bad1(uint a) public {
        if (a >= 0) {} //leak
    }

    function good2(uint a) public {
        require(a > 0);
    }

    function bad2(uint a) public {
        require(a >= 0); //leak
    }

    function bad3(uint a) public {
        require(a < 0); //leak
    }

    function good3() public {
        for (uint i = 0; i > 0; i++) {}
    }

    function bad4() public {
        for (uint i = 0; i >= 0; i++) {} //leak
    }

    function bad5() public {
        for (uint8 i = 0; i <= 256; i++) {} //leak
    }
}
