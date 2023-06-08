pragma solidity ^0.4.24;

contract Test1 {
    address owner = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    address addr;
    address destination; //leak
    uint256 m; //leak
    uint256 n = 100;
    address[] public whitelist;
    uint256 z; //leak

    function good1() external payable {
        owner.transfer(msg.value);
    }

    function func1() external {
        addr = msg.sender;
    }

    function good2() external payable {
        addr.transfer(msg.value);
    }

    function good3() external returns (uint256 x) {
        x = n + 100;
    }

    function good4() external {
        whitelist.push(msg.sender);
    }

    function bad1() public payable {
        destination.transfer(msg.value);
    }

    function bad2() external returns (uint256 x) {
        x = m + 100;
    }

    function func2(uint256 a, uint256 b) internal returns (uint256) {
        return a + b;
    }

    function bad3() external {
        func2(m, 10);
    }

    function bad4() external returns (uint256) {
        return func2(m, 10);
    }

    function bad5() external returns (uint256) {
        return z + 1;
    }

    function bad6() external {
        address addrLocal; //leak
        addrLocal.transfer(msg.value);
    }
}

contract Test2 {
    mapping(address => uint) balances1;
    mapping(address => uint) balances2;

    function func1() {
        balances2[msg.sender] = 0;
    }

    function good() {
        require(balances1[msg.sender] == balances2[msg.sender]);
    }
}

library Lib {
    struct MyStruct {
        uint val;
    }

    function set(MyStruct storage st, uint v) {
        st.val = 4;
    }
}

contract Test3 {
    using Lib for Lib.MyStruct;

    Lib.MyStruct st1;
    Lib.MyStruct st2;
    uint v; //leak

    function bad() {
        st2.set(v);
    }

    function good() {
        require(st1.val == st2.val);
    }
}
