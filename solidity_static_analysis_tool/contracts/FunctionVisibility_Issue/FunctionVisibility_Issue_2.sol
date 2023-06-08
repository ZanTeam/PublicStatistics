pragma solidity >=0.7.0 <0.9.0;

contract Test1 {
    address owner;

    constructor() {
        owner = msg.sender;
    }
}

contract Test2 {
    address owner;

    constructor() public {
        //leak
        owner = msg.sender;
    }
}
