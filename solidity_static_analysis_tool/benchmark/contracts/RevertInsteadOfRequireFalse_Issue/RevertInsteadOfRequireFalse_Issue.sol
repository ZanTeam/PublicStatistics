pragma solidity ^0.8.0;

contract Test {
    function bad() external view {
        require(false, "Not allowed to call function bad"); //leak
    }

    function good1() external view {
        revert("Not allowed to call function bad");
    }

    function good2(uint256 a, uint256 b) external view {
        require(a > b, "a should bigger than b");
    }
}
