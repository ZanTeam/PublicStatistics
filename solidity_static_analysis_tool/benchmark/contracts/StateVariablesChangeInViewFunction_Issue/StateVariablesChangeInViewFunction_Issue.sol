pragma solidity ^0.4.20;

contract Test {
    uint x = 3;
    uint y;

    struct TestStruct {
        address addr;
        mapping(address => uint256) balances;
    }

    TestStruct _balance;

    function bad1(uint256 a) public view {
        x += a; //leak
    }

    function bad2(address addr) public view {
        _balance.addr = msg.sender; //leak
    }

    function bad3() public view {
        y = 0; //leak
    }

    function bad4() public constant {
        y = 0; //leak
    }

    event logUint(uint);

    function bad5(uint x) public view {
        logUint(x); //leak
    }

    function bad6() public view {
        Called called = new Called(); //leak
    }

    function bad7(address addr) public view {
        addr.transfer(100 wei); //leak
    }

    function bad8(address _b, uint256 a, uint256 b) public view {
        bool success = address(_b).delegatecall(
            abi.encodeWithSignature("add(uint256,uint256)", a, b)
        ); //leak
        require(success);
    }

    function bad9() public view {
        selfdestruct(this); //leak
    }

    function bad10(uint x) public view {
        emit logUint(x); //leak
    }

    function good1() public view {
        uint y;
        y = 0;
    }

    function good2() public view {
        y;
    }
}

contract Called {
    uint256 public a = 100;

    function func(uint256 x, uint256 y) external returns (uint256) {
        return x + y;
    }
}
