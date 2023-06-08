pragma solidity ^0.6.6;

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
        (bool ret, ) = msg.sender.call.value(1).gas(3800)("");
    }

    function bad1(uint amount) external {
        require(balances[msg.sender] > amount);
        (bool ret, ) = msg.sender.call.value(1).gas(3800)(""); //leak
        balances[msg.sender] -= amount;
    }

    function bad2(uint amount) external {
        require(balances[msg.sender] > amount);
        (bool callresult, ) = msg.sender.call{value: amount}(""); //leak
        balances[msg.sender] -= amount;
    }

    function bad3(uint amount) external {
        require(balances[msg.sender] > amount);
        (bool success, ) = msg.sender.call{value: 1 ether}(
            abi.encodeWithSignature("someOtherFunction(uint256)", 123)
        ); //leak
        balances[msg.sender] -= amount;
    }
}
