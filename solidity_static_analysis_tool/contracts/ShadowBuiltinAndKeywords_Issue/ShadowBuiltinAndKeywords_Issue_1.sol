pragma solidity 0.8.0;

contract builtinSymbol {
    uint blockhash; //leak
    uint now; //leak
    uint ecrecover = 7; //leak

    event revert(bool condition); //leak

    function assert(bool condition) public { //leak
        uint msg; //leak
    }

    uint abi; //leak

    modifier require() { //leak
        assert(msg.sender != address(0));
        uint keccak256; //leak
        uint sha3; //leak
        _;
    }

    function assert() public require {} //leak

    fallback() external payable {}

    receive() external payable {}
}
