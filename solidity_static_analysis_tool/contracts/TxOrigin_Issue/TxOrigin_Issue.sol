pragma solidity ^0.4.25;

contract Test {
    address public owner;

    uint public totalSupply;
    modifier onlyOwner() {
        require(msg.sender == owner, "Must be owner");
        _;
    }

    constructor(address candidate, uint amount) public {
        totalSupply = 1000;
        owner = msg.sender;
    }

    function good1() external onlyOwner {
        owner = tx.origin;
    }

    function good2() external onlyOwner {
        address tmp = tx.origin;
        totalSupply += 10;
    }

    function good3() external onlyOwner {
        address tmp = tx.origin;
        require(msg.sender == owner);
        totalSupply += 10;
    }

    function bad1() public {
        if (tx.origin == owner) { //leak
            totalSupply += 10;
        }
    }

    function bad2() public {
        address tmp = tx.origin;
        if (tmp == owner) { //leak
            totalSupply += 10;
        }
    }

    function good4() public {
        if (msg.sender != tx.origin) {
            revert();
        }
    }

    function good5() public {
        tx.origin.transfer(this.balance);
    }
}
