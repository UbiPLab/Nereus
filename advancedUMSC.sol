pragma solidity >=0.4.22 <0.7.0;
pragma experimental ABIEncoderV2;

import "../IndistinguishableBloomFilter.sol";

contract AdvancedUMSC{
    /* wrapper*/
    struct RequestStruct{
        IndistinguishableBloomFilter ibf;
        bytes32 pn;
        string time;
        string d;
    }//ride request

    struct ResponseStruct{
        bytes32[] prlist;
        string rr;
        string timestamp;
        string d;
    }
    //data structs
    
    RequestStruct currentReq;
    //match result set should be a memory array
    mapping(bytes32 => ResponseStruct) public ResponseMap;
    bytes32[] keys;
    bytes32[] RespnList;
    //ResultStruct
    uint256 n;
    uint256 count;

    constructor(uint256 k) public{
        n=k;
        keys=new bytes32[](k+1);
    }
    
    function setkeys(bytes32[] memory inkeys) public{
        //z+1 keys
        for(uint256 i=0;i<inkeys.length;i++){
            keys[i]=inkeys[i];
        }
    }
    
    function Request(bytes32 pn, uint256[] memory index_data1,uint256[] memory index_data2,string memory timestamp,string memory d) public{
        IndistinguishableBloomFilter ibf=new IndistinguishableBloomFilter(1,1000,5,keys);
        ibf.setfortest(index_data1,index_data2);
        RequestStruct memory rrR=RequestStruct(ibf,pn,timestamp,d);
        currentReq=rrR;
        //Request created
        //return Match();
    }
    
    function Request_2(bytes32 pn, bytes32[] memory prs,string memory timestamp,string memory d) public{
        IndistinguishableBloomFilter ibf=new IndistinguishableBloomFilter(1,1000,5,keys);
        for(uint256 i=0;i<prs.length;i++){
            ibf.insert(prs[i]);
        }
        RequestStruct memory rrR=RequestStruct(ibf,pn,timestamp,d);
        currentReq=rrR;
        //Request created
        //return Match();
    }
    
    
    
    function Response(bytes32 pn, bytes32[] memory prs,string memory rr,string memory timestamp,string memory d) public{
        ResponseStruct memory rrD=ResponseStruct(prs,rr,timestamp,d);
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
        IndistinguishableBloomFilter ibf=currentReq.ibf;
        uint256 match_count=0;
        bytes32[] memory match_list=new bytes32[](RespnList.length);//Suppose that every Response is selected
        for(uint256 i=0;i<RespnList.length;i++){
            bytes32[] memory prl=ResponseMap[RespnList[i]].prlist;
            bool flag=true;
            for(uint256 j=0;j<prl.length;j++){
                if(!ibf.seek(prl[j])){
                    flag=false;
                    break;
                }
            }
            if(flag){
                match_list[match_count]=RespnList[i];
                match_count=match_count+1;
            }
        }
        return match_list;
        //threefold step outside UMSC
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