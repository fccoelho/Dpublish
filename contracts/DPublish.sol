pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

import "./DpubToken.sol";


contract DPublish {

    address public plublisher;

    mapping (address => uint) private fund;

    struct _plublisherWalet {
        address addr;
        uint amount;
    }

    constructor(){
        plublisher = msg.sender;
    }


    enum StatusDoc {unrevised, partial_review, revised}

    uint minimunRate = 10000;
    struct PublishDoc {
        address owner;
        string name;
        StatusDoc status;
        string contentLink;
        uint priority;
    }

    struct walet{
        PublishDoc[] myDocs;
        uint NumberOfDocs;
        uint amount;
    }


    mapping(address => walet) private MyRecord;


    function newDoc(string memory _name, string memory _contentLlink, uint amount) public returns(string memory){
        require(amount>minimunRate, "Your payment is insufficient.");
        require(MyRecord[msg.sender].amount - amount>0, "Your balance is insufficient.");
        bool x = transferFrom(msg.sender,plublisher,amount);  
        if (x){
            PublishDoc memory AuxDoc = PublishDoc({
            owner: msg.sender,
            name: _name,
            status: StatusDoc.unrevised,
            contentLink: _contentLlink,
            priority: amount
        });
      
        MyRecord[msg.sender].myDocs.push(AuxDoc);
        return("Add a new doc");
        }else{
            return "Error performing the transfer";
        }
    }

    function getDocsPublic(address _address) public view returns(PublishDoc[] memory){

        uint j=0;
        uint i = 0;
        uint len = MyRecord[_address].NumberOfDocs ;

        PublishDoc[] memory aux = new PublishDoc[](len);
        
        for (; j < len; j = j+1) {  
            if (MyRecord[_address].myDocs[j].status == StatusDoc.revised){
                aux[i] = MyRecord[_address].myDocs[j];
            }      
            i = i+1;
        }

        return aux; 

    } 

    function balanceOf(address owner) public view returns(uint) {
        return MyRecord[owner].amount;
    }
    
    function transferFrom(address from, address to, uint value) public returns(bool) {
        require(balanceOf(from) >= value, 'Your balance is insufficient.');
        MyRecord[to].amount += value;
        MyRecord[from].amount -= value;
        emit Transfer(from, to, value);
        return true;
    }
    

    function revised(PublishDoc memory doc, address reviewer) public returns(bool){
        if(doc.status == StatusDoc.revised){
            return false;
        }
        else {
            bool x = transferFrom(plublisher,reviewer,doc.priority*2/5);
            if (doc.status == StatusDoc.unrevised && x){
                doc.status = StatusDoc.partial_review; 
            }else if(doc.status==StatusDoc.partial_review && x){
                doc.status = StatusDoc.revised;
            }
            return x;
        }
    } 

    event Transfer(address indexed from, address indexed to, uint value);

    event CreateDoc(string indexed _name,string indexed _contentLlink,int amount);



}