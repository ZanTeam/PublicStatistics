pragma solidity ^0.8.0;

//import "./ILandSplit.sol";

interface IGoodOne {
    function func1(uint256 a, uint256 b) external view returns (uint256);
}

interface ICoversion {
    function func1(int256 a, int256 b) external view returns (int256);
}

interface ILandRegistry {
    function func1(uint256 a, uint256 b) external view returns (uint256);
}

interface OtherInterface {
    function func2(int256 a, int256 b) external view returns (int256);
}

contract GoodOne is
    IGoodOne,
    OtherInterface //no leak
{
    function func1(
        uint256 a,
        uint256 b
    ) external view override returns (uint256) {
        return a + b;
    }

    function func2(int256 a, int256 b) external view override returns (int256) {
        return a - b;
    }
}

contract Conversion { //leak
    function func1(int256 a, int256 b) public view override returns (int256) {
        return a - b;
    }
}

contract LandRegistry { //leak
    function func1(
        uint256 a,
        uint256 b
    ) public view override returns (uint256) {
        return a + b;
    }
}

contract LandSplit { //leak
    function func1(
        uint256 a,
        uint256 b
    ) public view override returns (uint256) {
        return a + b;
    }
}
