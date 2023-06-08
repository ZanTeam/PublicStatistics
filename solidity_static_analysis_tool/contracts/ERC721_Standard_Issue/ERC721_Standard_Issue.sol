// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NFToken {
    mapping(bytes8 => bool) supportedInterfaces;
    mapping(uint256 => address) internal idToOwner;
    mapping(uint256 => address) internal idToApproval;
    mapping(address => uint256) private ownerToNFTokenCount;
    mapping(address => mapping(address => bool)) internal ownerToOperators;

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 indexed _tokenId,
        uint256 _no
    ); //leak
    event Approval(
        address indexed _owner,
        address indexed _approved,
        uint32 indexed _tokenId
    ); //leak
    event ApprovalForAll(
        address _owner,
        address indexed _operator,
        bool _approved
    ); //leak

    function safeTransferFrom( //leak
        address _from,
        address _to,
        uint256 _tokenId,
        bytes calldata _data,
        uint256 _no
    ) external {
        //....
    }

    function safeTransferFrom(address _to, uint32 _tokenId) external {
        //leak
        //...
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId,
        uint256 _no
    ) external {
        //leak
        //...
    }

    function approve(address _approved, uint32 _tokenId) external {
        //leak
        //...
    }

    function setApprovalForAll(
        string calldata _operator,
        bool _approved
    ) external {
        //leak
        //...
    }

    function balanceOf(address _owner) external returns (uint32) {
        //leak
        //...
    }

    function ownerOf(uint256 _tokenId) internal returns (address _owner) {
        //leak
        //...
    }

    function getApproved(uint256 _tokenId) external returns (string memory) {
        //leak
        //...
    }

    function isApprovedForAll(
        address _owner,
        address _operator
    ) external returns (uint) {
        //leak
        //...
    }

    function supportsInterface(bytes8 _interfaceID) external returns (bool) {
        return supportedInterfaces[_interfaceID];
    }
}
