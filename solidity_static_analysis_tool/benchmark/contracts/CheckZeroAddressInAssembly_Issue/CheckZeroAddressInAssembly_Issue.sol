pragma solidity ^0.8.0;

contract Test1 {
    error ZeroAddress();

    function good(address addr) external {
        assembly {
            if iszero(addr) {
                let ptr := mload(0x40)
                mstore(
                    ptr,
                    0xd92e233d00000000000000000000000000000000000000000000000000000000
                )
                revert(ptr, 0x4)
            }
        }
    }
}

contract Test2 {
    error ZeroAddress();

    function bad1(address addr) external {
        if (addr == address(0x0)) //leak
            revert ZeroAddress();
    }
}

contract Test3 {
    function bad2(address addr) external {
        require(addr != address(0x0), "addr should not be zero address"); //leak
    }

    function bad3(address addr) external {
        require(
            addr != 0x0000000000000000000000000000000000000000,
            "addr should not be zero address"
        ); //leak
    }

    function bad4(address addr) external {
        if (addr != address(0x0)) { //leak
            revert("addr should not be zero address");
        }
    }

    function bad5(address addr) external {
        if (addr != 0x0000000000000000000000000000000000000000) { //leak
            revert("addr should not be zero address");
        }
    }

    function bad6(
        address from,
        address to,
        uint256 value
    ) external returns (bool) {
        bool isSuccess = bad6_internal(from, to, value);
        return isSuccess;
    }

    function bad6_internal(
        address _from,
        address _to,
        uint256 value
    ) internal returns (bool) {
        require(_to != address(0) || _from != address(0)); //leak
        return true;
    }
}

contract Test4 {
    mapping(uint => address) num;

    function setNum(uint no, address addr) external {
        num[no] = addr;
    }

    function bad7(uint no) external {
        address addr = num[no];
        require(no != 0 && addr != address(0x0), "wrong addr"); //leak
    }
}
