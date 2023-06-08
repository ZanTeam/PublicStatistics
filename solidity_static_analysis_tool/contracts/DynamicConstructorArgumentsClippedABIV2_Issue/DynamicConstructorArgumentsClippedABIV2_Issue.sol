pragma solidity ^0.4.16; //0.4.16 - 0.5.9
pragma experimental ABIEncoderV2;

contract Bad1 {
    uint data;

    struct testStruct {
        int[] arr;
    }

    constructor(uint _data, testStruct memory test) public {
        //leak
        data = _data;
    }
}

contract Bad2 is Bad1 {
    constructor(
        uint _data,
        int[] memory arr
    ) public Bad1(_data, testStruct(arr)) {
        //leak
    }
}
