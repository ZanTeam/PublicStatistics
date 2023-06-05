pragma solidity >=0.4.26;
pragma experimental ABIEncoderV2;

contract Test {
    struct inner {
        uint x;
    }

    struct outer {
        inner y;
    }

    mapping(uint => outer) public bad; //leak

    mapping(uint => inner) public good;
}
