pragma solidity ^0.4.25;

contract Test {
    function bad0(bytes data) external {
        this.call(data); //leak
    }

    function bad1(bytes data) external {
        address(this).call(data); //leak
    }

    function bad2(bytes data) external {
        address addr = address(this);
        addr.call(data); //leak
    }

    function bad3(bytes data) external {
        address addr = address(this);
        address tmp;
        tmp = addr;
        tmp.call(data); //leak
    }
}
