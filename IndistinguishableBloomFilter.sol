pragma solidity >=0.4.22 <0.7.0;
contract IndistinguishableBloomFilter{
    uint256 z=10;
    uint256 rb;
    uint256 l=8000;
    bool[] top_cells;
    bool[] bottom_cells;
    bytes32[] keys;
    
    constructor(uint256 randomnumber,uint256 length,uint256 numofhash,bytes32[] memory inkeys) public{
        rb=randomnumber;
        l=length;
        z=numofhash;//+1?
        //z+1 keys
        keys=new bytes32[](z+1);
        for(uint256 i=0;i<inkeys.length;i++){
            keys[i]=inkeys[i];   
        }
        top_cells=new bool[](l);
        bottom_cells=new bool[](l);
        
    }
    
    function setfortest(uint256[] memory index_data1,uint256[] memory index_data2) public{
        for(uint256 i=0;i<index_data1.length;i++){
            top_cells[index_data1[i]]=true;
        }
        for(uint256 i=0;i<index_data2.length;i++){
            top_cells[index_data2[i]]=true;
        }
    }
    
    
    function insert(bytes32 cell_index) public returns(bool){ 
        for(uint i=0;i<z;i++) {//compute location first
            bytes32 hash_r= keccak256(abi.encodePacked(cell_index,keys[i]));
            //abi.encodePacked(cell_index,keys[i]);
            uint256 hash_ruint=uint256(hash_r);
            uint256 location=hash_ruint%l;
            //decide top or bottom
            //hash_r= sha256( abi.encode(cell_index,keys[i+1]));
            hash_r=sha256(abi.encodePacked(keccak256(abi.encodePacked(hash_r,keys[i+1])),rb));
            hash_ruint=uint256(hash_r);
            uint256 location_level=hash_ruint%2;
            if(location_level==0){
                top_cells[location]=true;
                bottom_cells[location]=false;
            }
            else{
                bottom_cells[location]=true;
                top_cells[location]=false;
            }
        }
        
        return true;
    }
    
    
    function search(bytes32 cell_index) public returns(bool){
        for(uint i=0;i<z;i++){
            bytes32 hash_r= keccak256(abi.encode(cell_index,keys[i]));
            uint256 hash_ruint=uint256(hash_r);
            uint256 location=hash_ruint%l;
            //judge
            hash_r=sha256(abi.encodePacked(keccak256(abi.encodePacked(hash_r,keys[i+1])),rb));
            hash_ruint=uint256(hash_r);
            uint256 location_level=hash_ruint%2;
            
            if(location_level==0){
                return top_cells[location]&&!bottom_cells[location];
            }
            else{
                return !top_cells[location]&&bottom_cells[location];
            }
        }
    }
    
     function seek(bytes32 cell_index) public returns(bool){
        for(uint i=0;i<z;i++){
            bytes32 hash_r= keccak256(abi.encode(cell_index,keys[i]));
            uint256 hash_ruint=uint256(hash_r);
            uint256 location=hash_ruint%l;
            //judge
            hash_r=sha256(abi.encodePacked(keccak256(abi.encodePacked(hash_r,keys[i+1])),rb));
            hash_ruint=uint256(hash_r);
            uint256 location_level=hash_ruint%2;
            
            if(location_level==0){
                return top_cells[location];
            }
            else{
                return bottom_cells[location];
            }
        }
    }
}
