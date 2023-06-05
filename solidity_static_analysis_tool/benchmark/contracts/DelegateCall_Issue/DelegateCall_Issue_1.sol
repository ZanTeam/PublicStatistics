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

    function bad1(address a) external {
        a.delegatecall(""); //leak
    }
}
