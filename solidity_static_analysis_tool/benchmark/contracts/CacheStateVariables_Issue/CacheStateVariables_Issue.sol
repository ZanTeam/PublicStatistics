pragma solidity ^0.8.0;

contract Test1 {
    mapping(address => uint256) balance;
    address owner;
    uint256 a = 10 + 5;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner can call the function");
        _;
    }

    function mint(address addr) external onlyOwner {
        balance[addr] += 10;
    }

    function bad(address addr) external returns (uint256) {
        uint256 sum = 0;
        sum += balance[addr]; //leak
        if (balance[addr] < 20) {
            sum += balance[addr];
        }
        return sum;
    }
}

contract Test2 {
    mapping(address => uint256) balance;
    address owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner can call the function");
        _;
    }

    function mint(address addr) external onlyOwner {
        balance[addr] += 10;
    }

    function good(address addr) external returns (uint256) {
        uint256 sum = 0;
        uint256 _balance = balance[addr];
        sum += _balance;
        if (_balance < 20) {
            sum += _balance;
        }
        return sum;
    }
}

contract Test3 {
    uint256 totalsupply;

    constructor() {
        totalsupply = 100;
    }

    function bad(uint256 m) external returns (uint256) {
        uint256 x;
        if (totalsupply >= 100) { //leak
            x = m + totalsupply;
        }
        x += totalsupply;
        totalsupply--;
        return x;
    }
}

contract Test4 {
    uint256 totalsupply;

    constructor() {
        totalsupply = 100;
    }

    function good(uint256 m) external returns (uint256) {
        uint256 x;
        uint256 _totalsupply = totalsupply;
        if (_totalsupply >= 100) {
            x = m + _totalsupply;
        }
        x += _totalsupply;
        return x;
    }
}

contract Test5 {
    bytes private constant CODE_STRING =
        "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";
    bytes32 constant OWNER_SLOT = keccak256("qom.network.proxy.owner");

    function bad1() external {
        bytes memory result = new bytes(46);
        for (uint i = 0; i < 46; i++) {
            result[i] = CODE_STRING[uint8(result[i])];
        }
    }
}

contract Test6 {
    mapping(address => uint256) balance;

    function setBalance(address addr) external {
        balance[addr] = 300;
    }

    function bad(address addr) external {
        require(balance[addr] > 200); //leak
        balance[addr] += 100;
    }
}

contract Test7 {
    mapping(address => uint256) balance;

    function setBalance(address addr) external {
        balance[addr] = 300;
    }

    function bad(address addr) external {
        require(balance[addr] > 200); //leak
        balance[addr] = balance[addr] + 100;
    }
}

contract Test8 {
    mapping(address => uint256) balance;

    function setBalance(address addr) external {
        balance[addr] = 300;
    }

    function bad(address addr) external {
        uint256 tmp = balance[addr];
        require(tmp > 200);
        balance[addr] = tmp + 100;
    }
}

contract Test9 {
    uint256 a;

    function good() external {
        uint256 b = a;
        good_internal();
    }

    function good_internal() internal {
        uint256 b = a;
    }
}
