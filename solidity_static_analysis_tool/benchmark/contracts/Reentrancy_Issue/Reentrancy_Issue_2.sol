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

    function bad1(uint amount) external {
        require(balances[msg.sender] > amount);
        _transfer(amount);
        update(amount);
    }

    function _transfer(uint amount) private {
        ERC20Interface(msg.sender).transfer(amount); //leak
    }

    function update(uint amount) private {
        balances[msg.sender] -= amount;
    }
}
