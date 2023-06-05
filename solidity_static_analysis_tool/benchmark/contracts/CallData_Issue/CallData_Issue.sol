pragma solidity ^0.8.0;

contract Test {
    function good1(string calldata name, uint age) external {}

    struct Person {
        string name;
        uint age;
    }

    function good2(Person calldata p, uint age) external {}

    function good3(bytes calldata payload, uint age) external {}

    function bad1(string memory name, uint age) external {
        //leak
    }

    function bad2(Person memory p, uint age) external {
        //leak
    }

    function bad3(bytes memory payload, uint age) external {
        //leak
    }

    enum SalePhase {
        WaitingToStart,
        InProgressWhitelist,
        Finished
    }

    function good4(SalePhase phase_) external {}
}
