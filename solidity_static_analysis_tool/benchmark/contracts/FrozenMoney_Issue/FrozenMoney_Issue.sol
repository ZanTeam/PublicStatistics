pragma solidity 0.4.25;

contract Bad {
    function deposit() payable {
        //leak
        require(msg.value > 0);
    }
}
