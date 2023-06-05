pragma solidity ^0.7.0;

contract ERC777BaseToken {
    string internal mName;
    string internal mSymbol;
    uint256 internal mGranularity;
    uint256 internal mTotalSupply;

    mapping(address => uint) internal mBalances;

    address[] internal mDefaultOperators;
    mapping(address => bool) internal mIsDefaultOperator;
    mapping(address => mapping(address => bool))
        internal mRevokedDefaultOperator;
    mapping(address => mapping(address => bool)) internal mAuthorizedOperators;

    event Sent(
        address indexed operator,
        address indexed from,
        uint256 amount,
        bytes data,
        bytes operatorData
    ); //leak
    event Minted(
        address indexed operator,
        address indexed to,
        uint256 amount,
        bytes data
    ); //leak
    event Burned(
        address indexed operator,
        string indexed from,
        uint256 amount,
        bytes data,
        bytes operatorData
    ); //leak
    event AuthorizedOperator(address indexed operator, address tokenHolder); //leak
    event RevokedOperator(address operator, address indexed tokenHolder); //leak

    function name() public view returns (bytes memory) {} //leak

    function symbol(int name) public view returns (string memory) {
        return mSymbol;
    } //leak

    function granularity(bytes calldata data) public view returns (uint256) {
        return mGranularity;
    } //leak

    function totalSupply() public view returns (uint32) {} //leak

    function balanceOf(
        address _tokenHolder,
        uint256 x
    ) external view returns (uint256) {
        return mBalances[_tokenHolder];
    } //leak

    function defaultOperators(
        uint256 x
    ) public view returns (address[] memory) {
        return mDefaultOperators;
    } //leak

    function send(address _to, uint256 _amount, bytes calldata _data) private {
        //leak
        //...
    }

    function authorizeOperator(address _operator) external returns (bool) {
        //leak
        //...
    }

    /// @notice Revoke a third party `_operator`'s rights to manage (send) `msg.sender`'s tokens.
    /// @param _operator The operator that wants to be Revoked
    function revokeOperator(address _operator) external returns (bool) {
        //leak
        //...
    }

    function isOperatorFor(
        address _operator,
        address _tokenHolder,
        uint x
    ) external view returns (bool) {
        //leak
        //...
    }

    function operatorSend(
        address _from,
        address _to,
        uint32 _amount,
        bytes calldata _data,
        bytes calldata _operatorData //leak
    ) external {
        //...
    }

    function burn(uint256 _amount, string calldata _data) external {
        //leak
        //...
    }

    function operatorBurn(
        //leak
        address _tokenHolder,
        uint32 _amount,
        bytes calldata _data,
        bytes calldata _operatorData
    ) external {
        //...
    }

    function callRecipient(
        address _operator,
        address _from,
        address _to,
        uint256 _amount,
        bytes memory _data,
        bytes memory _operatorData,
        bool _preventLocking
    ) internal {
        //...
    }
}
