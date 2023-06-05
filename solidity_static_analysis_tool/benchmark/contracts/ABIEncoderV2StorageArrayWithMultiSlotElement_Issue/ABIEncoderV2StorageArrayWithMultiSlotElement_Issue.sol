pragma solidity 0.4.25; //0.4.16 - 0.5.10
pragma experimental ABIEncoderV2;

interface A {
    function test(uint[2][] x) external;
}

contract Test {
    uint[2][] a = [[1, 2], [3, 4], [5, 6]];

    event log(uint[2][] x);

    function bad1(address x) public {
        A(x).test(a); //leak
    }

    function bad2() public {
        bytes memory b = abi.encode(a); //leak
    }

    function bad3() public {
        emit log(a); //leak
    }

    function good1(address x) public {
        uint[2][] memory b = a;
        emit log(b);
    }
}
