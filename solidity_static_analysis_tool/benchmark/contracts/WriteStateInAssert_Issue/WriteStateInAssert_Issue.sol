pragma solidity 0.4.20;

contract Test {
    uint _a;

    function bad1() public {
        assert((_a += 1) > 5); //leak
    }

    function bad2(uint256 a) public {
        assert((_a += a) > 5); //leak
    }

    function bad3() public {
        assert(bad3_internal()); //leak
    }

    function bad3_internal() public returns (bool) {
        return (_a += 1) > 5;
    }

    function good1(uint256 a) public {
        assert(a > 5);
    }

    function good2(uint256 a) public {
        assert((a += 1) > 5);
    }

    function good3(uint256 a) public {
        require((_a += 1) == a);
    }
}
