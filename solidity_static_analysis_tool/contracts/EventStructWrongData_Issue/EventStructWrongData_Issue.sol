pragma solidity 0.4.17;
pragma experimental ABIEncoderV2;

library LibName {
    struct StructName {
        bytes32 myBytes;
        address myAddress;
    }
}

contract Test {
    event Loggy(uint256 indexed myNumber, LibName.StructName myThing);

    function bad1(address a) public {
        LibName.StructName memory test = LibName.StructName("", a);
        Loggy(0, test); //leak
    }
}
