pragma solidity 0.4.24;

contract reservedKeywords {
    uint define; //leak
    uint apply; //leak
    uint implements = 7; //leak

    event supports(bool condition); //leak

    function partial(bool condition) public { //leak
        uint macro; //leak
    }

    modifier reference() { //leak
        assert(msg.sender != address(0));
        _;
    }
}
