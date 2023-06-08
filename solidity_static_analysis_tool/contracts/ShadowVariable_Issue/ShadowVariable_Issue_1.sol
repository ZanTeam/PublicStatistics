pragma solidity 0.4.24;

contract ShadowingInFunctions {
    uint n = 2;
    uint x = 3;

    function g1() constant returns (uint n) {
        return n; // Will return 0
    }

    function g2() constant returns (uint n) {
        n = 1;
        return n; // Will return 1
    }

    function f1() constant returns (uint x) {
        uint n = 4;
        x = 0;
        return n + x; // Will return 4
    }
}

contract BaseContract1 {
    uint x = 5; //leak
    uint y = 5;
}

contract ExtendedContract is BaseContract1 {
    uint x = 7; //leak

    function z() public pure {}

    event v();
}

contract FurtherExtendedContract is ExtendedContract {
    uint x = 7;

    modifier w() {
        assert(msg.sender != address(0));
        _;
    }

    function shadowingParent(uint x) public pure {
        int y;
        uint z;
        uint w;
        uint v;
    }
}

contract BaseContract {
    address owner; //leak

    modifier isOwner() {
        require(owner == msg.sender);
        _;
    }
}

contract DerivedContract is BaseContract {
    address owner;

    constructor() {
        owner = msg.sender;
    }

    function withdraw() external isOwner {
        msg.sender.transfer(this.balance);
    }
}

contract ERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    constructor(string memory name, string memory symbol) public {
        _name = name;
        _symbol = symbol;
        _decimals = 18;
    }
}

contract Hello is ERC20 {
    string private _name = "Hello";
    string private _symbol = "Hello";

    constructor() public ERC20(_name, _symbol) {}
}
