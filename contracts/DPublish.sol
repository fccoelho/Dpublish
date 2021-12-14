// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./DPubToken.sol";
import "./ReviewToken.sol";
import "./PaperToken.sol";

import "@openzeppelin/contracts/utils/Context.sol";



contract DPublish is Context{
    mapping(string => address) public submited_manuscripts;
    mapping(address => uint256) public balances; ///Quantiedade de DPTK por usuario
    mapping(string => uint256) public bounties; //pagamentos para revisores
    
    //Processo de Revisao
    mapping(string => address) public review1_manuscripts;//artigos revisados uma vez
    mapping(string => address) public review2_manuscripts;//artigso revisados duas vezes
    mapping(address => bool) public reviewers;// Lista de revisores
    mapping(string => uint) public review_qtd; // Quantidade de vezes que o manuscrito foi revisado
    mapping(string => bool) public reviewing; // mostra se o arquivo ta sendo revisado
    mapping(string => bool) public  published;//arquivos publicados

    address private Editor;//Quem vai iniciar o dpublish
    uint256 public publishing_fee; //preco pra publicar

    //events
    event PaymentReceived(address from, uint256 amount);
    //errors
    error NotEnoughFunds(uint256 requested, uint256 avaible);

    constructor(){
        Editor = msg.sender;
    }

    //Envia manuscrito
    function submit_manuscript(string memory idmanuscript) public payable{
        submited_manuscripts[idmanuscript] = msg.sender;
        uint balance = balances[msg.sender];
        if (balance < publishing_fee)
            revert NotEnoughFunds(publishing_fee, balance);
        balances[msg.sender] -= publishing_fee;
        bounties[idmanuscript] = publishing_fee;

        //nao esta sendo revisado
        review_qtd[idmanuscript] = 0;
        reviewing[idmanuscript] = false;
        published[idmanuscript] = false;

        emit PaymentReceived(msg.sender, publishing_fee);
    }

    //Editor pode mudar o preco do fee
    function set_fee(uint256 fee) public payable{
        require(msg.sender == Editor);
        publishing_fee = fee;
    }


    //revisor se inscreve

    function subscribe_reviewer()public {
        reviewers[msg.sender] =  true;   
    }

    //Revisor comeca a revisao, pode ser a primeira ou segunda

    function start_review(string memory idmanuscript, bool review_1) public {
        //precisa que o msg.sender seja um revisor
        require(reviewers[msg.sender] == true,"Only Reviewers");
        //O manuscrito não pode ter sido publicado
        require(published[idmanuscript] = false,"This manuscript has been published");
        //se for a primeira revisao
        if(review_1){
            //manuscrito precisa ter 0 revisoes
            require(review_qtd[idmanuscript] == 0, "You cannot review this manuscript");
            //manuscrito nao pode estar sendo revisado
            require(reviewing[idmanuscript] == false, "This manuscript is being revised");
            //adiciona que o manuscrito esta sendo revisado
            reviewing[idmanuscript] = true;
            //adiciona o endereco do revisor 
            review1_manuscripts[idmanuscript] = msg.sender;
        }
        //segunda revisao
        else{
            //o manuscrito precisa ter sido revisado 1 vez
            require(review_qtd[idmanuscript] == 1, "This manuscript is being revised");
            //o manuscrito nao pode estar sendo revisado
            require(reviewing[idmanuscript] == false, "This manuscript is being revised");
            //o msg.sender nao pode ser o primeiro revisor
            require(review1_manuscripts[idmanuscript] != msg.sender,"You cannot review this manuscript");
            //adiciona que o manuscrito esta sendo revisado
            reviewing[idmanuscript] = true;
            //adiciona o endereco do revisor
            review2_manuscripts[idmanuscript] = msg.sender;


        }

    }

    function finish_review(string memory idmanuscript, bool review_1) public{
        //O artigo precisa estar sendo revisado
        require(reviewing[idmanuscript] = true, "This manuscript is not being revised");

        //Caso for a primeira revisão
        if(review_1){
            //Apenas a pessoa que esta revisando o arquivo pode finalizar
            require(review1_manuscripts[idmanuscript] == msg.sender,"You cannot finish this review");
            //Incrementa 1 na quantidade de revisoes
            review_qtd[idmanuscript] += 1;
            //informa que o arquivo nao esta sendo mais revisado
            reviewing[idmanuscript] = false;
            //pay reviewr DPTK and RTK
        }
        else{
            //Apenas a pessoa que esta revisando o arquivo pode finalizar
            require(review2_manuscripts[idmanuscript] == msg.sender,"You cannot finish this review");
            //Incrementa 1 na quantidade de revisoes
            review_qtd[idmanuscript] += 1;
            //informa que o arquivo nao esta sendo mais revisado
            reviewing[idmanuscript] = false;
            //informa que o artigo foi publicado
            published[idmanuscript] = true;
            
            //FALTA: pay reviewr DPTK and RTK
            //FALTA: paper token  pro autor

        }


    }



}