pragma solidity ^0.5.4;

contract ERC20Interface {
    function transfer(uint amount) external returns (bool);
}

contract Test {
    address public owner;

    uint public totalSupply;

    mapping(address => uint) public balances;

    mapping(address => bool) public candidates;

    address[] public addrList;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor(address candidate, uint amount) public {
        totalSupply = 1000;
        owner = msg.sender;
        balances[candidate] += amount;
        addrList.push(candidate);
    }

    function good1(address a) external onlyOwner {
        require(candidates[a]);
        (bool ret, ) = a.call("");
        require(ret);
    }

    function good2(uint a) external {
        (bool ret, ) = addrList[a].call("");
        require(ret);
    }

    function bad1(address a) external {
        (bool ret, ) = a.call.value(10)(""); //leak
        require(ret);
    }

    function bad2(address a) external {
        bool ret = ERC20Interface(a).transfer(11); //leak
        require(ret);
    }
}
