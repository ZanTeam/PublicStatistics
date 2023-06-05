pragma solidity 0.8.7;

contract Test {
    function bad1(uint256 m, uint256 n) external returns (uint256) {
        // 10,20: 1000gas  0,20: 780 gas
        if (m > 0) { //leak
            return n * n;
        } else {
            return n;
        }
    }

    function good1(uint256 m, uint256 n) external returns (uint256) {
        // 10,20: 997gas  0,20: 777 gas
        if (m != 0) {
            return n * n;
        } else {
            return n;
        }
    }

    function bad2(uint256[] calldata m, uint256 n) external returns (uint256) {
        require(m.length > 0); //leak
        if (m[0] > 0) { //leak
            return n * n;
        } else {
            return n;
        }
    }

    function good2(uint256[] calldata m, uint256 n) external returns (uint256) {
        require(m.length != 0);
        if (m[0] != 0) {
            return n * n;
        } else {
            return n;
        }
    }

    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );

    function good3(
        uint256[] calldata tokenId,
        address[] calldata from,
        address[] calldata to
    ) external {
        require(
            tokenId.length == from.length && from.length == to.length,
            "Arrays do not match."
        );
        for (uint256 i = 0; i < tokenId.length; i++) {
            emit Transfer(from[i], to[i], tokenId[i]);
        }
    }
}
