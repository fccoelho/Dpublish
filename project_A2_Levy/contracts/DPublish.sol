// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Address.sol";

import "./DPubToken.sol";
import "./PaperToken.sol";
import "./ReviewToken.sol";

contract DPublish {

    mapping(string => address) public submitted_manuscripts; ///Armazena no dicionário os endereços
    mapping(address => uint256) public balances; ///Quantidade de DPubTokens que o usuário possui
    mapping(string => uint256) public bounties; ///Armazena o pagamento para revisores
    mapping(address => string) public review_archive; ///Armazena as revisões. O revisor manda um link com arquivo com a revisão, e o review_archive armazena os links
    mapping(address => bool) public is_reviewer; ///Diz se o usuário é revisor

    address private Editor; ///Endereço do editor
    uint256 public publishing_fee; ///Taxa mínima para publicar um artigo
    uint16 public review_time; ///Tempo para completar uma revisão
    uint16 public review_payment; ///Pagamento para o revisor

    address[10] reviewers; ///Endereço dos revisores
    uint16 count_review = 0; ///Contagem de revisões

    ///Eventos:
    event PaymentReceived(address from, uint256 amount); ///Aviso de pagamento recebido
    event Transfer(address indexed from, address indexed to, uint value); ///Transferência
    ////Erros:
    error NotEnoughFunds(uint256 requested, uint256 available); ///Falta de tokens suficientes para pagamento

    constructor(){
        Editor = msg.sender; ///Guarda o endereço do autor
    } 

    //struct Ratings{
    //    string dt_contents;
    //    int dt_rating;
    //}

    //struct Writer_review{
    //    mapping(bytes32 => Ratings) datas;
    //}

    //address writer;
    //mapping(address => Writer_review) reviews;

    function submit_manuscripts(string memory idmanuscript) public payable{
        submitted_manuscripts[idmanuscript] = msg.sender;  ///Armazena o endereço de quem publicou
        uint balance = balances[msg.sender]; ///Pega o saldo do usuário
        if (balance < publishing_fee) 
            revert NotEnoughFunds(publishing_fee, balance); ///Caso o saldo seja insuficiente
        balances[msg.sender] -= publishing_fee; ///Desconta a taxa de publicação
        bounties[idmanuscript] = publishing_fee; ///Armazena o novo saldo
        emit PaymentReceived(msg.sender, publishing_fee);

    }

    function set_fee(uint256 fee) public payable{
        require(msg.sender == Editor); ///Publica o artigo caso o expedidor do contrato seja o editor
        publishing_fee = fee; ///Atribui uma taxa
    }

    function set_balance(address user, uint256 value) public{
        require(msg.sender == Editor);
        balances[user] = value; ///Atribui um saldo ao usuário
    }

    function subscribe_to_review(address user) public{
        require(count_review <= 10, "Nao pode mais revisar"); ///Inscrição de revisores. Se tiver revisto mais de 10 artigos, é impossível rever mais
        require(!(is_reviewer[msg.sender]==true), "Precisa se inscrever como revisor");
        reviewers[count_review] = user; 
        count_review += 1 ;
        is_reviewer[user] = true;
    }

    function sent_review(string memory linkIPFS) public{
        require(is_reviewer[msg.sender]==true, "Precisa se inscrever como revisor"); ///Envio de revisão
        review_archive[msg.sender] = linkIPFS;
        balances[msg.sender] -= review_payment; ///Desconta o valor do pagamento para evitar pagamentos adicionais
        pay_review(msg.sender);

    }

    //function exist_review(address id, bytes32 metadata) public{ ///constant returns(int){
    //    if (reviews[id].datas[metadata].dt_rating==0){
    //        return 0;
    //        }
    //    else{
    //         return 1;
    //    }
    //}

    //function set_review(bytes32 metadata, string memory contents, int rating)
    //public returns(int){
    //    writer = msg.sender;
    //    reviews[writer].datas[metadata].dt_contents = contents;
    //    reviews[writer].datas[metadata].dt_rating = rating;
    //    return 1; 
    //}

    function pay_review(address reviewer) private{
        balances[reviewer] += review_payment; ///Paga a revisão
    }

    function get_review(address reviewer) public{
        review_archive[reviewer]; ///Pega a revisão
    }

    ///function get_review(address id, bytes32 metadata) public returns(string){ ///public constant returns(string){
    ///    return (reviews[id].datas[metadata].dt_contents);
    ///}

    ///function get_rating(address id, bytes32 metadata) public returns(int){ ///public constant returns(int){
    ///    return (reviews[id].datas[metadata].dt_rating);
    ///}

}
