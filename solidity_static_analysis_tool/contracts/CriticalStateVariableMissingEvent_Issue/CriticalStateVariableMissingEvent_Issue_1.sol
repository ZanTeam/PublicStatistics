pragma solidity 0.8.0;

contract Test {
    mapping(address => uint) _balance;
    address _owner;

    event logOwnerChange(address oldOwner, address newOwner);
    event logBalanceChange(address from, address to, uint amount);

    constructor() {
        _owner = msg.sender;
    }

    modifier onlyOwner() {
        if (msg.sender != _owner) revert("only owner can call the function");
        _;
    }

    function good1(address newOwner) external onlyOwner {
        address oldOwner = _owner;
        _owner = newOwner;
        emit logOwnerChange(oldOwner, _owner);
    }

    function good2(address from, address to, uint amount) external {
        require(amount <= _balance[from]);
        require(to != address(0));

        _balance[from] = _balance[from] - amount;
        _balance[to] = _balance[to] + amount;
        logBalanceChange(from, to, amount);
    }

    function bad1(address newOwner) external onlyOwner {
        address oldOwner = _owner;
        _owner = newOwner; //leak
    }

    function bad2(address from, address to, uint amount) external {
        require(amount <= _balance[from]);
        require(to != address(0));

        _balance[from] = _balance[from] - amount; //leak
        _balance[to] = _balance[to] + amount; //leak
    }
}
