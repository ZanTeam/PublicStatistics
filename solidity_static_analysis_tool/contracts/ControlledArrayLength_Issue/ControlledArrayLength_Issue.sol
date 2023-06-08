pragma solidity ^0.4.2;

contract Test {
    uint[] testArray;
    uint120[] arr;

    uint[5] fixedArray;

    struct TestStructWithArray {
        uint[] x;
        uint[][] y;
    }
    struct TestStructWithStructWithArray {
        TestStructWithArray subStruct;
        uint[] z;
    }

    TestStructWithArray a;
    TestStructWithStructWithArray b;

    function good1(uint userIndex, uint val) public {
        testArray[userIndex] = val;
    }

    function bad1(uint usersCount) public {
        testArray.length = usersCount; //leak
    }

    function bad2(uint param, uint param2) public {
        uint x = 1 + param;
        if (x > 3) {
            arr.length = 7;
            arr.length = param; //leak
        }
    }

    function bad3(uint param, uint param2) public {
        a.x.length = param; //leak
        b.subStruct.x.length = param + 1; //leak
    }
}
