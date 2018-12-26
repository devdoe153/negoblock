pragma solidity ^0.4.24;

library SafeMath {

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}


/**
 * Utility library of inline functions on addresses
 */
library AddressUtils {

  /**
   * addr 가 콘트랙트의 주소인지 아닌지를 check 함.
   *
   * Returns whether the target address is a contract
   * @dev This function will return false if invoked during the constructor of a contract,
   *  as the code is not actually created until after the constructor finishes.
   * @param addr address to check
   * @return whether the target address is a contract
   */
    function isContract(address addr) internal view returns (bool) {
        uint256 size;
    // XXX Currently there is no better way to check if there is a contract in an address
    // than to check the size of the code at that address.
    // See https://ethereum.stackexchange.com/a/14016/36603
    // for more details about how this works.
    // TODO Check this again before the Serenity release, because all addresses will be
    // contracts then.
    // solium-disable-next-line security/no-inline-assembly
        assembly { size := extcodesize(addr) }
        return size > 0;
    }

}


contract Ownable {
    address public owner;

    event OwnershipRenounced(address indexed previousOwner);
    
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() public{
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address peviousOwner, address newOwner) public onlyOwner {
        require(newOwner != address(0));
        emit OwnershipTransferred (peviousOwner, newOwner);
        owner = newOwner;
    }
    
    function renounceOwnership() public onlyOwner {
        emit OwnershipRenounced (owner);
            owner = address(0);
    }
}


// contract Members { 

//         /** @dev Member 회원.
//          * 
//          * -회원 가입한다.
//         -상품 등록한다.
//         -돈을 전송한다.
//         -돈을 받는다.
//         -탈퇴한다.
//         -경매 등록한다.
//       * @name 판매자 이름.
//       * @passwd 패스워드.
//       * @account 계좌.
//       * //@mount 잔고.
//       * @isSeller 판매자냐?.
//       * @isBuyer 바이어냐?.
//       */
    
//     struct Member{
//         string id;
//         string pw;
//         address account;
//         bytes32 IPFSHash;
        
//     }
// //    enum memberType {Buyer, Seller, Blacklist, Admin }
    
//     mapping (bytes32 => Member) member;
//     bytes32[] public members;
    
//     function applymember
//     (string _id, string _pw, address _account,  bytes32 _IPFSHash)
//     public  returns(bool){
//         var member = member[_id];
//         member.id = _id;
//         member.pw = _pw;
//         member.account = _account;
//     //    member.memberType = _memberType;
//         member.IPFSHash = _IPFSHash;
        
//         members.push(member[_id]);
        
//         return true;
            
//     }
    

    

    
// }

contract OntherBlock{
    
    address[] public auctions;
    
    function createAuction() public {
        address newAcution = new Auction(msg.sender);
        auctions.push(newAcution);        
    }
    
    
}


contract Auction is  Ownable{

    // Status variable initialized
    using SafeMath for uint256;

    
    //auctionStatus variable
    address public owner;
    uint public startBlock;
    uint public endBlock;
    string public ipfsHash;    
    
    // auctionState
    enum State {Started, Bidding, Ended, Destoryed}
    State public auctionState;
    

    uint public highestBid;
    address public highestBidder;
    
    mapping (address => uint) public bids;

 // I don't know yet when this using
    uint bidIncreament;    

    // modifiers
    modifier notOwner(){
        require(msg.sender != owner);
        _;
    }
    
    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }  
    
    modifier afterStart(){
        require(block.number >= startBlock);
        _;
    }
    
    modifier beforeEnd(){
        require(block.number <= endBlock);
        _;
    }   

    // 생성자
    constructor(address creator) public {
        owner = creator;
        auctionState = State.Bidding;
        
        startBlock = block.number;
        endBlock = startBlock + 3;
        
        ipfsHash = "";
        bidIncreament = 1000000000000000000;
    }

    //functions
    function minimul(uint a, uint b) pure internal 
    returns(uint){
        if(a <= b){
            return a;
        } else {
            return b;
        }
    }
    
    function destoryAcution() public onlyOwner {
        auctionState = State.Destoryed;
    }
    
    function Bidding() public payable 
    notOwner afterStart beforeEnd
    returns(bool)
    {
        require(auctionState == State.Bidding);
        
        uint currentBid = bids[msg.sender] + msg.value;
        
        require(currentBid > highestBid);
        
        bids[msg.sender] = currentBid;
    
        if(currentBid <= bids[highestBidder]){
            highestBid = minimul(currentBid + bidIncreament, bids[highestBidder]);        
        } else {
            highestBid = minimul(currentBid, bids[highestBidder] + bidIncreament) ;
            highestBidder = msg.sender ;
        }
        
        return true;
    }
    
    function winnerAuction() public {
        require(auctionState == State.Destoryed || block.number > endBlock );
        require(msg.sender == owner || bids[msg.sender] > 0);
        
        address winner;
        uint value;
        
        if(auctionState == State.Destoryed){
            winner = msg.sender;
            value = bids[msg.sender];
        } else {
            if(msg.sender == owner){
                winner = owner;
                value = highestBid;
            } else {
                if(msg.sender == highestBidder){
                    winner = highestBidder;
                    value = bids[highestBidder] - highestBid;
                } else {
                    winner = msg.sender;
                    value = bids[msg.sender];
                }
            }
        }
        
        winner.transfer(value);
    }
    
    
    
    
    /** @dev 생성.
      * @param _supply 토크발행량.
      * @param _name 토큰 이름 NEB.
      * @param _symbol 토큰 단위 NEB.
      * @param _decimals 소수점 이하 자릿수.
      */
    
    string public name = "NegoBlock Coin"; //token name
    string public symbol = "neb" ;  // token unit
    uint8 public decimals = 0 ; // 소수점이하
    
    uint256 public totalSupply = 1000000;
    uint256 public supply = 1000000;
    
    uint public nebDigits = 16;
    uint public nebModulus = 10 ** nebDigits;
   


    // end of Acutions 
}
