pragma solidity ^0.8.0;

contract Test {
    uint a;
    mapping(address => uint256) balance;
    address owner;
    uint256 constant fee = 1;
    uint256[4] arr = [uint256(2), uint256(3), uint256(4), uint256(5)];
    mapping(address => mapping(address => uint256)) allowance;

    struct Book {
        string title;
        uint count;
    }

    Book book;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner can call the function");
        _;
    }

    function bad1(uint256 m) external {
        a = 10; //leak
        a = m;
    }

    function good1(address from, address to, uint256 amount) external {
        require(balance[from] >= amount, "not enough token");
        balance[from] -= amount;
        balance[to] += amount;
    }

    function bad2(address from, address to, uint256 amount) external {
        require(balance[from] + fee >= amount, "not enough token");
        balance[from] -= amount; //leak
        balance[to] += amount;
        balance[from] -= fee;
    }

    function test(address from, address to, uint256 amount) external {
        require(balance[from] >= amount, "not enough token");
        uint256 a = balance[from] - amount;
        balance[to] += amount;
        require(a >= fee, "not enough token");
        balance[from] -= fee;
    }

    function good2(address from, address to, uint256 amount) external {
        require(balance[from] >= amount, "not enough token");
        balance[from] -= amount;
        balance[to] += amount;
        require(balance[from] >= fee, "not enough token");
        balance[from] -= fee;
    }

    function good3() external {
        for (uint i = 0; i < 4; ++i) {
            arr[i] = i;
        }
    }

    function setBook(string memory name, uint256 count) external {
        book = Book(name, count);
    }

    function bad3() external {
        book.count = 2; //leak
        book.title = "Python";
        book.count = 3;
    }

    function good4() external {
        book.count = 2;
        book.title = "Python";
        book.count = book.count + 3;
    }

    function bad4() external {
        book.count = 2; //leak
        book.title = "Python";
        book.count += 3;
    }

    function bad5(address a, address b, uint256 amount) external {
        allowance[a][b] = amount; //leak
        allowance[a][b] = 10;
    }

    function bad6() external {
        string memory name = book.title;
        book.count = 2; //leak
        if (
            keccak256(abi.encodePacked(name)) ==
            keccak256(abi.encodePacked("Python"))
        ) {
            book.count = 2;
            book.count = 3;
        } else {
            book.count = 3;
        }

        if (
            keccak256(abi.encodePacked(name)) ==
            keccak256(abi.encodePacked("Java"))
        ) {
            book.count = 4;
        } else {
            book.count = 5;
        }
    }

    function good5() external {
        book.count = 2;
        book.title = "Python";
        good5_internal();
    }

    function good5_internal() internal {
        book.count = 3;
    }

    function bad7() external {
        book.count = 2;
        book.title = "Python";
        bad7_internal();
    }

    function bad7_internal() internal {
        book.count = 3; //leak
        book.count = 2;
    }

    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status = _NOT_ENTERED;

    modifier nonReentrant() {
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
        _status = _ENTERED;

        _;
        _status = _NOT_ENTERED;
    }

    function good6() external nonReentrant {
        book.count = 2;
    }

    mapping(address => uint256) balanceOf;

    event Transfer(address indexed from, address indexed to, uint256 value);

    function bad8(address to_, uint256 amount_) public returns (bool) {
        balanceOf[msg.sender] -= amount_;
        balanceOf[to_] += amount_;
        emit Transfer(msg.sender, to_, amount_);
        return true;
    }
}

contract Test1 {
    mapping(address => uint) userWhiteList;

    constructor() public {
        userWhiteList[0x3cB3677A47f1A6174e30E4243ADCA402f2D3b9B4] =
            100_000_000 +
            100_000_000 +
            89_824_544 +
            27_271_388;
        userWhiteList[0xF6dCA0B3AE21661Ef12FF8d78ED38C5e493c0721] = 211_689_602;
        userWhiteList[
            0x7DF26Bd5601422B394E2A7b8B9063c0e0590fA89
        ] = 1654_037_723;
        userWhiteList[0x8eA4EaF95C8Bd2EB384e21963519F1e1331CEBe9] = 1_000_000;
    }
}
