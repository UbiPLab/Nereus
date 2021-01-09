pragma solidity >=0.4.22 <0.7.0;
pragma experimental ABIEncoderV2;
contract MMSC{
    //receive match result
    //check Reputation
    mapping(bytes32=>uint256) rs;//reputation score
    mapping(bytes32=>uint256) no;//ride order
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
    
}