pragma solidity ^0.4.25;

contract Test {
    uint[] private arr;

    constructor() public {
        arr = new uint[](0);
    }

    function good1(uint x) public {
        arr.push(x);
    }

    function good2(uint index, uint x) public {
        require(arr.length > index);
        arr[index] = x;
    }

    function bad1() public {
        require(arr.length > 0);
        arr.length--; //leak
    }

    function bad2(uint x) public {
        arr.length++; //leak
        arr[arr.length - 1] = x;
    }
}
