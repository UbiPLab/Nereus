pragma solidity >=0.4.22 <0.7.0;
pragma experimental ABIEncoderV2;

import "../BloomFilter.sol";

contract UMSC{
    /* wrapper*/
    struct RequestStruct{
        BloomFilter bf;
        bytes32 pn;
        string time;
        string d;
    }//ride request

    struct ResponseStruct{
        uint256 c1;
        uint256 c2;
        string timestamp;
        string d;
    }
    //data structs
    
    RequestStruct currentReq;
    //match result set should be a memory array
    mapping(bytes32 => ResponseStruct) public ResponseMap;
    bytes32[] RespnList;
    //ResultStruct
    uint256 n;
    uint256 count;

    constructor(uint256 k) public{
        n=k;
    }
    
    function Request(bytes32 pn, uint256[] memory index_data,string memory timestamp,string memory d) public{
        BloomFilter bf=new BloomFilter(1000,5,index_data);
        RequestStruct memory rrR=RequestStruct(bf,pn,timestamp,d);
        currentReq=rrR;
        //Request created
        //return Match();
    }
    
    function Request_2(bytes32 pn, uint256[] memory index_data,string memory timestamp,string memory d) public returns(bytes32[] memory){
        BloomFilter bf=new BloomFilter(1000,5,index_data);
        bf.insert(1);
        bf.insert(2);
        RequestStruct memory rrR=RequestStruct(bf,pn,timestamp,d);
        currentReq=rrR;
        //Request created
        return Match();
    }//for testing
    
    /*function genBF(uint256 k)public returns(BloomFilter){
        uint256[] memory rdata= new uint256[](0);
        BloomFilter bf=new BloomFilter(5,8000,rdata);
        return bf;
        //for testing
    }*/
    
    function Response(bytes32  pn, uint256 c1,uint256 c2,string memory timestamp,string memory d) public{
        ResponseStruct memory rrD=ResponseStruct(c1,c2,timestamp,d);
        ResponseMap[pn]=rrD;//Insert into ResponseMap
        RespnList.push(pn);
        count=count+1;//Sum num of collected responses
         
    }
    
    function Match() public returns(bytes32[] memory){
        //n responses collected
        //match_count=0
        //BloomFilter bf=currentReq.bf
        //for r in responses:
        //  if(bf.search(c1)&&bf.search(c2)):
        //    match_count++
        // 
        BloomFilter bf=currentReq.bf;
        uint256 match_count=0;
        bytes32[] memory match_list=new bytes32[](RespnList.length);//Suppose that every Response is selected
        for(uint256 i=0;i<RespnList.length;i++){
            uint256 c1=ResponseMap[RespnList[i]].c1;
            uint256 c2=ResponseMap[RespnList[i]].c2;
            //get c1 and c2 value
            if(bf.search(c1)&&bf.search(c2)){
                match_list[match_count]=RespnList[i];
                match_count=match_count+1;
            }
        }
        return match_list;
        //threefold step outside UMSC
    }
    
    function advancedMatch() public returns(bytes32[] memory){
        //see adumsc
    }
    
    function Delete(bytes32 pn) public returns(bool){
        delete(ResponseMap[pn]);
        for(uint256 i=0;i<RespnList.length;i++){
            if(RespnList[i]==pn){
                delete(RespnList[i]);
                return true;
            }
        }
        return false;
    }
    
    function khash(uint256 k) public returns (bytes32[] memory hashlist,bytes32 lasthash){
        hashlist=new bytes32[](k);
        for(uint256 i=0;i<k;i++){
            bytes32 id = keccak256( abi.encode("password",i)) ;
            hashlist[i]=id;
            lasthash=id;
        }
        return (hashlist,lasthash);
    }



    event showNumber(uint256 num);
    event showRes(ResponseStruct res);
}