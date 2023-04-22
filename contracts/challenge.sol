//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract CryptosToken{
    string constant public name = "Cryptos";
    uint supply;
    address public  owner;

    constructor() {
        owner = msg.sender;
    }

    function setSupply(uint _supply) public {
        supply = _supply;
    }

    function getSupply() public view returns(uint) {
        return supply;
    }
}

contract MyTokens{
    string[] public tokens = ['BTC', 'ETH'];

    address immutable private admin;

    constructor() {
        admin = msg.sender;
    }
    
    function changeTokens() public view{
        string[] memory t = tokens;
        t[0] = 'VET';
    }

    receive() external payable {}
    fallback() external payable {}
    
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function transferFunds(address payable dst) public {
        require(msg.sender == admin);

        dst.transfer(address(this).balance);
    }
}

 
contract A{
    int public x = 10;

    
    function f3() internal view returns(int){
        return x;
    }
}

contract B is A {
    function f() public view returns(int) {
        return f3();
    }

    function stringConcat(string memory s1, string memory s2) public pure returns(string memory) {
        return string(abi.encodePacked(s1, s2));
    }
}