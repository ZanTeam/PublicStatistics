pragma solidity ^0.4.24;

import "./A.sol";

contract Test1 {
    function() returns (uint) ptr;

    function good1(address addr, uint256 amount) external {
        addr.call.value(amount)("");
    }

    function good2() public {
        good3(msg.sender, 100);
    }

    function good3(address addr, uint256 amount) internal {
        addr.call.value(amount)("");
    }

    function good4() external {
        ptr = good5;
    }

    function good5() public returns (uint) {
        return 1;
    }

    function good6() external {
        function() returns (uint) ptr1;
        ptr1 = good7;
    }

    function good7() public returns (uint) {
        return 2;
    }

    function good8() external returns (uint) {
        return ptr();
    }
}

contract Test2 {
    function bad1(address addr, uint256 amount) public { //leak
        address test1Addr = address(new Test1());
        test1Addr.call(
            abi.encode(
                bytes4(keccak256("good3(address,uint256)")),
                addr,
                amount
            )
        );
    }

    function bad2() public { //leak
        A a = new A();
        a.good(10, 20);
    }

    function bad3() internal returns (uint) { //leak
        return 3;
    }
}
