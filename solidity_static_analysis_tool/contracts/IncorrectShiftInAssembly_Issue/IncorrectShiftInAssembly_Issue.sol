pragma solidity ^0.8.0;

contract Test {
    function bad1(int x) external returns (int a) {
        assembly {
            a := shr(x, 0x12) //leak
        }
    }

    function bad2(int x) external returns (int a) {
        assembly {
            a := shl(x, 8) //leak
        }
    }

    function bad3(int x) external returns (int a) {
        assembly {
            a := sar(x, 8) //leak
        }
    }

    function good1(int x) external returns (int a) {
        assembly {
            a := shr(8, x)
        }
    }

    function good2(int x) external returns (int a) {
        assembly {
            a := shl(8, x)
        }
    }

    function good3(int x) external returns (int a) {
        assembly {
            a := sar(8, x)
        }
    }

    function good4() external returns (int a) {
        assembly {
            a := shl(240, 0x3d3d)
        }
    }

    function good5(int x) external returns (int a) {
        assembly {
            a := signextend(8, x)
        }
    }

    function bad5(int x) external returns (int a) {
        assembly {
            a := signextend(x, 8) //leak
        }
    }

    function good6(int x) external returns (int a) {
        assembly {
            a := byte(8, x)
        }
    }

    function bad6(int x) external returns (int a) {
        assembly {
            a := byte(x, 8) //leak
        }
    }
}
