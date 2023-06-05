pragma solidity ^0.8.0;

contract Test {
    mapping(address => uint) balances;

    function withdraw() external returns (bool) {
        uint amount = balances[msg.sender];
        if (amount > 0) {
            balances[msg.sender] = 0;
            if (payable(msg.sender).send(amount)) {
                balances[msg.sender] = amount;
                return false;
            }
        }
        return true;
    }
}
