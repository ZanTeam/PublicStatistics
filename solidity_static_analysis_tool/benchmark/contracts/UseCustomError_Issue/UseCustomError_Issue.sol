pragma solidity ^0.8.0;

contract good {
    // deploy: 106501 gas
    address owner;
    error Unauthorized(address sender);

    constructor() {
        owner = msg.sender;
    }

    function withdraw() public {
        // msg.sender == owner : 2494 gas   msg.sender != owner : 2527 gas
        if (msg.sender != owner) revert Unauthorized(msg.sender);

        payable(msg.sender).transfer(address(this).balance);
    }
}

contract bad1 {
    // deploy: 112707 gas
    address owner;

    constructor() {
        owner = msg.sender;
    }

    function withdraw() public {
        // msg.sender == owner : 2494 gas   msg.sender != owner : 2578 gas
        if (msg.sender != owner) revert("unauthorized sender"); //leak

        payable(msg.sender).transfer(address(this).balance);
    }
}

contract bad2 {
    // deploy: 112707 gas
    address owner;

    constructor() {
        owner = msg.sender;
    }

    function withdraw() public {
        // msg.sender == owner : 2494 gas   msg.sender != owner : 2578 gas
        require(msg.sender == owner, "unauthorized sender"); //leak

        payable(msg.sender).transfer(address(this).balance);
    }
}
