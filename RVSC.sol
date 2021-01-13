pragma solidity >=0.4.22 <0.7.0;
pragma experimental ABIEncoderV2;
contract RVSC{
    uint256 d;
    mapping(bytes32=>bytes32) tempcom;
    constructor(uint256 dd) public{
        d=dd;
    }
    function setComOutside(bytes32 pkr,bytes32 pkd,bytes32 comr,bytes32 comd) public{
        tempcom[pkr]=comr;
        tempcom[pkd]=comd;
    }
    
    function verify(string memory rrr,string memory rrd,bytes32 pkr,bytes32 pkd) public{
        bytes32 comr= keccak256(abi.encodePacked(rrr,d));
        bytes32 comd= keccak256(abi.encodePacked(rrd,d));
        require(comr==tempcom[pkr],"False input from rider");
        require(comd==tempcom[pkd],"False input from driver");
        /*calculate*/
    }
    
    function CalculateDis(uint256 x1,uint256 x2,uint256 y1,uint256 y2) public returns(uint256){
        uint256 l1=(x2-x1);
        uint256 l2=(y2-y1);
        return sqrt(l1*l1+l2*l2);//float data will lost
    }
    
    function sqrt(uint x) public pure returns(uint) {
        uint z = (x + 1 ) / 2;
        uint y = x;
        while(z < y){
          y = z;
          z = ( x / z + z ) / 2;
        }
        return y;
  }
}
