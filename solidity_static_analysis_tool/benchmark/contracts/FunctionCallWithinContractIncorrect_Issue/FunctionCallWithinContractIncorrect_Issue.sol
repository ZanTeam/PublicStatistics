pragma solidity ^0.8.0;

contract Test {
    address public owner;
    mapping(address => bool) public whitelist;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "sender should be owner");
        _;
    }

    function setWhiteList(address a) external onlyOwner {
        whitelist[a] = true;
    }

    function called1(address payable recipient, uint256 num) public {
        if (whitelist[recipient]) {
            num += 10;
        }
        recipient.call{value: num}("");
    }

    function bad1(address payable recipient, uint256 num) external payable {
        require(msg.value >= num, "insufficient ether");
        called1(recipient, num); //leak
    }

    function called2(address payable recipient, uint256 num) internal {
        if (whitelist[recipient]) {
            num += 10;
        }
        recipient.call{value: num}("");
    }

    function good1(address payable recipient, uint256 num) external payable {
        require(msg.value >= num, "insufficient ether");
        called2(recipient, num);
    }

    function called3(address payable recipient, uint256 num) private {
        if (whitelist[recipient]) {
            num += 10;
        }
        recipient.call{value: num}("");
    }

    function good2(address payable recipient, uint256 num) external payable {
        require(msg.value >= num, "insufficient ether");
        called3(recipient, num);
    }

    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function ownerWho() public view virtual returns (address) {
        return owner;
    }

    modifier onlyOwner1() {
        require(ownerWho() == _msgSender(), "caller is not the owner");
        _;
    }

    function good3(
        address payable recipient,
        uint256 num
    ) external payable onlyOwner1 {
        require(msg.value >= num, "insufficient ether");
        recipient.call{value: num}("");
    }

    function bad2(address payable recipient, uint256 num) external payable {
        require(msg.value >= num, "insufficient ether");
        require(ownerWho() == _msgSender(), "caller is not the owner"); //leak
        recipient.call{value: num}("");
    }
}
