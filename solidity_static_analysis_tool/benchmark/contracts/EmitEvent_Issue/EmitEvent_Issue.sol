pragma solidity 0.4.25;

contract Test {
    event log(uint a);

    function bad(uint b) public returns (uint) {
        log(b); //leak
        return b;
    }

    function good(uint b) public returns (uint) {
        emit log(b);
        return b;
    }
}
