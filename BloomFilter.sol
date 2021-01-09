pragma solidity >=0.4.22 <0.7.0;

contract BloomFilter{
    uint256 k=5;
    uint256 l=8000;
    bool[] filter_cells;
    
    constructor(uint256 length,uint256 hashnum,uint256[] memory index_data) public{
        require(length%4==0,"invalid length");
        k=hashnum;
        l=length;
        filter_cells=new bool[](l);//A new constructor
        //Rider generate BF, hex-form cell data
        for(uint256 i=0;i<index_data.length;i++){
            filter_cells[index_data[i]]=true;
        }
         emit constructed(l,hashnum,index_data);
    }
    
    // function insert(string memory strdata) public returns(bool){
    //     //modify to uint256 data,cell index
    //     bool insertflag=false;
    //     uint256[] memory indexlist=new uint256[](k);
    //     for(uint256 i=0;i<k;i++){
    //         bytes32 hash_r= keccak256( abi.encode(strdata,i));
    //         uint256 hash_ruint=uint256(hash_r);
    //         uint256 index=hash_ruint%l;
    //         filter_cells[index]=true;
    //         indexlist[i]=index;
    //     }
    //     emit insert_event(strdata,indexlist);
    //     insertflag=true;
    //     return insertflag;
        
    // }
    
    function insert(uint256 cell_index) public returns(bool){
        bool insertflag=false;
        uint256[] memory locationlist=new uint256[](k);
        for(uint256 i=0;i<k;i++){
            bytes32 hash_r= keccak256( abi.encode(cell_index,i));
            uint256 hash_ruint=uint256(hash_r);
            uint256 location=hash_ruint%l;
            filter_cells[location]=true;
            locationlist[i]=location;
        }
        emit insert_event(cell_index,locationlist);
        insertflag=true;
        return insertflag;
    }
    
    
    
    
    // function search(string memory strdata) public returns(bool flag){
    //     //modify to uint256 data,cell index
    //     for(uint256 i=0;i<k;i++){
    //         bytes32 hash_r= keccak256( abi.encode(strdata,i));
    //         uint256 hash_ruint=uint256(hash_r);
    //         uint256 index=hash_ruint%l;
    //         if(filter_cells[index]!=true){
    //             flag=false;
    //             emit search_evnet(flag);
    //             return flag;
    //         }
    //     }
    //     flag=true;
    //     emit search_evnet(flag);
    //     return flag;
    // }
    
    function search(uint256 cell_index) public returns(bool){
        bool flag=true;
        for(uint256 i=0;i<k;i++){
            bytes32 hash_r=keccak256(abi.encode(cell_index,i));
            uint256 hash_ruint=uint256(hash_r);
            uint256 location=hash_ruint%l;
            if(!filter_cells[location]){
                flag=false;
                break;
            }
        }
        emit search_evnet(flag);
        return flag;
    }

    function test() public{
        emit test_event(66666);
    }
    
    function convertBFtohex() public returns(uint8[] memory){
        require(l%4==0,"invalid length");
        uint256 rearraylength=l/4;
        uint8[] memory rdata= new uint8[](rearraylength);
        for(uint256 i=0;i<l;i+=4){
            uint8 sum=0;
            sum+= (filter_cells[i] ? 1 : 0)*8;
            sum+= (filter_cells[i+1] ? 1 : 0)*4;
            sum+= (filter_cells[i+2] ? 1 : 0)*2;
            sum+= (filter_cells[i] ? 1 : 0);
            rdata[i/4]=sum;
        }
        emit hex_event(rdata);
        return rdata;
    }
    
    event insert_event(uint256 cell_index, uint256[] locationlist);
    event test_event(uint256 timestamp);
    event search_evnet(bool searchflag);
    event hex_event(uint8[] rdata);
    event constructed(uint256 BFlength,uint256 hashnum,uint256[] index_data);
}