pragma solidity 0.4.22;

contract Bad {
    //leak

    uint public x;

    function Bad() public {
        x = 2;
    }

    constructor() public {
        x = 1;
    }
}
