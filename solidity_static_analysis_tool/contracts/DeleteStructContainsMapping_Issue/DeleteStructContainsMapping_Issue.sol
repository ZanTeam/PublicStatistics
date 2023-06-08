pragma solidity ^0.4.25;

library Lib {
    struct MyStruct {
        mapping(address => uint) maps;
    }

    function deleteSt(MyStruct[1] storage st) {
        delete st[0]; //leak
    }
}

contract Test {
    struct BalancesStruct {
        address owner;
        mapping(address => uint256) balances;
    }

    mapping(address => BalancesStruct) public stackBalance;
    mapping(uint => BalancesStruct) public OtherBalance;

    function createBalance(uint idx) public {
        require(OtherBalance[idx].owner == 0);
        OtherBalance[idx] = BalancesStruct(msg.sender);
    }

    function setBalance(uint idx, address addr, uint val) public {
        require(OtherBalance[idx].owner == msg.sender);

        OtherBalance[idx].balances[addr] = val;
    }

    function getBalance(uint idx, address addr) public view returns (uint) {
        return OtherBalance[idx].balances[addr];
    }

    function bad1() public {
        BalancesStruct memory balance;

        delete stackBalance[msg.sender]; //leak
        delete balance; //leak
    }

    function bad2Func() internal {
        BalancesStruct memory balance;

        delete stackBalance[msg.sender]; //leak
        delete balance; //leak
    }

    function bad2() public {
        bad2Func();
    }

    function bad3(uint idx) external {
        require(OtherBalance[idx].owner == msg.sender);
        delete OtherBalance[idx]; //leak
    }
}
