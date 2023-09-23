pragma solidity 0.8.7;

library AssetLibrary {
    struct Asset {
        uint id;
        string batchNo;
        string name;
        string description;
        string manufacturer;
        bytes32 KeyHash;
       
        uint statusCount;
        mapping(uint => Status) status;
    }
    struct Status {
        uint time;
        string status;
        address owner;
        string long;
        string lat;
        
    }
}

