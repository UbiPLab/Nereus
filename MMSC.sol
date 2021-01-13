pragma solidity >=0.4.22 <0.7.0;
pragma experimental ABIEncoderV2;
contract MMSC{
    //receive match result
    //check Reputation
    mapping(bytes32=>uint256) rs;//reputation score
    mapping(bytes32=>uint256) no;//ride order
    
    mapping(bytes32=>uint256) deposit;
    mapping(bytes32=>bytes32) commitment;
    
    mapping(bytes32=>uint256) expirations;
    bytes32[] addlist;
    struct InitiationStruct{
        string troij;
        bytes32 pkd;
        bytes32 pkr;
        string ts;
        string dr;
        string dd;
    }
    InitiationStruct[] public il;
    
    function Initiation(string memory troij,bytes32 pkd,bytes32 pkr,string memory ts,string memory dr,string memory dd) public{
        InitiationStruct memory ins=InitiationStruct(troij,pkd,pkr,ts,dr,dd);
        il.push(ins);
    }
    
    
    function Deposit(bytes32 pk,bytes32 comm,uint256 d,string memory ts,string memory dd) public{
        addlist.push(pk);
        commitment[pk]=comm;
        deposit[pk]=d;
    }
    
    function set_ex(bytes32 pk1,bytes32 pk2,uint256 ex) public{
        //hash pk1 pk2 as location
         bytes32 hash_location= keccak256(abi.encode(pk1,pk2));
         expirations[hash_location]=ex;
    }
    
    function Transfer(bytes32 pk1,bytes32 pk2,uint256 d) public{
        deposit[pk1]=deposit[pk1]+d;
        delete(deposit[pk2]);
        delete(commitment[pk2]);
        for(uint i=0;i<addlist.length;i++){
            if(addlist[i]==pk2){
                delete(addlist[i]);
                break;
            }
        }
    }
    
    function complain(bytes32 pk1,bytes32 pk2) public{
        emit Complain("Complain",pk1,pk2);
        bytes32 hash_location= keccak256(abi.encode(pk1,pk2));
        uint256 ex=expirations[hash_location];
        if(block.timestamp<ex){//&&receive valid response
            Transfer(pk2,pk1,deposit[pk1]);
        }
        else{
            Transfer(pk1,pk2,deposit[pk2]);
        }
    }
    function manage(bytes32[] memory pklist) public returns(bytes32){
        if(pklist.length==1){
            return pklist[0];
        }
        bytes32 r=pklist[0];
        uint256 maxvalue=0;
        for(uint256 i=0;i<pklist.length;i++){
            if(rs[pklist[i]]>maxvalue){
                maxvalue=rs[pklist[i]];
                r=pklist[i];
            }
        }
        return r;
    }
    
    function manage_add(bytes32 pk,uint256 k) public{
        rs[pk]=k;
    }//for setting up
    
   
    
    
    
    
    function complete(bytes32 pkd,bytes32 pkr,uint256 time) public{
        no[pkd]=no[pkd]+1;
        rs[pkd]=(no[pkd]*rs[pkd]+1)/no[pkd];//hard-code rtiR 1
        //update information
        return;
    }
    
    // function testdiv(uint256 a,uint256 b) public{
    //     return a/b;
    // }
    event driver_selected(); 
    event Complain(string data,bytes32 pk1,bytes32 pk2);
}
