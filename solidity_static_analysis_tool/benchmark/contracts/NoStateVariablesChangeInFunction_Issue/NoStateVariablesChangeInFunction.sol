pragma solidity 0.4.10;

contract A {
    uint info = 3;
    struct BalancesStruct {
        address owner;
        mapping(address => uint256) balances;
    }

    BalancesStruct balance;

    function bad1(uint256 a) public { //leak
        uint mya = a;
    }

    function good1(uint256 a) public {
        info += a;
        balance.owner = msg.sender;
    }

    function good2(uint256 a) public {
        changeStateVar(a);
    }

    function changeStateVar(uint256 a) internal {
        info += a;
    }
}

contract Constant {
    uint a;

    function good3() public {
        a = 0;
    }

    function bad2() public { //leak
        uint a;
        a = 0;
    }

    function bad3() public { //leak
        a;
    }

    function bad4() public { //leak
        assembly {

        }
    }
}

contract A {
    uint a = 100;
    event WithdrewTokens(address tokenContract, address to, uint256 amount);

    function good6(uint256 unlockDate) public onlyOwner {
        test_view_bug();
    }

    function test_view_bug() public {
        // a = 0;
        uint b = 0;
    }
}
