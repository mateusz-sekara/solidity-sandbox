// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

struct Instructor {
    uint age;
    string name;
    address addr;
}

contract Academy {
    Instructor public academyInstructor;

    enum State {Open, Closed, Unknown}

    State public academyState = State.Open;

    constructor(uint _age, string memory _name) {
        academyInstructor.age = _age;
        academyInstructor.name = _name;
        academyInstructor.addr = msg.sender;
    }

    function changeInstructor(uint _age, string memory _name, address _addr) public {
        if (academyState != State.Open) {
            return;
        }

        Instructor memory newOne = Instructor({
            age: _age,
            name: _name,
            addr: _addr
        });

        academyInstructor = newOne;
    }
}

contract School {
    Instructor public schoolInstructor;
}