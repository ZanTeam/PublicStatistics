pragma solidity 0.4.20;

contract Test {
    function good1() public payable returns (uint) {
        return msg.value;
    }

    function good2() internal returns (uint) {
        return msg.value;
    }

    function good3() public returns (uint) {
        return good3_internal();
    }

    function good3_internal() internal returns (uint) {
        return msg.value;
    }

    function good4() private {
        if (msg.value == 0) {
            revert();
        }
    }

    function bad1() external {
        if (msg.value == 0) { //leak
            revert();
        }
    }
}

library TestLib {
    function good1() external {
        if (msg.value == 0) {
            revert();
        }
    }
}
