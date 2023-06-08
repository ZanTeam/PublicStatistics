pragma solidity 0.4.13; // 0.3.0 - 0.4.14

contract Test {
    address lib;

    function Test(address _library) public {
        lib = _library;
    }

    function() public {
        require(lib.delegatecall(msg.data)); //leak
    }
}
