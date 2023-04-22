// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract A {
    address public ownerA;
    constructor(address eoa) {
        ownerA = eoa;
    }
}

contract Creator {
    address public creator;
    A[] public deployments;

    constructor() {
        creator = msg.sender;
    }

    function deployA() public returns(address) {
        A contractA = new A(msg.sender);
        deployments.push(contractA);
        return address(contractA);
    }
}