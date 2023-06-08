pragma solidity 0.4.20; // <0.4.22;
pragma experimental ABIEncoderV2;

contract Test {
    function testcall() external returns (uint8[2][3] memory) {
        uint8[2][3] memory bad_arr = [[1, 1], [1, 1], [1, 1]];
        return bad_arr;
    }
}

contract Test1 {
    event log(uint8[2][3]);

    function bad1(address x) public returns (bool) {
        uint8[2][3] memory bad_arr = Test(x).testcall(); //leak
        log(bad_arr);
        return true;
    }
}
