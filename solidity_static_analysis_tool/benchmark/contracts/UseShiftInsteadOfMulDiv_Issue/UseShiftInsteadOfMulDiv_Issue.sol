pragma solidity ^0.8.0;

contract Test1 {
    function bad1(uint256 m) external returns (uint256) {
        uint8 a = 4;
        return m / a; //leak
    }
}

contract Test2 {
    function good(uint256 m) external returns (uint256) {
        return m >> 2;
    }
}

contract Test3 {
    function bad2(uint256 m) external returns (uint256) {
        return m * 4; //leak
    }
}

contract Test4 {
    function good(uint256 m) external returns (uint256) {
        return m << 2;
    }
}

contract Test5 {
    function good1(uint256 m) external returns (uint256) {
        return m / 10000;
    }

    function good2(uint256 m) external returns (uint256) {
        return m / 1000000000000;
    }

    function good3(uint256 _newPrice) external returns (uint256 price) {
        price = _newPrice * (1 ether);
    }

    function good4(
        uint256 amount,
        uint32 tax,
        uint32 taxDecimals_
    ) external pure returns (uint256) {
        return (amount * tax) / (10 ** taxDecimals_) / (10 ** 2);
    }
}
