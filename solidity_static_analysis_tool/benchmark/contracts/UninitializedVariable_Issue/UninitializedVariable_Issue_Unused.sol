pragma solidity ^0.8.0;

contract Test {
    address owner = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4; //leak
    address addr;
    uint256 m; //leak
    address constant proxy = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
    uint256 immutable totalSupply;

    constructor(uint256 x) {
        totalSupply = x;
    }

    function good() external payable {
        addr = msg.sender;
        payable(addr).transfer(msg.value);
    }
}
