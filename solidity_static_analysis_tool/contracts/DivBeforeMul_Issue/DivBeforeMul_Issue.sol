pragma solidity 0.4.24;

library SafeMath {
    function mul(uint256 a, uint256 b) internal constant returns (uint256) {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal constant returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }
}

contract Test {
    using SafeMath for uint256;

    uint a1 = 1;
    uint a2 = 2;
    uint a3 = 3;

    function bad0() returns (uint) {
        uint a = (a1 / a2) * a3; //leak
        return a;
    }

    function bad1() {
        if (a1 * (a2 / a3) >= 1) { //leak
            //do something
        }
    }

    function bad2() {
        uint a = (a1.div(a2)).mul(a3); //leak
    }

    function bad3() {
        if (a1.mul(a2 / a3) >= 1) { //leak
            //do something
        }
    }

    function good0() {
        uint a = (a1 * a3) / a2;
    }

    function good1() {
        if ((a1 * a2) / a3 >= 1) {
            //do something
        }
    }

    function good2() {
        uint a = a1.mul(a3).div(a2);
    }

    function good3() {
        if ((a1.mul(a2)) / a3 >= 1) {}
    }
}
