pragma solidity ^0.8.0;

contract Bad {
    uint public constant X = 32 ** 22 + 8; //leak
    string public constant TEXT = "abc"; //leak
    bytes32 public constant MY_HASH = keccak256("abc"); //leak
}

contract Good1 {
    uint private constant X = 32 ** 22 + 8;
    string private constant TEXT = "abc";
    bytes32 private constant MY_HASH = keccak256("abc");
}

contract Good2 {
    uint constant X = 32 ** 22 + 8;
    string constant TEXT = "abc";
    bytes32 constant MY_HASH = keccak256("abc");
}
