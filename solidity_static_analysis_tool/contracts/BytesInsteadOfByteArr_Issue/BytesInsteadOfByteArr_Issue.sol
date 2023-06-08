pragma solidity 0.4.26;

contract Test {
    function good1() external {
        bytes5 hh = 0x6c6abcdef8;
    }

    function bad1() external {
        byte[] hh; //leak
        hh.push(0x6c);
        hh.push(0x6a);
        hh.push(0xbc);
        hh.push(0xde);
        hh.push(0xf8);
    }
}
