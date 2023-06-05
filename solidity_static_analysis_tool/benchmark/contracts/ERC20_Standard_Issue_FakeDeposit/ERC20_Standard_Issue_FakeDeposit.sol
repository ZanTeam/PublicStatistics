pragma solidity ^0.4.23;

contract ERC20Contract {
    function totalSupply() constant returns (uint256 supply) {}

    function balanceOf(address _owner) constant returns (uint256 balance) {}

    function transfer(address _to, uint256 _value) returns (bool success) {}

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) returns (bool success) {}

    function approve(address _spender, uint256 _value) returns (bool success) {}

    function allowance(
        address _owner,
        address _spender
    ) constant returns (uint256 remaining) {}

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );
}

contract bad0 is ERC20Contract {
    function transfer(address _to, uint256 _value) returns (bool success) {
        if (balances[msg.sender] >= _value && _value > 0) {
            //leak
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            Transfer(msg.sender, _to, _value);
            return true;
        } else {
            return false;
        }
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) returns (bool success) {
        if (
            balances[_from] >= _value &&
            allowed[_from][msg.sender] >= _value &&
            _value > 0
        ) {
            //leak
            balances[_to] += _value;
            balances[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            Transfer(_from, _to, _value);
            return true;
        } else {
            return false;
        }
    }

    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(
        address _owner,
        address _spender
    ) constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;
    uint256 public totalSupply;
}

contract bad1 is ERC20Contract {
    function transfer(
        address _from,
        address _to,
        uint256 _value
    ) returns (bool success) {
        for (uint i = 0; i < 10; i++) {
            if (_value % 2 == 0) {
                if (
                    balances[_from] >= _value &&
                    allowed[_from][msg.sender] >= _value &&
                    _value > 0
                ) {
                    //leak
                    balances[_to] += _value;
                    balances[_from] -= _value;
                    allowed[_from][msg.sender] -= _value;
                    Transfer(_from, _to, _value);
                    return true;
                }
            }
        }
        return false;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) returns (bool success) {
        if (
            !(balances[_from] >= _value &&
                allowed[_from][msg.sender] >= _value &&
                _value > 0)
        ) {
            //leak
            return false;
        }
        balances[_to] += _value;
        balances[_from] -= _value;
        allowed[_from][msg.sender] -= _value;
        Transfer(_from, _to, _value);
        return true;
    }

    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(
        address _owner,
        address _spender
    ) constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;
    uint256 public totalSupply;
}

contract good0 is ERC20Contract {
    function transfer(address _to, uint256 _value) returns (bool success) {
        require(balances[msg.sender] >= _value && _value > 0);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) returns (bool success) {
        require(
            balances[_from] >= _value &&
                allowed[_from][msg.sender] >= _value &&
                _value > 0
        );
        balances[_to] += _value;
        balances[_from] -= _value;
        allowed[_from][msg.sender] -= _value;
        Transfer(_from, _to, _value);
        return true;
        return false;
    }

    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(
        address _owner,
        address _spender
    ) constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;
    uint256 public totalSupply;
}

contract good1 is ERC20Contract {
    function transfer(
        address _from,
        address _to,
        uint256 _value
    ) returns (bool success) {
        for (uint i = 0; i < 10; i++) {
            if (_value % 2 == 0) {
                require(
                    balances[_from] >= _value &&
                        allowed[_from][msg.sender] >= _value &&
                        _value > 0
                );
                balances[_to] += _value;
                balances[_from] -= _value;
                allowed[_from][msg.sender] -= _value;
                Transfer(_from, _to, _value);
                return true;
            }
        }
        return false;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) returns (bool success) {
        require(
            balances[_from] >= _value &&
                allowed[_from][msg.sender] >= _value &&
                _value > 0
        );
        balances[_to] += _value;
        balances[_from] -= _value;
        allowed[_from][msg.sender] -= _value;
        Transfer(_from, _to, _value);
        return true;
    }

    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(
        address _owner,
        address _spender
    ) constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;
    uint256 public totalSupply;
}
