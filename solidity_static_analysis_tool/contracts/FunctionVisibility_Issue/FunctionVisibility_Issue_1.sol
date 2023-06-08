pragma solidity ^0.4.19;

interface Test1 {
    function good(address addr) external view returns (bool);

    function bad1(address addr) view returns (bool); //leak

    function bad2(address addr) public view returns (bool); //leak
}

contract Test2 {
    uint public x;

    function good1(uint256 val) public {
        val = val + 1;
    }

    function good2() external {}

    function bad1(uint256 val) {
        //leak
        val = val + 1;
    }

    function bad2() {} //leak

    function() payable {
        //leak
        x = 1;
    }

    function Test2() {} //leak
}

contract Test3 {
    function Test3() public {}

    function() external payable {}
}
