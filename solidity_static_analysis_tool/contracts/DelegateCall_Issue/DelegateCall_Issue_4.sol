pragma solidity 0.8.17;

contract Test {
    address addr_good = address(0x41);
    address addr_bad;

    bytes4 func_id;

    constructor() {
        addr_bad = msg.sender;
    }

    function bad1(bytes memory data) public {
        addr_bad.delegatecall(data); //leak
    }

    function set(bytes4 id) public {
        func_id = id;
        addr_bad = msg.sender;
    }

    function bad2(bytes memory data) public {
        addr_bad.delegatecall(abi.encode(func_id, data)); //leak
    }

    function good1(bytes memory data) public {
        addr_good.delegatecall(abi.encode(bytes4(""), data));
    }

    function good2(bytes memory data) public {
        addr_good.delegatecall(data);
    }
}
