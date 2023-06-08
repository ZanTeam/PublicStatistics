pragma solidity 0.8.0;

contract Test {
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private constant MAX_SUPPLY =
        10_000_000_000_000_000_000_000_000_000; //  10B Token
    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;

    event Transfer(address indexed from, address indexed to, uint256 value);

    constructor(address tokenHolder) {
        _name = "Token";
        _symbol = "A";
        _decimals = 18;
        _mint(tokenHolder, MAX_SUPPLY);
    }

    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "mint to the zero address");

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    function good1(address addr1, address addr2) external {
        require(addr1 != address(0x0), "addr1 should not be zero address");
        require(
            addr2 != 0x0000000000000000000000000000000000000000,
            "addr2 should not be zero address"
        );
        addr1.call{value: 1}("");
        addr2.call{value: 1}("");
    }

    function good2(address addr1, address addr2) external {
        if (addr1 != address(0x0)) {
            revert("addr1 should not be zero address");
        }

        if (addr2 != 0x0000000000000000000000000000000000000000) {
            revert("addr2 should not be zero address");
        }

        addr1.call{value: 1}("");
        addr2.call{value: 1}("");
    }

    function good3(address addr1, address addr2) external {
        if (address(0) != addr1) {
            revert("addr1 should not be zero address");
        }

        if (addr2 != 0x0000000000000000000000000000000000000000) {
            revert("addr2 should not be zero address");
        }

        addr1.call{value: 1}("");
        addr2.call{value: 1}("");
    }

    function bad1(address addr1, address addr2) external { //leak
        addr1.call{value: 1}("");
        addr2.call{value: 1}("");
    }

    function bad2(address addr1, address addr2) external { //leak
        if (addr1 != address(0x0)) {
            revert("addr1 should not be zero address");
        }

        addr1.call{value: 1}("");
        addr2.call{value: 1}("");
    }

    function bad3(address addr1, address addr2) external { //leak
        if (addr2 != 0x0000000000000000000000000000000000000000) {
            revert("addr2 should not be zero address");
        }

        addr1.call{value: 1}("");
        addr2.call{value: 1}("");
    }

    function good4(
        address to,
        address from,
        uint256 value
    ) external returns (bool) {
        bool isSuccess = interCalled1(to, from, value);
        return isSuccess;
    }

    function interCalled1(
        address to1,
        address from1,
        uint256 value
    ) internal returns (bool) {
        require(
            to1 != address(0) || from1 != address(0) || to1 != address(this)
        );
        uint256 balance = _balances[msg.sender];

        require(balance >= value, "");

        _balances[msg.sender] = balance - value;
        _balances[to1] += value;

        return true;
    }
}
