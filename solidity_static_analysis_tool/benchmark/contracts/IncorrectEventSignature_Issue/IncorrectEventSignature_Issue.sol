pragma solidity 0.5.0;
pragma experimental ABIEncoderV2;

contract AnotherContract {
    function t() public payable returns (bool) {
        return true;
    }
}

library LTest {
    event log(uint a, AnotherContract owner); //leak

    function bad1(address test) public {
        emit log(0, AnotherContract(test));
    }
}

contract TestMain {
    function test(address tc) public {
        LTest.bad1(tc);
    }
}
