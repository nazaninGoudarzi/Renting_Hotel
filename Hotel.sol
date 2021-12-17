// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract Hotel {
    //declaration
    address owner;
    struct room {
        uint id;
        //if a room is full, this will be true
        bool full;
    }
    struct customer {
        uint numOfnights;
        uint keyCode;
    }
    mapping (uint => room) singleRoom;
    mapping (uint => room) doubleRoom;
    mapping (address => customer) registration;
    uint constant public singleRoomCost = 100;
    uint constant public doubleRoomCost = 150;
    uint numOfSingle;
    uint numOfDouble;
    uint fullSingleRoom = 0;
    uint fullDoubleRoom = 0;
    uint numOfCustomers = 0;
    
    // initiating the owner of the hotel
    constructor(uint single , uint double) {
        owner = msg.sender;
        numOfSingle = single;
        numOfDouble = double;
        for (uint i = 0; i < numOfSingle; i++) 
            singleRoom[i].full = false;
        for (uint i = 0; i < numOfDouble; i++) 
            doubleRoom[i].full = false;
    }

    //renting function
    function rent (string memory typeR , uint nights) external payable {
        if (keccak256(abi.encodePacked(typeR)) == keccak256(abi.encodePacked("Single"))) {
            require (fullSingleRoom != numOfSingle , 'We do not have any vacant single room!');
            for (uint i = 0; i < numOfSingle; i++) {
                if(singleRoom[i].full == false) {
                    require (msg.value >= (nights*singleRoomCost),'Not enough money!');
                    if(msg.value >= (nights*singleRoomCost)){
                        registration[msg.sender].numOfnights = nights;
                        registration[msg.sender].keyCode = convert((msg.sender).codehash);
                        singleRoom[i].full = true;
                        fullSingleRoom ++;
                        address payable customerAddress = payable(msg.sender);
                        customerAddress.transfer(msg.value - (nights*singleRoomCost));
                        numOfCustomers ++;
                        break;
                    }
                }
            }
        }
        else if (keccak256(abi.encodePacked(typeR)) == keccak256(abi.encodePacked("Double"))) {
            require (fullDoubleRoom != numOfDouble , 'We do not have any vacant double room!');
            for (uint i = 0; i < numOfDouble; i++){
                if(doubleRoom[i].full == false) {
                    require (msg.value >= (nights*doubleRoomCost),'Not enough money!');
                    if(msg.value >= (nights*doubleRoomCost)){
                        registration[msg.sender].numOfnights = nights;
                        registration[msg.sender].keyCode = convert((msg.sender).codehash);
                        doubleRoom[i].full = true;
                        fullDoubleRoom ++;
                        address payable customerAddress = payable(msg.sender);
                        customerAddress.transfer(msg.value - (nights*doubleRoomCost));
                        numOfCustomers ++;
                        break;
                    }
                }
            }
        }
    }

    //converting function from bytes32 to uint256
    function convert (bytes32 x) public pure returns (uint256) {
        uint256 y;
        for (uint256 i = 0; i < 32; i++) {
            uint256 c = (uint256(x) >> (i * 8)) & 0xff;
            if (48 <= c && c <= 57)
                y += (c - 48) * 10 ** i;
            else
                break;
        }
        return y;
    }

    // welcome event
    event welcome (string message);
    //entring the room
    function entring () public {
        for (uint i = 0; i < numOfCustomers; i++) {
            require(registration[i].keyCode == convert((msg.sender).codehash),'You sould go to the hotel reception!');
            if(registration[i].keyCode == uint256(convert((msg.sender).codehash))) {
                emit welcome ("Welcome to your room.");
            }
        }
    }
}
