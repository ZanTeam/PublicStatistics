pragma solidity 0.8.0;

contract Test {
    uint good1 = 3;
    uint constant good2 = 8888;
    address good3 = msg.sender;
    uint good4 = getNumber();
    uint good5 = 10 + block.number;
    uint bad1 = 6; //leak
    uint bad2 = 10; //leak
    address bad3 = 0x0000000000000000000000000000000000000000; //leak

    constructor() public {
        good1 = 10;
    }

    modifier notZeroAddr(address addr) {
        require(addr != bad3);
        _;
    }

    function getBad1() public returns (uint) {
        return bad1;
    }

    function getNumber() public returns (uint) {
        return block.number;
    }

    function transferETH(address addr) external payable notZeroAddr(addr) {
        addr.call{value: 1 ether}("");
    }
}
