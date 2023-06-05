pragma solidity ^0.8.0;

contract Test {
    string str1;

    function setValue(string para) public {
        str1 = para;
    }

    function getValue() public constant returns (string) {
        return str1;
    }
}
