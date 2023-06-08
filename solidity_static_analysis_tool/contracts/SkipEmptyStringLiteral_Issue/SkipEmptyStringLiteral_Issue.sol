pragma solidity ^0.4.11;

contract Test {
    address owner = msg.sender;

    event CashMove(
        uint amount,
        bytes32 logMsg,
        address target,
        address currentOwner
    );

    function loggedTransfer(
        uint amount,
        bytes32 logMsg,
        address target,
        address currentOwner
    ) payable {
        if (msg.sender != address(this)) throw;
        if (target.call.value(amount)()) {
            CashMove(amount, logMsg, target, currentOwner);
        }
    }

    function bad1() public {
        if (msg.sender == owner) {
            this.loggedTransfer(this.balance, "", msg.sender, owner); //leak
        }
    }
}
