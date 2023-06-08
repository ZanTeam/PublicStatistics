pragma solidity ^0.4.9;

contract Test {
    uint32 bad1 = 0X12345678; //leak

    function callOther(address _to, uint256 amount) internal {
        _to.call.value(amount)("");
    }

    function good1() public {
        uint32 hexStr = 0x12345678;
        address addr = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    }

    function good2() public {
        bytes memory data = hex"5B38Da6a701c568545dCfcB03FcB875f56beddC4";
    }

    function bad2() public {
        uint32 hexStr = 0X12345678; //leak
        address addr;
        addr = 0X5B38Da6a701c568545dCfcB03FcB875f56beddC4; //leak
    }

    function bad3() public {
        address addr;
        callOther(0X5B38Da6a701c568545dCfcB03FcB875f56beddC4, 10); //leak
        callOther(addr, 10);
    }
}
