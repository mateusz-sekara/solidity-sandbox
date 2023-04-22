// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract A {
    int public x = 10;
    int y = 20;

    function getY() public view returns(int) {
        return y;
    }
    
    function f1() private view returns(int) {
        return x;
    }

    function f2() public view returns(int) {
        int a = f1();
        return a;
    }

    function f3() internal view returns(int) {
        return x;
    }

    function f4() external view returns(int) {
        return x;
    }
}

contract C {
    A public contractA = new A();
    int public xx = contractA.f4();
}