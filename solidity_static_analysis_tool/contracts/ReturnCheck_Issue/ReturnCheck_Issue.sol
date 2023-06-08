pragma solidity ^0.8.17;

contract Test {
    mapping(address => uint256) balance;

    function mint(address _to, uint256 _amount) external {
        balance[_to] += _amount;
    }

    function good1(
        address _to,
        uint256 _amount
    ) external payable returns (bool) {
        (bool success, bytes memory data) = payable(_to).call{value: msg.value}(
            ""
        );
        return success;
    }

    function good2(address _to) external returns (uint256) {
        uint256 balanceOfTo = balance[_to];
        return balanceOfTo;
    }

    function good3(address _to) external returns (uint) {
        uint balanceOfTo = balance[_to];
        return balanceOfTo;
    }

    function good4() external returns (address) {
        return msg.sender;
    }

    function bad1(
        address _to,
        uint256 _amount
    ) external payable returns (bool) {
        //leak
        (bool success, bytes memory data) = payable(_to).call{value: msg.value}(
            ""
        );
    }

    function bad2(address _to) external returns (uint256) {
        //leak
        uint256 balanceOfTo = balance[_to];
    }

    function bad3(address _to) external returns (uint) {
        //leak
        uint balanceOfTo = balance[_to];
    }

    function bad4() external returns (address) {
        //leak
    }
}
