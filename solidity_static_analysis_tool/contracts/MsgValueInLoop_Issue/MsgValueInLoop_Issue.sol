pragma solidity ^0.8.0;

contract Test {
    mapping(address => uint256) balances;

    function bad1(address[] memory receivers) public payable {
        for (uint256 i = 0; i < receivers.length; i++) {
            balances[receivers[i]] += msg.value; //leak
        }
    }

    function bad2(address[] memory receivers) public payable {
        for (uint256 i = 0; i < receivers.length; i++) {
            bad2_internal(receivers[i]);
        }
    }

    function bad2_internal(address a) internal {
        balances[a] += msg.value; //leak
    }

    function bad3(address[] memory receivers) public payable {
        for (uint256 i = 0; i < 2; i++) {
            for (uint256 j = 0; j < receivers.length; j++) {
                balances[receivers[j]] += msg.value; //leak
            }
        }
    }

    function bad4(address[] memory receivers) public payable {
        for (uint256 i = 0; i < receivers.length; i++) {
            balances[receivers[i]] = msg.value; //leak
        }
    }

    function bad5(address[] memory receivers) public payable {
        for (uint256 i = 0; i < receivers.length; i++) {
            balances[receivers[i]] = balances[receivers[i]] + msg.value; //leak
        }
    }

    function good1(address[] memory receivers) public payable {
        uint256 tmp = msg.value;
        for (uint256 i = 0; i < receivers.length; i++) {
            balances[receivers[i]] = balances[receivers[i]] + tmp;
        }
    }
}
