pragma solidity ^0.4.11;

/**
 * @title Destructible
 * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
 */
contract A {
    address owner;

    modifier onlyOwner() {
        require(owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    function Destructible() payable {}

    /**
     * @dev Transfers the current balance to the owner and terminates the contract.
     */
    function destroy() onlyOwner {
        selfdestruct(owner);
    }

    function destroyAndSend(address _recipient) onlyOwner {
        selfdestruct(_recipient);
    }
}

contract B {
    address owner;

    modifier onlyOwner() {
        require(owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    function Destructible() payable {}

    /**
     * @dev Transfers the current balance to the owner and terminates the contract.
     */
    function destroy() onlyOwner {
        selfdestruct(owner);
    }

    function destroyAndSend(address _recipient) onlyOwner {
        selfdestruct(_recipient);
    }
}

contract Destructible is
    A,
    B //leak
{
    function Destructible() payable {}

    /**
     * @dev Transfers the current balance to the owner and terminates the contract.
     */
    function destroy() onlyOwner {
        selfdestruct(owner);
    }

    function destroyAndSend(address _recipient) onlyOwner {
        selfdestruct(_recipient);
    }
}
