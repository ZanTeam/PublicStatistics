pragma solidity ^0.4.25;

contract Test {
    uint a;

    modifier bad1() {
        //leak
        if (a == 1) {
            _;
        }

        if (a == 2) {
            a = 1;
        }
    }

    modifier bad2() {
        //leak
        if (a > 1) {
            if (a > 4) {
                a = 1;
            } else {
                _;
            }
        } else {
            _;
        }
        a = 4;
    }

    modifier bad3() {
        //leak
        if (a > 1) {
            _;
        } else {
            a = 5;
        }
    }

    modifier bad4() {
        //leak
        if (a == 1) {
            _;
        }

        if (a == 2) {
            revert();
        }
    }

    modifier bad5() {
        //leak
        if (false) {
            _;
        } else if (false) {
            revert();
        } else {
            a = 4;
        }
    }

    modifier bad6() {
        //leak
        require(1 == 1);
        assert(1 == 1);
        if (false) _;
    }

    modifier bad7() {
        //leak
        uint8 i = 0;

        for (i = 0; i < 10; i++) {
            _;
        }

        while (i < 20) {
            i++;
            _;
        }

        do {
            i++;
        } while (i < 30);
    }

    modifier good1() {
        a = 4;
        _;
    }

    modifier good2() {
        if (a > 1) {
            revert();
        } else {
            a = 1;
        }
        _;
    }

    modifier good3() {
        if (a > 1) {
            _;
        } else {
            a = 1;
        }
        _;
    }

    modifier good4() {
        if (a == 1) {
            _;
        }

        revert();
    }

    modifier good5() {
        if (false) _;
        revert();
    }

    modifier good6() {
        if (false) revert();
        _;
    }

    modifier good7() {
        require(1 == 1);
        assert(1 == 1);
        _;
    }

    modifier good8() {
        uint8 i = 0;

        do {
            i++;
            _;
        } while (i < 1);
    }
}
