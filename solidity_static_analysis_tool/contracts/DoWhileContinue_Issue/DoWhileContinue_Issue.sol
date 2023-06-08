pragma solidity ^0.4.19;

contract Test {
    function bad1() public {
        uint test = 0;
        do {
            //leak
            test++;
            if (test > 10) {
                continue;
            }
        } while (test < 100);
    }

    function bad2(int256 index) public {
        uint test = 0;
        if (index > 10) {
            do {
                //leak
                test++;
                if (test > 10) {
                    continue;
                }
            } while (test < 100);
        } else {
            do {
                test++;
            } while (test < 100);
        }
    }

    function good1() public {
        for (uint i = 0; i++; i < 10) {
            if (i > 5) continue;
        }

        uint test = 0;
        do {
            test++;
        } while (test < 100);
    }
}
