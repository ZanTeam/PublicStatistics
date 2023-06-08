pragma solidity ^0.8.17;

contract Test {
    B immutable _b;
    address constant C = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    address _owner;
    address immutable _d;

    constructor(B b, address addr) {
        _b = b;
        _owner = msg.sender;
        _d = addr;
    }

    modifier onlyOwner() {
        require(msg.sender == _owner, "only owner can call the function");
        _;
    }

    function good1(uint256 a, uint256 b) external {
        (bool success, bytes memory data) = address(_b).delegatecall(
            abi.encodeWithSignature("add(uint256,uint256)", a, b)
        );
        require(success);
    }

    function good2(uint256 a, uint256 b) external {
        (bool success, bytes memory data) = C.delegatecall(
            abi.encodeWithSignature("add(uint256,uint256)", a, b)
        );
        require(success);
    }

    function good3(uint256 a, uint256 b) external {
        (bool success, bytes memory data) = address(this).delegatecall(
            abi.encodeWithSignature("sub(uint256,uint256)", a, b)
        );
        require(success);
    }

    function good4(uint256 a, uint256 b) external {
        (bool success, bytes memory data) = _d.delegatecall(
            abi.encodeWithSignature("sub(uint256,uint256)", a, b)
        );
        require(success);
    }

    function bad1(address addr, uint256 a, uint256 b) external onlyOwner {
        (bool success, bytes memory data) = addr.delegatecall(
            abi.encodeWithSignature("sub(uint256,uint256)", a, b)
        ); //leak
        require(success);
    }

    function bad2(address addr, uint256 a, uint256 b) external {
        (bool success, bytes memory data) = addr.delegatecall(
            abi.encodeWithSignature("sub(uint256,uint256)", a, b)
        ); //leak
        require(success);
    }

    function sub(uint256 a, uint256 b) external returns (uint256) {
        return a - b;
    }
}

contract B {
    function add(uint256 a, uint256 b) external returns (uint256) {
        return a + b;
    }
}
