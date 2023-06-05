pragma solidity ^0.4.25;

contract Test {
    uint good1 = -1 + 1;
    uint bad1 = (good1 =+1 ); //leak

    function bad2() external {
        uint x = 1;
        x =+ 2; //leak
        x = (x =+ 1); //leak
    }

    function good2() external {
        uint x = 1;
        x++;
        ++x;
        x = x++;
        x = ++x;
        x = -1 + 1;
    }
}
