// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Auction {
    address payable public owner;
    uint public startBlock;
    uint public endBlock;
    string public ipfsHash;
    State public auctionState;
    uint public highestBindingBid;
    address payable public highestBidder;

    mapping(address => uint) public bids;
    uint bidIncrement;

    enum State {
        Started, Running, Ended, Canceled
    }

    modifier onlyOnwer() {
        require(owner == msg.sender);
        _;
    }

    modifier notOwner() {
        require(msg.sender != owner);
        _;
    }

    modifier afterStart() {
        require(block.number >= startBlock);
        _;
    }

    modifier beforeEnd() {
        require(block.number <= endBlock);
        _;
    }

    constructor() {
        owner = payable(msg.sender);
        auctionState = State.Running;
        startBlock = block.number;
        endBlock = startBlock * 40320; // Auction running for the week
        ipfsHash = "";
        bidIncrement = 100;
    }

    function min(uint a, uint b) private pure returns(uint) {
        return a > b ? b : a;
    }

    function placeBid() public payable notOwner afterStart beforeEnd {
        require(auctionState == State.Running);
        require(msg.value >= 100 wei);

        uint currentBid = bids[msg.sender] + msg.value;
        require(currentBid > highestBindingBid);
        
        bids[msg.sender] = currentBid;

        if (currentBid <= bids[highestBidder]) {
            highestBindingBid = min(currentBid + bidIncrement, bids[highestBidder]);
        } else {
            highestBindingBid = min(currentBid, bids[highestBidder] + bidIncrement);
            highestBidder = payable(msg.sender);
        }
    }

    function cancelAuction() public payable onlyOnwer afterStart beforeEnd {
        require(auctionState == State.Running);
        auctionState = State.Canceled;
    }

    function finalizeAuction() public payable {
        require(auctionState == State.Canceled || block.number > endBlock);
        require(msg.sender == owner || bids[msg.sender] > 0);

        address payable recipient;
        uint value;

        if (auctionState == State.Canceled) { // Auction was cancelled
            recipient = payable(msg.sender);
            value = bids[msg.sender];
        } else { // Auction ended
            if (msg.sender == owner) { // Owner
                recipient = owner;
                value = highestBindingBid;
            } else { // this is a bidder
                if(msg.sender == highestBidder) {
                    recipient = highestBidder;
                    value = bids[highestBidder] - highestBindingBid;
                } else { // one of the bidders
                    recipient = payable(msg.sender);
                    value = bids[msg.sender];
                }
            }
        }

        bids[recipient] = 0;
        recipient.transfer(value);
    }
}