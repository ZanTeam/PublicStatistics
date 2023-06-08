pragma solidity >=0.4.20;

contract Test {
    address owner;

    function Test() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function bad1(address a) external { //leak
        suicide(a);
    }

    function bad2(address a) external { //leak
        selfdestruct(a);
    }

    function good1(address a) external onlyOwner {
        suicide(a);
    }

    function good2(address a) external onlyOwner {
        selfdestruct(a);
    }
}
