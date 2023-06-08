pragma solidity ^0.4.24;

contract Bad {
    function test() public constant { //leak
        bytes32 blockHash = block.blockhash(0); //leak

        bytes32 hashofhash = sha3(blockHash); //leak

        uint gas = msg.gas; //leak

        if (gas == 0) {
            throw; //leak
        }

        address(this).callcode(); //leak

        var a = [1, 2, 3]; //leak

        var (x, y, z) = (false, "test", 0); //leak

        suicide(address(0)); //leak
    }
}

contract Good {
    function test() public view {
        bytes32 blockHash = blockhash(1);

        bytes32 hashofhash = keccak256(blockHash);

        uint gas = gasleft();

        if (gas == 0) {
            revert();
        }

        address(this).delegatecall();

        uint8[3] memory a = [1, 2, 3];

        (bool x, string memory y, uint8 z) = (false, "test", 0);

        selfdestruct(address(0));
    }
}
