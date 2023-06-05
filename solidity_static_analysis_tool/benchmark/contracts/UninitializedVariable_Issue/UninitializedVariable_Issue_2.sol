pragma solidity ^0.4.24;

contract UninitializedFor {
    uint256 x;

    function bad0() {
        for (uint256 i; i < 5; i++) { //leak
            x += i;
        }
    }

    function good0() {
        for (uint256 i = 0; i < 5; i++) {
            x += i;
        }
    }
}

contract UinitializedReturn {
    function bad1() external view returns (int256[] memory _longitudes) {
        uint256 _len = _longitudes.length; //leak
        _longitudes = new int256[](_len);
        for (uint256 i = 0; i < _len; i++) {
            _longitudes[i] = int(i);
        }
    }

    function bad2() external view returns (int256[] memory _longitudes) {
        int256[] memory arr = _longitudes; //leak
        uint256 _len = arr.length;
        _longitudes = new int256[](_len);
        for (uint256 i = 0; i < _len; i++) {
            _longitudes[i] = int(i);
        }
    }

    function bad3() external view returns (int256[] memory _longitudes) {
        uint256 _len;
        _len = _longitudes.length; //leak
        _longitudes = new int256[](_len);
        for (uint256 i = 0; i < _len; i++) {
            _longitudes[i] = int(i);
        }
    }

    function bad4() external view returns (int256[] memory _longitudes) {
        int256[] memory arr;
        arr = _longitudes; //leak
        uint _len = arr.length;
        _longitudes = new int256[](_len);
        for (uint256 i = 0; i < _len; i++) {
            _longitudes[i] = int(i);
        }
    }

    int[] count;

    function bad5() external view returns (int256[] memory _longitudes) {
        for (uint256 i = 0; i < _longitudes.length; i++) { //leak
            count.push(int(i));
        }
    }
}
