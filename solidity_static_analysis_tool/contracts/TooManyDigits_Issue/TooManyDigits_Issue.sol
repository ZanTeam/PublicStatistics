pragma solidity 0.8.0;

contract Test {
    uint balance;
    address public constant addr1 = 0x00000000000076A84feF008CDAbe6409d2FE638B;

    function bad1() external {
        uint x = 100000; //leak
    }

    function bad2() external {
        uint x = 0x000001; //leak
        uint y = 0x0000000000001; //leak
    }

    function bad3() external {
        balance = 1000000000000000000; //leak
    }

    function bad4() external {
        balance = 1 wei + 10 wei + 100 wei + 1000 wei + 10000 wei + 100000 wei; //leak
    }

    function good1() external {
        balance = 1 ether;
    }

    function good2() external {
        balance = 1 wei + 10 wei + 100 wei + 1000 wei + 10000 wei + 10000 wei;
    }

    function good3() external {
        uint x = 90000;
        uint y = 10000;
        balance = x + y;
    }
}
