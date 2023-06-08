pragma solidity 0.4.25;

contract Test {
    address public owner;

    uint256 public totalSupply;

    mapping(address => uint256) public balances;

    mapping(address => bool) public candidates;

    address[] public addrList;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor(address candidate, uint256 amount) public {
        totalSupply = 1000;
        owner = msg.sender;
        balances[candidate] += amount;
        addrList.push(candidate);
    }

    function good1(address a) external onlyOwner {
        require(candidates[a]);
        (bool ret, ) = a.call("");
        require(ret);
    }

    function good2(uint256 a) external {
        (bool ret, ) = addrList[a].call("");
        bool retTmp = ret;
        require(retTmp);
    }

    function good3(int256 test) external {
        bool retTmp = retHelper(1);
        require(retTmp);
    }

    function retHelper(uint256 a) internal returns (bool) {
        (bool ret, ) = addrList[a].call("");
        bool retTmp = ret;
        return retTmp;
    }

    function good4(uint256 a) external {
        (bool ret, ) = addrList[a].call("");
        requireHelper(ret);
    }

    function requireHelper(bool ret) internal {
        require(ret);
    }

    function good5(uint256 a) external {
        if (addrList[a].call("")) {
            addrList[0] = msg.sender;
        }
    }

    function bad1(address a) external onlyOwner {
        a.call(""); //leak
    }

    function bad2(address a) external onlyOwner {
        (bool ret, ) = a.call(""); //leak
        bool retTmp = ret;
    }

    function bad3(int256 test) external {
        bool retTmp = retHelper(1);
        (bool rettest, ) = addrList[0].call(""); //leak
        require(retTmp);
    }
}

contract Test2 {
    function bad4(address dst) external payable {
        dst.call.value(msg.value)(""); //leak
    }

    function bad5(address dst) external payable {
        dst.send(msg.value); //leak
    }

    function good6(address dst) external payable {
        require(dst.call.value(msg.value)());
        require(dst.call.value(100).gas(35000)());
    }

    function good7(address dst) external payable {
        require(dst.send(msg.value));
    }

    function good8(address dst) external payable {
        bool res = dst.send(msg.value);
        if (!res) {
            emit Failed(dst, msg.value);
        }
    }

    event Failed(address, uint256);
}

contract Test3 {
    address lib;

    constructor(address _library) public {
        lib = _library;
    }

    function() public {
        require(lib.delegatecall(msg.data));
    }
}

contract Test4 {
    function bad6(address dst) external payable {
        dst.send(msg.value); //leak
    }

    function bad7(address dst, bytes data) external {
        address(dst).delegatecall(abi.encodePacked(data, uint(1))); //leak
    }

    function good9(address dst) external payable {
        require(dst.send(msg.value));
    }

    function good10(address dst) external payable {
        bool res = dst.send(msg.value);
        if (!res) {
            emit Failed(dst, msg.value);
        }
    }

    event Failed(address, uint);

    function validate(bool res) internal {
        if (!res) {
            revert();
        }
    }

    function good11(address dst) external {
        bool res = dst.send(msg.value);
        validate(res);
    }
}
