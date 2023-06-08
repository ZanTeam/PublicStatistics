pragma solidity 0.8.4;

contract test {
    mapping(address => uint) balances;
    mapping(address => uint) nonces;

    event Transfer(address, address, uint256);

    function bad1(
        address _from,
        address _to,
        uint256 _value,
        uint256 _fee,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    ) external returns (bool) {
        if (balances[_from] < _fee + _value || _fee > _fee + _value) revert();

        uint256 nonce = nonces[_from];
        bytes32 h = keccak256(
            abi.encodePacked(_from, _to, _value, _fee, nonce, address(this))
        );
        address signer = ecrecover(h, _v, _r, _s); //leak
        if (_from != signer) revert();

        if (
            balances[_to] + _value < balances[_to] ||
            balances[msg.sender] + _fee < balances[msg.sender]
        ) revert();
        balances[_to] += _value;
        emit Transfer(_from, _to, _value);

        balances[msg.sender] += _fee;
        emit Transfer(_from, msg.sender, _fee);

        balances[_from] -= _value + _fee;
        nonces[_from] = nonce + 1;
        return true;
    }

    function bad2(
        address _from,
        address _to,
        uint256 _value,
        uint256 _fee,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    ) external returns (bool) {
        if (balances[_from] < _fee + _value || _fee > _fee + _value) revert();

        uint256 nonce = nonces[_from];
        bytes32 h = keccak256(
            abi.encodePacked(_from, _to, _value, _fee, nonce, address(this))
        );
        address signer;
        signer = ecrecover(h, _v, _r, _s); //leak
        if (_from != signer) revert();

        if (
            balances[_to] + _value < balances[_to] ||
            balances[msg.sender] + _fee < balances[msg.sender]
        ) revert();
        balances[_to] += _value;
        emit Transfer(_from, _to, _value);

        balances[msg.sender] += _fee;
        emit Transfer(_from, msg.sender, _fee);

        balances[_from] -= _value + _fee;
        nonces[_from] = nonce + 1;
        return true;
    }

    function bad3(
        address _from,
        address _to,
        uint256 _value,
        uint256 _fee,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    ) external returns (bool) {
        if (balances[_from] < _fee + _value || _fee > _fee + _value) revert();

        uint256 nonce = nonces[_from];
        bytes32 h = keccak256(
            abi.encodePacked(_from, _to, _value, _fee, nonce, address(this))
        );
        if (_from != ecrecover(h, _v, _r, _s)) revert(); //leak

        if (
            balances[_to] + _value < balances[_to] ||
            balances[msg.sender] + _fee < balances[msg.sender]
        ) revert();
        balances[_to] += _value;
        emit Transfer(_from, _to, _value);

        balances[msg.sender] += _fee;
        emit Transfer(_from, msg.sender, _fee);

        balances[_from] -= _value + _fee;
        nonces[_from] = nonce + 1;
        return true;
    }

    function bad4(
        address _from,
        address _to,
        uint256 _value,
        uint256 _fee,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    ) external returns (bool) {
        if (balances[_from] < _fee + _value || _fee > _fee + _value) revert();

        uint256 nonce = nonces[_from];
        bytes32 h = keccak256(
            abi.encodePacked(_from, _to, _value, _fee, nonce, address(this))
        );
        require(
            _from == ecrecover(h, _v, _r, _s),
            "signer should be equal to _from"
        ); //leak

        if (
            balances[_to] + _value < balances[_to] ||
            balances[msg.sender] + _fee < balances[msg.sender]
        ) revert();
        balances[_to] += _value;
        emit Transfer(_from, _to, _value);

        balances[msg.sender] += _fee;
        emit Transfer(_from, msg.sender, _fee);

        balances[_from] -= _value + _fee;
        nonces[_from] = nonce + 1;
        return true;
    }

    function bad5(
        address _from,
        address _to,
        uint256 _value,
        uint256 _fee,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    ) external view returns (address) {
        if (balances[_from] < _fee + _value || _fee > _fee + _value) revert();

        uint256 nonce = nonces[_from];
        bytes32 h = keccak256(
            abi.encodePacked(_from, _to, _value, _fee, nonce, address(this))
        );
        return ecrecover(h, _v, _r, _s); //leak
    }
}
