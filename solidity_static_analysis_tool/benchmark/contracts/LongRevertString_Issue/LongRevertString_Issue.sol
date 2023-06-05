pragma solidity ^0.8.17;

contract Test {
    function good1(bool success) external {
        require(success, "helloworldhelloworldhelloworldaa"); // 32 bytes
    }

    function good2(bool success) external {
        require(success, "helloworldhelloworldhelloworld"); // 30 bytes
    }

    function good3() external {
        revert("helloworldhelloworldhelloworldaa"); // 32 bytes
    }

    function good4() external {
        revert("helloworldhelloworldhelloworld"); // 30 bytes
    }

    function bad1(bool success) external {
        require(success, "helloworldhelloworldhelloworldabc"); // 33 bytes //leak
    }

    function bad2() external {
        revert("helloworldhelloworldhelloworldabc"); // 33 bytes //leak
    }
}
