pragma solidity 0.8.0;

contract Test {
    bytes32 public constant good1 =
        keccak256(abi.encodePacked("abi", "encode", "packed"));

    function good2(
        address[3] calldata admins,
        address[3] calldata regularUsers
    ) external {
        bytes32 hash = keccak256(abi.encodePacked(admins, regularUsers));
    }

    function good3(
        address[3] calldata regularUsers,
        bytes calldata a,
        address b,
        address c
    ) external {
        address x = b;
        address[] memory admin = new address[](2);
        admin[0] = b;
        admin[1] = c;
        bytes32 hash = keccak256(abi.encodePacked(admin, regularUsers, a));
    }

    function bad1(
        address[] calldata admins,
        address[3] calldata regularUsers,
        bytes calldata a,
        string calldata b
    ) external {
        bytes32 hash = keccak256(abi.encodePacked(admins, regularUsers, a, b)); //leak
    }

    function bad2(
        address[] calldata admins,
        address[3] calldata regularUsers,
        bytes calldata a
    ) external {
        address[] memory admin;
        admin = admins;
        bytes32 hash = keccak256(abi.encodePacked(admin, a, regularUsers)); //leak
    }
}
