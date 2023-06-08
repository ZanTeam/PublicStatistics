pragma solidity ^0.8.0;

contract Test1 {
    uint public start;
    uint public calculatedFibNumber;

    function setStart(uint _start) public {
        start = _start;
    }

    function setFibonacci(uint n) public {
        calculatedFibNumber = fibonacci(n);
    }

    function fibonacci(uint n) internal returns (uint) {
        if (n == 0) return start;
        else if (n == 1) return start + 1;
        else return fibonacci(n - 1) + fibonacci(n - 2);
    }
}

contract Test2 {
    address public fibonacciLibrary;

    uint public calculatedFibNumber;

    uint public start = 3;
    uint public withdrawlCounter;

    bytes4 constant fibSig = bytes4(keccak256("setFibonacci(256)"));

    constructor(address _fibonacciLibrary) public payable {
        fibonacciLibrary = _fibonacciLibrary;
    }

    function bad1() external {
        withdrawlCounter += 1;

        fibonacciLibrary.delegatecall(
            abi.encodeWithSignature("setFibonacci(256)", withdrawlCounter)
        ); //leak
    }

    function bad2() internal {
        fibonacciLibrary.delegatecall(msg.data); //leak
    }

    fallback() external {
        bad2();
    }
}
