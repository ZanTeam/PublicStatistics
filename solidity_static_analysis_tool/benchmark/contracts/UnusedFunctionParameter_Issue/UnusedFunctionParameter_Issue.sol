pragma solidity ^0.4.10;
pragma experimental ABIEncoderV2;

contract Test {
    string myStr;

    struct Person {
        string name;
        uint age;
    }

    function bad1(string str1, int test) public { //leak
        myStr = str1;
    }

    function bad2(uint a, int b) external pure { //leak
        uint num = a;
    }

    function bad3(uint a, uint b, Person p) external { //leak
        uint num = a + b;
    }

    function good1(uint a) external pure returns (uint) {
        return a;
    }

    function good2(Person p) external pure {
        uint num = p.age;
    }
}
