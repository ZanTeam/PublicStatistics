pragma solidity ^0.8.1;

import "./importFiles/test_import.sol";

contract Good2 {
    function setString(Test test, string str) public {
        test.setValue(str);
    }
}
