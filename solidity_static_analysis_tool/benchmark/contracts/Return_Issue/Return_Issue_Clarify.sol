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

    address _a = msg.sender;

    function bad1(uint256 price) external view returns (address a, uint256 x) {
        x = (price / 100) * 3;
        return (_a, x); //leak
    }

    function bad2(uint256 price) external view returns (address a, uint256 x) {
        address b = msg.sender;
        x = (price / 100) * 3;
        return (b, x); //leak
    }

    function bad3() public pure returns (uint a) {
        uint b = 10;
        return b; //leak
    }

    function bad4() public pure returns (address a) {
        a = address(0x1);
        return address(0x0); //leak
    }

    function bad5() public pure returns (string memory a) {
        a = "hello";
        return "world"; //leak
    }

    function bad6() public pure returns (bool a) {
        a = true;
        return false; //leak
    }

    function bad7(uint256 price) external view returns (address, uint256 x) {
        uint y = (price / 100) * 3;
        return (msg.sender, y); //leak
    }

    function bad8(
        uint256 price
    ) external view returns (bool success, uint256 x) {
        x = (price / 100) * 3;
        return (false, x); //leak
    }
}
