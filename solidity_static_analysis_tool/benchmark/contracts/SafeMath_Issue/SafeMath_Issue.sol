pragma solidity 0.7.0;

contract Test1 {
    using SafeMath for uint256;

    event logUint(uint256);

    function good1(uint256 a, uint256 b) external returns (uint256 x) {
        x = a.add(b);
        emit logUint(x);
    }

    function good2(uint256 a, uint256 b) external returns (uint256 x) {
        x = a.sub(b);
        emit logUint(x);
    }

    function good3(uint256 a, uint256 b) external returns (uint256 x) {
        x = a.mul(b);
        emit logUint(x);
    }
}

contract Test2 {
    event logUint(uint256);

    function bad1(uint256 a, uint256 b) external returns (uint256 x) {
        x = a + b; //leak
        emit logUint(x);
    }

    function bad2(uint256 a, uint256 b) external returns (uint256 x) {
        x = a - b; //leak
        emit logUint(x);
    }

    function bad3(uint256 a, uint256 b) external returns (uint256 x) {
        x = a * b; //leak
        emit logUint(x);
    }
}

contract Test3 {
    event logUint(uint256);
    uint256 x;

    function bad1(uint256 a) external {
        x += a; //leak
        emit logUint(x);
    }

    function bad2(uint256 a) external {
        x -= a; //leak
        emit logUint(x);
    }

    function bad3(uint256 a) external {
        x *= a; //leak
        emit logUint(x);
    }
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        return a - b;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }
}
