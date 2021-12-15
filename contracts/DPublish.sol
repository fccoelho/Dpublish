// SPDX-License-Identifier: MIT
// pragma solidity ^0.8.2;
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Address.sol";
//^^import bibs
contract DPublish {
    mapping(string => address) public submitted_manuscripts;
    //^^Manuscritos submetidos
    mapping(string => uint256) public values; 
    //^^Pagamentos para revisar
    mapping(address => uint256) public digital_bag; 
    //^^Carteira digital do user
    mapping (address => string) public review_document;
    //^^Review_document
    mapping(address => bool) public is_reviewer;
    //^^Reviewer determinado

    address private Editor; 
    //^^Editor address
    uint256 public fee; 
    //^^Fee para publi
    uint16 public review_payment; 
    //^^ReviewPagamento ao revisor

    address[10] reviewers;
    //^^Address dos reviewers
    uint16 count_review = 0;
    //^Conta review_

    event PaymentReceived(address from, uint256 amount);
    //^^Alerta para pagamento recebido

    error LowFundsOnBag(uint256 requested, uint256 available);
    //^^Declarando erro

    constructor(){
        Editor = msg.sender;
        //^^Endereço do autor
    }

    function submit_manuscript(string memory idmanuscript) public payable{
        submitted_manuscripts[idmanuscript] = msg.sender; 
        //^^Usuário publicou
        uint funds = digital_bag[msg.sender];
        //^^Fundo na Bag
        if (fee > funds)
        //^^Checando fundos na bag
            revert LowFundsOnBag(fee, funds);
            //^^Sem fundo na bag :(
        digital_bag[msg.sender] -= fee;
        // ^^Pagamento feito, debitando
        values[idmanuscript] = fee;
        // ^^Armazena fundo restante
        emit PaymentReceived(msg.sender, fee);
    }

    function set_balance(address user, uint256 value) public{
        require(msg.sender == Editor);
        digital_bag[user] = value; 
        //^^Tomando um fundo para a bag determinada
    }

    function set_fee(uint256 n_fee) public payable{
        require(msg.sender == Editor);
        fee = n_fee;
        //^^Taxa determinada
    }

    function subscribe_to_review(address user) public{
        require(count_review <= 10, "Nao pode mais revisar");
        //^^Set limite de reviews
        require(!(is_reviewer[msg.sender]==true), "Precisa se inscrever como revisor");
        //^^Verifica incrição como revisor
        reviewers[count_review] = user;
        count_review += 1 ;
        //^^Soma review_
        is_reviewer[user] = true;
    }

    function sent_review(string memory linkIPFS) public{
        require(is_reviewer[msg.sender]==true, "Precisa se inscrever como revisor");
        review_document[msg.sender] = linkIPFS;
        digital_bag[msg.sender] -= review_payment;
        //^^Inibe multiplos pagamentos
        pay_review(msg.sender);
    }

    function pay_review(address reviewer) private{
        digital_bag[reviewer] += review_payment;
        //^^Pay revisão
    }
}