pragma solidity ^0.4.20;

contract Test {
    address owner;
    uint a;
    bool reentrancyLock;
    bool initialized;

    function Test() public {
        owner = msg.sender;
    }

    modifier bad1() {
        a = 4; //leak
        _;
    }

    modifier bad2() {
        if (a > 1) {
            if (a > 4) {
                revert("too large");
            } else {
                _;
            }
        } else {
            _;
        }
        a = 4; //leak
    }

    modifier bad3() {
        if (a > 1) {
            _;
        } else {
            a = 5; //leak
        }
    }

    modifier nonReentrancy() {
        require(!reentrancyLock);
        reentrancyLock = true;
        _;
        reentrancyLock = false;
    }

    modifier initializer() {
        require(!initialized);
        initialized = true;
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function A() public bad1 returns (uint) {
        return 0;
    }

    function B() public bad2 returns (uint) {
        return 0;
    }

    function C() public bad3 returns (uint) {
        return 0;
    }

    function D() public nonReentrancy returns (uint) {
        return 0;
    }

    function E() public initializer returns (uint) {
        return 0;
    }

    function F() public onlyOwner returns (uint) {
        return 0;
    }
}
