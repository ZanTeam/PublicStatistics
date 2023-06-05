pragma solidity >=0.8.5;

contract Test1 {
    address public owner;
    uint256 public totalSupply;
    mapping(address => uint256) balances;
    mapping(address => bool) whiteList;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner can call the function");
        _;
    }

    function setWhiteList(address addr) external onlyOwner {
        whiteList[addr] = true;
    }

    function verifySender(address addr) internal view returns (bool) {
        return whiteList[addr];
    }

    function update(uint256 supply) internal {
        totalSupply += supply;
    }

    function AbsRequire(bool condition) internal pure {
        require(condition);
    }

    function good1() public {
        require(whiteList[msg.sender]);
        uint256 supply = 10;
        update(supply);
    }

    function good2() public {
        require(verifySender(msg.sender));
        uint256 supply = 10;
        update(supply);
    }

    function good3() public {
        AbsRequire(verifySender(msg.sender));
        uint256 supply = 10;
        update(supply);
    }

    function good4() public onlyOwner {
        uint256 supply = 10;
        totalSupply += supply;
    }

    function good5() public {
        require(verifySender(msg.sender));
        uint256 supply = 10;
        totalSupply += supply;
    }

    function good6(uint amount, address addr) public {
        balances[msg.sender] -= amount;
        balances[addr] += amount;
    }

    function bad1() public { //leak
        uint256 supply = 10;
        totalSupply += supply;
    }

    function bad2() public { //leak
        if (block.number > 15000000) {
            if (!verifySender(msg.sender)) {
                revert();
            }
        }
        uint256 supply = 10;
        totalSupply += supply;
    }

    function bad3(uint amount) public { //leak
        update(amount);
    }

    function bad4(address addr, uint amount) public { //leak
        balances[addr] += amount;
    }
}

interface IGovernance {
    function hasRole(
        bytes32 role,
        address account
    ) external view returns (bool);
}

contract Test2 {
    error OnlyManager();

    IGovernance public gov;
    bytes32 private constant MANAGER_ROLE = keccak256("MANAGER_ROLE");

    modifier onlyManager() {
        if (!gov.hasRole(MANAGER_ROLE, msg.sender)) revert OnlyManager();
        _;
    }

    function good(IGovernance _newGov) external onlyManager {
        gov = _newGov;
    }
}
