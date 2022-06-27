// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.7;

contract HelloName{

    string public userName;

    constructor(){
        userName = "Mr. Incognito!";
    }

    function setName(string memory _name) public {
        userName = _name;
    }
    
}
