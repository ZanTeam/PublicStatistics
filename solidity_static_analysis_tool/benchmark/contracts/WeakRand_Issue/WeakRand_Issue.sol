pragma solidity ^0.5.0;

contract Test {
    uint public answer;

    function bad1() external payable {
        uint a;
        if ((a = now % 2) > 0) { //leak
            uint fee = msg.value / 10;
            msg.sender.transfer(msg.value * 2 - fee);
        }
    }

    function bad2(uint salt) external payable {
        uint val = block.timestamp + salt;
        if (val % 100 > 95) { //leak
        }
    }

    function bad3(uint _mod) public view returns (uint) {
        return
            uint(
                keccak256(
                    abi.encodePacked(
                        block.timestamp,
                        block.difficulty,
                        msg.sender
                    )
                )
            ) % _mod; //leak
    }

    function bad4() external payable {
        if (now % 2 > 0) { //leak
            uint fee = msg.value / 10;
            msg.sender.transfer(msg.value * 2 - fee);
        }
    }

    function bad5(uint256 x) external returns (uint) {
        return uint(keccak256(abi.encodePacked(blockhash(x - 1)))); //leak
    }

    function bad6(uint256 x) external returns (uint) {
        return uint(keccak256(abi.encodePacked(block.number - 1))); //leak
    }

    function bad7() external {
        answer = uint(keccak256(abi.encodePacked(now))); //leak
    }
}
