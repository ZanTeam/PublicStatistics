pragma solidity ^0.8.0;

contract Test {
    constructor() payable {}

    function good1() external returns (uint) {
        assembly {
            let result := selfbalance()
            mstore(0x0, result)
            return(0x0, 32)
        }
    }

    function good2(address a) external returns (uint) {
        assembly {
            let result := balance(a)
            mstore(0x0, result)
            return(0x0, 32)
        }
    }

    struct AddressData {
        uint64 balance;
        uint64 numberMinted;
        uint64 numberBurned;
        uint64 aux;
    }

    mapping(address => AddressData) private _addressData;

    function good3(address from) external {
        _addressData[from].balance -= 1;
    }

    function bad1() external returns (uint) {
        return address(this).balance; //leak
    }

    function bad2(address a) external returns (uint) {
        return a.balance; //leak
    }

    function bad3(address a) external returns (uint) {
        uint256 result = 5 + a.balance; //leak
        return result;
    }

    function bad4(address a) external returns (uint) {
        uint256 result = a.balance; //leak
        return result + 5;
    }

    function bad5(address a) external returns (uint) {
        if (a.balance > 5) { //leak
            return a.balance; //leak
        } else {
            return 0;
        }
    }

    function bad6(address a) external returns (uint result) {
        result = a.balance; //leak
    }

    function bad7(address a) external returns (bool result) {
        result = bad7_internal(a.balance); //leak
    }

    function bad7_internal(uint256 x) internal returns (bool) {
        if (x > 5) {
            return true;
        }
        return false;
    }

    function bad8() external returns (uint) {
        uint256 result = 5 + address(this).balance; //leak
        return result;
    }

    function bad9() external returns (uint) {
        uint256 result = address(this).balance; //leak
        return result + 5;
    }

    function bad10() external returns (uint) {
        if (address(this).balance > 5) { //leak
            return address(this).balance; //leak
        } else {
            return 0;
        }
    }

    function bad11() external returns (uint result) {
        result = address(this).balance; //leak
    }

    function bad12() external returns (bool result) {
        result = bad12_internal(address(this).balance); //leak
    }

    function bad12_internal(uint256 x) internal returns (bool) {
        if (x > 5) {
            return true;
        }
        return false;
    }

    fallback() external payable {}

    receive() external payable {}

    function bad13() public view returns (uint, uint, uint) {
        return (address(this).balance, 5, 10); //leak
    }

    function bad14() public payable {
        (bool hs, ) = payable(0x943590A42C27D08e3744202c4Ae5eD55c2dE240D).call{
            value: (address(this).balance * 5) / 100,
            gas: 2000
        }(""); //leak
        require(hs);
    }

    struct DataStruct {
        uint64 balance;
        address minter;
    }

    DataStruct[] dataStruct;

    function good4(uint amount) external {
        if (dataStruct.length > 0) {
            require(
                amount < dataStruct[dataStruct.length - 1].balance,
                "insufficient balance"
            );
        }
    }
}
