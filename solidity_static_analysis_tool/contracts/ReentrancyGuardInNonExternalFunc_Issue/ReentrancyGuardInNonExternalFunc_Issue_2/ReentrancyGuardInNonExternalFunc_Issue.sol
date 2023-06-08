pragma solidity 0.8.0;

import "./ReentrancyGuard.sol";

contract Test is ReentrancyGuard {
    function bad1(bool success) public nonReentrant returns (bool) { //leak
        return success;
    }

    function callBad2(bool success) public returns (bool) {
        return bad2(success);
    }

    function bad2(bool success) internal nonReentrant returns (bool) { //leak
        return success;
    }

    function callBad3(bool success) external returns (bool) {
        return bad3(success);
    }

    function bad3(bool success) private nonReentrant returns (bool) { //leak
        return success;
    }

    function good1(bool success) external nonReentrant returns (bool) {
        return success;
    }
}
