pragma solidity >=0.7.0 <0.9.0;
pragma abicoder v2;

contract mortgagePayment {
    
    //Variables
    
    enum State{Created, Awaiting_Mortgage_Payment, Awaiting_Confirmation, Complete}
    
    State public currState;
    bool public isBuyerActive;
    bool public isSellerActive;
    
    uint public price;
    
    address public buyer;
    address payable public seller;
    
    //Modifiers
    
    modifier onlyBuyer() {
       require(msg.sender == buyer, "Only buyer can call this function");
       _;
    }
    
    modifier mortgageNotStarted(){
        require(currState == State.Created);
        _;
    }
    
    
    //Functions
    constructor (address _buyer, address payable _seller, uint _price){
        buyer = _buyer;
        seller = _seller;
        price = _price * (1 ether);
    }
    
    function startMortgage() mortgageNotStarted public {
        if(msg.sender == buyer) {
            isBuyerActive = true;
        }
        if(msg.sender == seller) {
            isSellerActive = true;
        }
        if (isBuyerActive && isSellerActive){
            currState = State.Awaiting_Mortgage_Payment;
        }
    }
    
    function deposit() onlyBuyer public payable {
        require(currState == State.Awaiting_Mortgage_Payment, "Already paid");
        require(msg.value == price, "Wrong deposit amount");
        currState == State.Awaiting_Confirmation;
        
    }
    //transfer funds to seller - loaner
    
    function paymentConfirmation() onlyBuyer public payable {
        require(currState == State.Awaiting_Confirmation, "Awaiting confirmation");
        seller.transfer(price);
        currState == State.Complete;
    }
    
    function withdraw() onlyBuyer public payable {
        require(currState == State.Awaiting_Mortgage_Payment, "Cannot withdraw at this time");
        payable(msg.sender).transfer(price);
        currState == State.Complete;
    }
    
}
