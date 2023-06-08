pragma solidity ^0.8.1;

import "./importFiles/test_safemath.sol"; //leak
import "./importFiles/test_address.sol";

contract Bad1 {
    using SafeMath for uint256;
    using Address for address;

    function func1(address to) public {
        if (to.isContract()) {}
    }
}
