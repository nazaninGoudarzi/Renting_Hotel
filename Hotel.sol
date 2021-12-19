// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract Hotel {
    //declaration
    address owner;
    address temp;
    struct room {
        uint id;
        //if a room is full, this will be true
        bool full;
    }
    struct customer {
        uint numOfnights;
        address keyCode;
        uint entranceTime;
    }
    struct forOwner {
        address forOwnerCustomer;
    }
    mapping (uint => room) singleRoom;
    mapping (uint => room) doubleRoom;
    mapping (address => customer) registration;
    mapping (uint => forOwner) ownerCustomer;
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

    // renting function
    function rent (string memory typeR , uint nights) external payable {
        if (keccak256(abi.encodePacked(typeR)) == keccak256(abi.encodePacked("Single"))) {
            require (fullSingleRoom != numOfSingle , 'We do not have any vacant single room!');
            for (uint i = 0; i < numOfSingle; i++) {
                if(singleRoom[i].full == false) {
                    require (msg.value >= (nights*singleRoomCost),'Not enough money!');
                    if(msg.value >= (nights*singleRoomCost)){
                        registration[msg.sender].numOfnights = nights;
                        registration[msg.sender].keyCode = msg.sender;
                        registration[msg.sender].entranceTime = block.timestamp;
                        singleRoom[i].full = true;
                        fullSingleRoom ++;
                        address payable customerAddress = payable(msg.sender);
                        customerAddress.transfer(msg.value - (nights*singleRoomCost));
                        ownerCustomer[numOfCustomers].forOwnerCustomer = msg.sender;
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
                        registration[msg.sender].keyCode = msg.sender;
                        registration[msg.sender].entranceTime = block.timestamp;
                        doubleRoom[i].full = true;
                        fullDoubleRoom ++;
                        address payable customerAddress = payable(msg.sender);
                        customerAddress.transfer(msg.value - (nights*doubleRoomCost));
                        ownerCustomer[numOfCustomers].forOwnerCustomer = msg.sender;
                        numOfCustomers ++;
                        break;
                    }
                }
            }
        }
    }

    // welcome event
    event welcome (string message);

    // entring the room
    function entring () public {
        for (uint i = 0; i < numOfCustomers; i++) {
            require(registration[msg.sender].keyCode == msg.sender,'You sould go to the hotel reception!');
            if(registration[msg.sender].keyCode == msg.sender) {
                emit welcome ("Welcome to your room.");
                break;
            }
        }
    }

    //empty or refund event
    event empty (string emptymessage);
    // updating function, only accessable by the owner
    function update () public {
        require(msg.sender == owner,'You can not access to this function');
        for (uint i = 0; i < numOfCustomers; i++) {
            uint currentTime = block.timestamp;
            temp = ownerCustomer[i].forOwnerCustomer;
            uint difference = (currentTime - (registration[temp].entranceTime)) / 60 / 60 / 24;
            if(difference >= registration[temp].numOfnights) {
                emit empty ("You have to empty the room or you can charge the room for more time!");
            }
        }
    }

    //this function enables the contract to receive funds
    receive () external payable {
    }
}
