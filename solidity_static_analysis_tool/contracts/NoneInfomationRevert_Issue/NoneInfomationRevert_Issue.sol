pragma solidity ^0.8.17;

contract Test {
    mapping(address => uint256) balance;

    event Mint(address);

    function good1(address _to) external payable {
        if (msg.value == 0) {
            revert("should transfer some money in");
        }
        balance[_to] += 1;
        emit Mint(_to);
    }

    function good2(address _to) external payable {
        require(msg.value > 0, "should transfer some money in");
        balance[_to] += 1;
        emit Mint(_to);
    }

    function bad1(address _to) external payable {
        if (msg.value == 0) {
            revert(); //leak
        }
        balance[_to] += 1;
        emit Mint(_to);
    }

    function bad2(address _to) external payable {
        require(msg.value > 0); //leak
        balance[_to] += 1;
        emit Mint(_to);
    }

    function bad3(address _to) external payable {
        if (msg.value == 0) {
            revert(""); //leak
        }
        balance[_to] += 1;
        emit Mint(_to);
    }

    function bad4(address _to) external payable {
        require(msg.value > 0, ""); //leak
        balance[_to] += 1;
        emit Mint(_to);
    }
}
