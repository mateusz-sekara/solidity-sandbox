// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lottery {
    address payable immutable public manager;
    address payable[] public players;

    constructor() {
        manager = payable(msg.sender);
        players.push(payable(msg.sender));
    }
 
    receive() external payable {
        require(msg.value == 0.1 ether, "You have to bid at least 0.1 ETH");
        require(msg.sender != manager, "Manager can't participate in lottery");
        players.push(payable(msg.sender));
    }

    function endLottery() public {
        require(canEndLottery(), "Conditions to end lottery are not met");

        address payable winner = pickWinner();

        uint prize = address(this).balance * 9 / 10;
        uint fee = address(this).balance - prize;

        manager.transfer(fee);
        winner.transfer(prize);
        players = new address payable[](0);
    }

    function canEndLottery() private view returns(bool) {
        return (players.length >= 10) || (players.length >= 3 && msg.sender == manager);
    }


    function pickWinner() private view returns(address payable) {
        uint index = createRandom();
        return players[index];
    }

    function createRandom() public view returns(uint){
        uint value = uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
        return value % players.length;
    }

    function getBalance() public view returns(uint) {
        require(msg.sender == manager, "Only manager can see the balance");
        return address(this).balance;
    }
}