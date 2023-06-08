pragma solidity ^0.5.4;

contract ERC20Interface {
    function transfer(uint amount) external;
}

contract Test {
    address public owner;

    mapping(address => uint) public balances;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor(address candidate, uint amount) public {
        owner = msg.sender;
        balances[candidate] = amount;
    }

    function good(uint amount) external {
        require(balances[msg.sender] > amount);
        balances[msg.sender] -= amount;
        ERC20Interface(msg.sender).transfer(amount);
    }

    function bad(uint amount) external {
        require(balances[msg.sender] > amount);
        ERC20Interface(msg.sender).transfer(amount); //leak
        balances[msg.sender] -= amount;
    }
}
