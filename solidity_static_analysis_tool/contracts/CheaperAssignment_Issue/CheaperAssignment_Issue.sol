pragma solidity ^0.8.0;

contract Test {
    uint256[4] balance = [2, 3, 4, 5];

    function good1() external {
        for (uint i = 0; i < 4; ++i) {
            balance[i] += 1;
        }
    }

    function bad1() external {
        for (uint i = 0; i < 4; ++i) {
            balance[i] = balance[i] + 1; //leak
        }
    }

    function good2() external {
        for (uint i = 0; i < 4; ++i) {
            balance[i] -= 1;
        }
    }

    function bad2() external {
        for (uint i = 0; i < 4; ++i) {
            balance[i] = balance[i] - 1; //leak
        }
    }

    function good3() external {
        uint256[4] memory arr = [
            uint256(2),
            uint256(3),
            uint256(4),
            uint256(5)
        ];
        for (uint i = 0; i < 4; ++i) {
            arr[i] += 1;
        }
    }

    function bad3() external {
        uint256[4] memory arr = [
            uint256(2),
            uint256(3),
            uint256(4),
            uint256(5)
        ];
        for (uint i = 0; i < 4; ++i) {
            arr[i] = arr[i] + 1; //leak
        }
    }

    function good4() external {
        uint256[4] memory arr = [
            uint256(2),
            uint256(3),
            uint256(4),
            uint256(5)
        ];
        for (uint i = 0; i < 4; ++i) {
            arr[i] -= 1;
        }
    }

    function bad4() external {
        uint256[4] memory arr = [
            uint256(2),
            uint256(3),
            uint256(4),
            uint256(5)
        ];
        for (uint i = 0; i < 4; ++i) {
            arr[i] = arr[i] - 1; //leak
        }
    }
}
