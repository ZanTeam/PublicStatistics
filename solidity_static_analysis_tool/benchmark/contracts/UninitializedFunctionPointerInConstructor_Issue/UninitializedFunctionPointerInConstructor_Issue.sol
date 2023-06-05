pragma solidity >=0.5.0 <0.5.7;

interface ITest {
    function f2(uint256) external returns (uint256);
}

contract Test is ITest {
    function f2(uint256 i) external returns (uint256) {
        return (i);
    }
}

contract Good {
    constructor(ITest t) public {
        function(uint256) internal returns (uint256) a = f1;
        a(10);
        function(uint256) external returns (uint256) b;
        b = t.f2;
        b(10);
    }

    function f1(uint256 x) internal pure returns (uint256) {
        return x;
    }
}

contract Bad {
    constructor() public {
        function(uint256) internal returns (uint256) a; //leak
        a(10);
        function(uint256) external returns (uint256) b; //leak
        b(10);
    }
}
