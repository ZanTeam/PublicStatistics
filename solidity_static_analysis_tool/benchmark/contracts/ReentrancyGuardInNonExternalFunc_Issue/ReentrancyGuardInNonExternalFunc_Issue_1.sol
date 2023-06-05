pragma solidity 0.8.0;

abstract contract ReentrancyGuard {
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    modifier nonReentrant() {
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
        _status = _ENTERED;
        _;
        _status = _NOT_ENTERED;
    }

    modifier badNonReentrant() {
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
        //        _status = _ENTERED;
        _;
        _status = _NOT_ENTERED;
    }
}

contract Test is ReentrancyGuard {
    function bad1(bool success) public nonReentrant returns (bool) { //leak
        return success;
    }

    function bad2(bool success) public nonReentrant returns (bool) { //leak
        return bad2Func(success);
    }

    function bad2Func(bool success) internal nonReentrant returns (bool) { //leak
        return success;
    }

    function callBad3(bool success) external returns (bool) {
        return bad3(success);
    }

    function bad3(bool success) private nonReentrant returns (bool) { //leak
        return success;
    }

    function good1(bool success) external nonReentrant returns (bool) {
        return success;
    }

    function good2(bool success) public badNonReentrant returns (bool) {
        return success;
    }

    constructor() nonReentrant {}
}
