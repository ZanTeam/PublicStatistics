pragma solidity ^0.4.19;

contract Test {
    struct Stu {
        address addr;
        uint256 no;
    }

    Stu[] public stuArr;

    function good(uint256 number) external {
        Stu memory stu;
        stu.addr = msg.sender;
        stu.no = number;
        stuArr.push(stu);
    }

    function bad(uint256 number) external {
        Stu stu; //leak
        stu.addr = msg.sender;
        stu.no = number;
        stuArr.push(stu);
    }
}
