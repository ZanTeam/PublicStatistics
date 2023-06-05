pragma solidity 0.4.25;

interface ERC20Interface {
    function transfer(uint amount) external returns (bool);
}

contract Test {
    address public owner;
    address aa;

    uint public totalSupply;
    uint public amount_;

    mapping(address => uint) public balances;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor() public {
        totalSupply = 1000;
        owner = msg.sender;
    }

    function good1(uint amount) external {
        require(balances[msg.sender] + amount >= amount);
        balances[msg.sender] += amount;
    }

    function good2(uint amount) external {
        uint ba = balances[msg.sender];
        balances[msg.sender] += amount;
        require(ba + amount >= amount);
        require(balances[msg.sender] >= 0 && balances[msg.sender] >= amount);
    }

    function good3(uint amount) external {
        uint a1 = amount;
        require(balances[msg.sender] > amount);
        balances[msg.sender] -= a1;
    }

    function good4(uint amount) external {
        uint a1 = amount;
        require(balances[msg.sender] + a1 >= balances[msg.sender]);
        balances[msg.sender] += amount;
    }

    function good5(uint amount) external {
        amount_ = amount;
        require(balances[msg.sender] + amount_ >= balances[msg.sender]);
        balances[msg.sender] += amount_;
    }

    function bad1(uint amount) external {
        amount_ = amount;
        balances[msg.sender] += amount_; //leak
    }

    function bad2(uint amount) external {
        amount_ = amount;
        balances[msg.sender] -= amount_; //leak
    }

    function bad3() external {
        balances[msg.sender]--; //leak
        if (balances[msg.sender] > 0) {
            //do sth
        }
    }

    function bad4() external {
        balances[msg.sender]++; //leak
        if (balances[msg.sender] < 100) {
            //do sth
        }
    }

    function bad5(uint a, uint b) external {
        balances[msg.sender] += a * b; //leak
    }
}
