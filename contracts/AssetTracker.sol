pragma solidity 0.8.7;
import "./AssetLibrary.sol";

contract AssetTracker {
   
    mapping(uint => AssetLibrary.Asset) public AssetStore;
    mapping(uint => address) public AssetOwner;
    address public Manufacturer=0x06D1bBDc60E81A74AEF8C0Ed44216f41a0f8d89C;
   
    uint256 public assetCount= 0;
    /*struct Asset {
        uint id;
        string batchNo;
        string name;
        string description;
        string manufacturer;
       
        uint statusCount;
        mapping(uint => Status) status;
    }
    struct Status {
        uint time;
        string status;
        string owner;
    }*/
    //function createAsset(string memory _batchNo, string memory _name, string memory _description, string memory _manufacturer, string memory _owner, string memory _status) public returns(uint256) {
    function createAsset(string memory _batchNo, string memory _name, string memory _description, string memory _manufacturer, address _owner, string memory _status, string memory _long, string memory _lat) public { 
        require(
            msg.sender== Manufacturer
        );
        
        assetCount++;
        //AssetStore[assetCount]= AssetLibrary.Asset(assetCount, _batchNo, _name, _description, _manufacturer , 1,);
        AssetStore[assetCount].id=assetCount;
        AssetStore[assetCount].batchNo=_batchNo;
        AssetStore[assetCount].name=_name;
        AssetStore[assetCount].description=_description;
        AssetStore[assetCount].manufacturer=_manufacturer;
        AssetStore[assetCount].KeyHash=keccak256(bytes(_batchNo));

        AssetStore[assetCount].statusCount=1;
        AssetStore[assetCount].status[AssetStore[assetCount].statusCount]=AssetLibrary.Status(block.timestamp, _status, _owner, _lat, _long);

        //AssetStore[assetCount]= AssetLibrary.Asset(assetCount, _batchNo, _name, _description, _manufacturer , 0);
        //AssetStore[assetCount].statusCount++;
        //AssetStore[assetCount].status[AssetStore[assetCount].statusCount]=AssetLibrary.Status(block.timestamp, _status, _owner);
        AssetOwner[assetCount] = _owner;
        emit AssetCreate(assetCount, _manufacturer, _status);
    }

    function KeyCreation(uint _id) public view returns(bytes32) {
        require(
            msg.sender == AssetOwner[_id],
            //msg.sender == AssetOwner[_id],
            "Only owner can transfer asset."
        );
        return keccak256(bytes(AssetStore[_id].batchNo));
    }

   
   
    function getAsset(uint _id) view public returns(string memory, string memory, string memory, address, string memory, string memory) {
        return (AssetStore[_id].batchNo, AssetStore[_id].name, AssetStore[_id].manufacturer, AssetStore[_id].status[AssetStore[_id].statusCount].owner, AssetStore[_id].status[AssetStore[_id].statusCount].status, AssetStore[_id].description);
    }
    
   
    //function transferAsset(uint _id, string memory _newOwner, string memory _status) public returns(string memory) {
    function transferAsset(uint _id, address _newOwner, string memory _status, string memory _lat, string memory _long) public {
        require(
            msg.sender == AssetOwner[_id],
            //msg.sender == AssetOwner[_id],
            "Only owner can transfer asset."
        );
        AssetOwner[_id]=_newOwner;
        AssetStore[_id].statusCount++;
        AssetStore[_id].status[AssetStore[_id].statusCount]=AssetLibrary.Status(block.timestamp, _status, _newOwner,_lat, _long);
        emit AssetTransfer(_id, _newOwner);
    }

    function AssetDelete(uint _id, string memory name, string memory batchNo) public returns(string memory){
        delete AssetStore[_id];
        assetCount--;
    }

    function getLongLat(uint _id) public returns(string memory, string memory){
        return(
                AssetStore[_id].status[AssetStore[_id].statusCount].long,
                AssetStore[_id].status[AssetStore[_id].statusCount].lat
            );
    }
   
    function getAssetCount() view public returns(uint) {
        return assetCount;
    }
   
    function getStatus(uint _id, uint _statusCount) view public returns(uint, string memory, address) {
        AssetLibrary.Status memory s= AssetStore[_id].status[_statusCount];
        return (s.time, s.status, s.owner);
    }

    
   
    event AssetCreate(uint id, string manufacturer, string status);
    event AssetTransfer(uint id, address newOwner);
    
}


