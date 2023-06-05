pragma solidity ^0.8.1;

import "./importFiles/test_safemath.sol";
import "./importFiles/test_address.sol";

contract Good1 {
    using SafeMath for uint256;
    using Address for address;

    function func1(address to) public {
        if (to.isContract()) {}
    }

    function func2(uint a) public returns (uint) {
        return a.add(1);
    }
}
