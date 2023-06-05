pragma solidity ^0.8.0;

contract Test {
    mapping(address => uint256) balances;

    function addBalance(address a) public payable {
        balances[a] += msg.value;
    }

    function bad1(address[] memory receivers) public payable {
        for (uint256 i = 0; i < receivers.length; i++) {
            address(this).delegatecall(
                abi.encodeWithSignature("addBalance(address)", receivers[i])
            ); //leak
        }
    }

    function bad2(address[] memory receivers) public payable {
        bad2_internal(receivers);
    }

    function bad2_internal(address[] memory receivers) internal {
        for (uint256 i = 0; i < receivers.length; i++) {
            address(this).delegatecall(
                abi.encodeWithSignature("addBalance(address)", receivers[i])
            ); //leak
        }
    }

    function bad3(address[] memory receivers) public payable {
        for (uint256 i = 0; i < receivers.length; i++) {
            for (uint256 j = 0; j < receivers.length; j++) {
                address(this).delegatecall(
                    abi.encodeWithSignature("addBalance(address)", receivers[i])
                ); //leak
            }
        }
    }

    function bad4(address[] memory receivers) public payable {
        for (uint256 i = 0; i < receivers.length; i++) {
            bad4_internal(receivers[i]);
        }
    }

    function bad4_internal(address receiver) internal {
        address(this).delegatecall(
            abi.encodeWithSignature("addBalance(address)", receiver)
        ); //leak
    }
}
