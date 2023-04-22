
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DynamicArrays {
    uint[] public numbers;

    function getLength() public view returns (uint) {
        return numbers.length;
    }

    function addElement(uint item) public {
        numbers.push(item);
    }

    function getElement(uint i) public view returns(uint) {
        if (i < numbers.length) {
            return numbers[i];
        }
        return 0;
    }

    function popElement() public {
        numbers.pop();
    }
    
    function f() public {
        uint[] memory y = new uint[](3);
        y[0] = 10;
        y[1] = 20;
        y[2] = 30;
        numbers = y;
    }
}