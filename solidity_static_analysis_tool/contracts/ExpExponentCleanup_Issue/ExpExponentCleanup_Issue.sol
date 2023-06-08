pragma solidity ^0.4.19;

contract Test {
    function good0(uint base, uint exp) public payable returns (uint) {
        uint res = base ** exp;
        return res;
    }

    function bad0(uint8 base, uint16 exp) public payable returns (uint) {
        uint res = base ** exp; //leak
        return res;
    }

    function good1(uint8 base, uint16 exp) public payable returns (uint) {
        uint res = base ** 2;
        return res;
    }

    function good2(uint16 base, uint16 exp) public payable returns (int) {
        int res = base ** exp;
        return res;
    }
}
