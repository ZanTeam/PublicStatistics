pragma solidity 0.8.10;

contract bad1 {
    uint128 storage1;
    uint64 storage2;
    uint64 storage3;
    uint256 storage4;

    function test() external view {
        uint128 a; //leak
    }
}

contract bad2 {
    uint256 storage1;
    uint64 storage2; //leak
}

contract bad3 {
    uint128 storage1; //leak
    uint256 storage2;
}

contract bad4 {
    uint128 storage1;
    uint64 storage2;
    uint256 storage3;
    uint8 storage4; //leak
}

contract bad5 {
    uint128 storage1;
    uint64 storage2;
    uint storage3;
    uint8 storage4; //leak
}

contract bad6 {
    uint128 storage1;
    uint64 storage2;
    uint64 storage3;
    uint256 storage4;

    function test() external view {
        uint128 a; //leak
        uint128 b; //leak
    }
}

contract good1 {
    uint128 storage1;
    uint64 storage2;
    uint64 storage3;
    uint256 storage4;
}

contract good2 {
    uint128 storage1;
    uint64 storage2;
    uint64 storage3;
    uint256 storage4;

    function test() external view {
        uint a;
    }
}

contract good3 {
    uint256 storage4;
    uint128 storage1;
    uint64 storage2;
    uint64 storage3;

    function test() external view {
        uint a;
    }
}

contract good4 {
    uint256 immutable a;
    uint64 immutable b;

    constructor() {
        a = 10;
        b = 20;
    }
}

contract good5 {
    uint256 constant a = 10;
    uint64 constant b = 20;
}
