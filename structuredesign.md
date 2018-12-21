/** 
 *  마켓용 컨트렉트
 * 옥션 등록하기	-> auctionItem
옥션 시작하기 -> startAuction
옥션 상태보기 -> statusAction
옥션 지우기 -> deleteAuction
블랙리스트 -> blackList
경매중 갯수 -> biddingCount
낙찰 총금액 -> totalPrice
낙찰 최고금액 -> higestPrice
거래중 리스트 -> biddigList
거래마감 리스트 -> closedAuction
 
 * 
 * 
 * **/
 
 contract onTheBlock {
   
   
/**
물품용 컨트랙트 -> items
물품명 -> itemName
물품가격 -> biddingPrice
설명 -> descrpition
원래주인 -> originOwner
새주인  -> newOwner
판매여부 -> isSold
상품스펙-> itemSpec

*/  
     struct items {
      
      string itemName;
      uint128 biddingPrice;
      string descrpition;
      address originOwner;
      address newOwner;
      bool isSoldOut;
      string itemSpec;
      
     }
     
     mapping (address => int256) internal blackList;

     
     constructor() public{
         
     }
     
     function startAuction(){
         
     }
     
     function statusAuction(){
         
     }
     
     function deleteAuction(){
         
     }
     
     function totalPrice(){
         
     }
     
 }
 
 /**
  *
  * 
  ***/
  
  
 

/**
 * 회원용 컨트랙트 -> member
이름 -> name
계좌 -> account
잔고 -> balanceof
판매자 / 구매자 -> isSeller , isBuyer
상품 여부 -> hasItems
블랙리스트여부 -> areyouBlack

 * */
 
 contract member is ERC721Basic, Ownable{
     
     address public _owner;
     address public account;
     uint256 public balance;
     bool public isSeller;
     bool public isBuyer;
     bool public hasItems;
     bool public areyouBlack;
     
     constructor(address owner) public {
         _owner = owner;
     }
     
     
 }
 
 /**
  * 경매용컨트랙트 -> bidding
경매ID -> biddingID
판매중 상품 시가 -> currentPrice
판매 시작 -> startBidding
판매 종료 -> endBidding
구매자 리스트 -> bidderList
종료시간 -> closeTimeBidd
낙찰가 -> bidPrice

  **/
 
 contract bidding{
     
    
     
     
 }
 
 /**
 코인발행용 컨트랙트 ->  NegoBank
계좌 -> Naccount
잔고 -> balanceOf
입금 -> apporve
출금 -> transfer 
발행  -> ‘NEB’
시가조회 -> howMuchCurrency

 */
 
 contract NegoBank{
     
 }


```
url 입장
  블랙리스트
   account [] 
   등록
   삭제
   * 가스비는 owner가 충당

  블랙리스트 여부 확인 기능

  등록자
    - id
    - pw
    - account
    - balance
    - 구분 ( 등록자 / 구매자 )

  등록을 누른다.
  경매에 올릴 상품 정보를 입력한다.
    상품정보
    - 상품이름
    - 상품가격
    - 설명
    - 주인 ( 자동입력) owner
    - 판매여부 
    - 기타 상품스펙
  상품등록을 마치면 등록된 상품리스트가 뜨고 시작, 취소 버튼 이 있다.
  시작 버튼을 누른다. 24시간 흐름
  희망가격을 입력한다.
  시작시간과 종료시간이 자동 등록된다. 24시간 후에 종료
  구매자 리스트 배열이 생성된다.-> 가격비교 최고가가 시간내 치환
   -> 구매자 account 로 연결
  -> 거래 시작! 시장상회 중앙관리 거래 카운터 증가.add(1);

 구매자
  url 입장
  등록된 상품 리스트를 볼수 있다.
  -경매현황
    - 경매 내용
    - 현재 경매참여자 수
    - 남은시간 -> js로 1초단위 갱신 -> 1시간 혹은 시간단위별 '마감임박' 표시
     
  원하는 경매 참여 버튼 클릭
    - 금액 입력
    - 참여버튼 클릭

  해당 상품 경매 종료시
   - 최고가 낙찰
    - 낙찰자 알림 (참여자 전체, 금액)
    - 판매자한테 배송처리 요청 12시간안에
      - 12시간안에 배송처리 안되면 블랙리스트 등재
      - 참여자에게 환불
    - 판매자 배송절차 완료후 배송 완료
    
    - 낙찰차 계좌에서 중간관리자 계좌로 입금처리
    - 중간관리자 홀딩
    
    - 배송처리 받음
    - 낙찰자 계좌 입금처리

  -> 거래 완료! 시장상회 중앙관리 거래 카운터 감소.div(1);
               - 거래 금액 시장상회 중앙관리 거래 금액 add(금액); 실제 거래가 아닌 금액 카운트를 위한 int값
               - 거래금액별 산정 ranking 추산 역대 순위 -> 판매자, 낙찰자, 거래금액, 거래내용
  
    시장상황
     - 전체 거래 갯수
     - 전체 낙찰금액 : total
     - 최고 낙찰금액 : 순위 10위~
     - 거래중
     - 거래마감

    코인발행
    - Owner
     - 계좌
     - 잔고
     - 입급
     - 출금
     - 발행 NEB
     - 시가조회 : kiber network
    -

화면 UI 
 전체 메인 화면
  -> 거래 등록
  -> 상품 등록

  -> 거래참여
  -> 시장상회 ( 관리자 admin)
   전체 거래수 cms 페이지
    - 거래중
    - 전체 낙찰금액유
      - 오늘, 1주일, 한달, 분기, 올해 별
    - 최고 낙찰가 
      - 1위 ~ 10위 시간별
    - 현재 거래중
    - 거래 마감

    블랙리스트 
     - 사유
 ```