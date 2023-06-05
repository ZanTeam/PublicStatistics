pragma solidity ^0.5.4;

contract Test {
    address addr_good = address(0x41);
    address addr_bad;

    bytes4 func_id;

    constructor() public {
        addr_bad = msg.sender;
    }

    function bad1(bytes memory data) public {
        addr_good.call.value(10)(data);
        addr_bad.call.value(10)(data); //leak
    }

    function set(bytes4 id) public {
        func_id = id;
        addr_bad = msg.sender;
    }

    function bad2(bytes memory data) public {
        addr_bad.call.value(10)(abi.encode(func_id, data)); //leak
    }

    function good1(bytes memory data) public {
        addr_good.call.value(10)(abi.encode(bytes4(""), data));
    }
}
