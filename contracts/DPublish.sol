// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;


import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract DPublish {
    mapping(string => address) public submitted_manuscripts;
    mapping(string => uint256) public payments; //Pagamentos feitos aos revisores
    mapping(address => uint256) public wallet_funds; //Total de tokens possuídos pelos usuários
    mapping (address => string) public reviewed_links;
    mapping(address => bool) public is_reviewer;
    
    address private Editor; // Editor address
    uint256 public price; // Preço para publicação
    uint16 public review_payment; // Pagamento para o revisor
    
    address[10] reviewers;
    uint16 count_review = 0;
    
    //events
    event PaymentReceived(address from, uint256 amount);

    //errors
    error MissingFunds(uint256 requested, uint256 available);

    constructor(){
        Editor = msg.sender;
    }


    function submit_manuscript(string memory idmanuscript) public payable{
        submitted_manuscripts[idmanuscript] = msg.sender; // Usuário que publicou

        uint funds = wallet_funds[msg.sender];
        if (price > funds)// Verificando se o usuário possui saldo suficiente
            revert MissingFunds(price, wallet_funds);
        
        wallet_funds[msg.sender] -= price;// Pagamento feito
        payments[idmanuscript] = price;// Armazena pagamento
        
        emit PaymentReceived(msg.sender, price);
    }

    function set_balance(address user, uint256 value) public{
        require(msg.sender == Editor);
        wallet_funds[user] = value; //Atribuindo valor a uma determinada wallet
    }

    function set_price(uint256 n_fee) public payable{
        require(msg.sender == Editor);// Preço determinado pelo Editor
        price = n_fee;
    }


    function subscribe_to_review(address user) public{
        require(count_review <= 10, "Nao pode mais revisar");
        require(!(is_reviewer[msg.sender]==true), "Precisa se inscrever como revisor");
        reviewers[count_review] = user;
        count_review += 1 ;
        is_reviewer[user] = true;
    }


    function sent_review(string memory linkIPFS) public{
        require(is_reviewer[msg.sender]==true, "Precisa se inscrever como revisor");
        reviewed_links[msg.sender] = linkIPFS;
        pay_review(msg.sender);

    }

    function pay_review(address reviewer) private{
        wallet_funds[reviewer] += review_payment;
    }


}
