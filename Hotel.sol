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
    mapping (uint => room) singleRoom;
    mapping (uint => room) doubleRoom;
    mapping (address => uint) numOfnights;
    uint constant public singleRoomCost = 100;
    uint constant public doubleRoomCost = 150;
    uint numOfSingle;
    uint numOfDouble;
    uint fullSingleRoom = 0;
    uint fullDoubleRoom = 0;
    
    // initiating the owner of the hotel
    constructor(uint single , uint double) {
        owner = msg.sender;
        numOfSingle = single;
        numOfDouble = double;
    }

    //renting function
    function rent (string memory typeR , uint nights) external payable {
        if (keccak256(abi.encodePacked(typeR)) == keccak256(abi.encodePacked("Single"))) {
            require (fullSingleRoom != numOfSingle , 'We do not have any vacant single room!');
            for (uint i = 0; i < numOfSingle; i++){
                if(singleRoom[i].full == false) {
                    require (msg.value >= (nights*singleRoomCost),'Not enough money!');
                    if(msg.value >= (nights*singleRoomCost)){
                        numOfnights[msg.sender] = nights;
                        singleRoom[i].full = true;
                        /////refundd msg.value - (nights*singleRoomCost)
                        break;
                    }
                }
                else if (singleRoom[i].full == true) {
                    fullSingleRoom ++;
                }
            }
        }
        else if (keccak256(abi.encodePacked(typeR)) == keccak256(abi.encodePacked("Double"))) {
            require (fullDoubleRoom != numOfDouble , 'We do not have any vacant double room!');
            for (uint i = 0; i < numOfDouble; i++){
                if(doubleRoom[i].full == false) {
                    require (msg.value >= (nights*doubleRoomCost),'Not enough money!');
                    if(msg.value >= (nights*doubleRoomCost)){
                        numOfnights[msg.sender] = nights;
                        doubleRoom[i].full = true;
                        /////refundd msg.value - (nights*singleRoomCost)
                        break;
                    }
                }
                else if (doubleRoom[i].full == true) {
                    fullDoubleRoom ++;
                }
            }
        }
    }
}
