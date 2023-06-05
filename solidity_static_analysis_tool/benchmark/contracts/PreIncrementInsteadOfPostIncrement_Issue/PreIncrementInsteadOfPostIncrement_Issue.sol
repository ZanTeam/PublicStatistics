pragma solidity ^0.8.0;

contract Test {
    function bad1() external {
        uint256 sum;
        for (uint256 i = 1; i <= 10; i++) { //leak
            sum += i;
        }
    }

    function good1() external {
        uint256 sum;
        for (uint256 i = 1; i <= 10; ++i) {
            sum += i;
        }
    }

    function bad2() external {
        uint256 sum;
        for (uint256 i = 10; i > 0; i--) { //leak
            sum += i;
        }
    }

    function good2() external {
        uint256 sum;
        for (uint256 i = 10; i > 0; --i) {
            sum += i;
        }
    }
}
