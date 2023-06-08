pragma solidity ^0.5.0;

contract Test {
    function good1(uint256 price) external view returns (address, uint256 x) {
        x = (price / 100) * 3;
        return (msg.sender, x);
    }

    function good2(
        uint256 price
    ) external view returns (address addr, uint256 x) {
        addr = msg.sender;
        x = (price / 100) * 3;
    }

    function good3() public pure returns (uint a) {
        a = 10;
    }

    function good4() public pure returns (address a) {
        a = address(0x1);
    }

    function good5() public pure returns (string memory a) {
        a = "hello";
    }

    function good6() public pure returns (bool a) {
        a = true;
    }

    function bad1(uint256 price) external view returns (address a, uint256 x) {
        a = msg.sender;
        x = (price / 100) * 3;
        return (a, x); //leak
    }

    function bad2() public pure returns (uint a) {
        a = 10;
        return a; //leak
    }

    function bad3() public pure returns (address a) {
        a = address(0x1);
        return a; //leak
    }

    function bad4() public pure returns (string memory a) {
        a = "hello";
        return a; //leak
    }

    function bad5() public pure returns (bool a) {
        a = true;
        return a; //leak
    }
}
