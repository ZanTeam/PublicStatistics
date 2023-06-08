pragma solidity 0.5.12;

import {A} from "./A.sol";

contract Test is A {
    function test() public view returns (string memory mem) {
        return "Hello world!";
    }
}
