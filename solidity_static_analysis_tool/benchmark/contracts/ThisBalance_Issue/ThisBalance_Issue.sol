pragma solidity 0.4.25;

contract Test1 {
    function bad1(address addr) {
        if (this.balance == 100 wei) {} //leak
    }
}

contract Test2 {
    uint256 balance;
    address owner;

    constructor(address candidate, uint256 amount) public {
        balance = 3;
        owner = msg.sender;
    }

    function bad2() public payable {
        if (address(this).balance == 3 && msg.sender == owner) { //leak
            owner.transfer(address(this).balance);
        }
    }

    function bad3(address addr) {
        if ((addr.balance) == 0) {} //leak
    }

    function bad4(address addr) {
        if (1 + addr.balance == 0) {} //leak
    }

    function good1(address addr) {
        if (address(this).balance != 100 wei) {}
    }

    function good2(address addr) {
        if (good2_internal(addr.balance) == 0) {}
    }

    function good3(address addr) {
        if (this.balance > 100 wei) {}
    }

    function good4(address addr) {
        if (address(this).balance >= 100 wei) {}
    }

    function good5(address addr) {
        if (addr.balance <= 100 wei) {}
    }

    function good6(address addr) {
        if (msg.sender.balance < 100 wei) {}
    }

    function good7(address addr) {
        if (good7_internal(addr).balance >= 100 wei) {}
    }

    function good8(address addr) {
        if (this.balance == 100 wei) {}
    }

    function good2_internal(uint) returns (uint) {
        return 0;
    }

    function good7_internal(address _addr) public returns (address) {
        return _addr;
    }
}
