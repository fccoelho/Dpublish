// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract DPublish is Context{

    mapping(string => address) public submitted_manuscripts;
    mapping(address => uint256) public balances; ///Quantidade de DPubTokens que o usuário possui
    mapping(string => uint256) public bounties; ///Pagamento para revisores
    address private Editor;
    uint256 public publishing_fee; ///Taxa mínima para publicar um artigo
    uint16 public review_time; ///Tempo para completar uma revisão
    ///Eventos:
    event PaymentReceived(address from, uint256 amount); ///Aviso de pagamento recebido
    ////Erros:
    error NotEnoughFunds(uint256 requested, uint256 available); ///Erro por falta de tokens suficientes para pagamento

    constructor(){
        Editor = msg.sender;
    } 

    function submit_manuscripts(string memory idmanuscript) public payable{
        submitted_manuscripts[idmanuscript] = msg.sender;
        uint balance = balances[msg.sender];
        if (balance < publishing_fee)
            revert NotEnoughFunds(publishing_fee, balance);
        balances[msg.sender] -= publishing_fee;
        bounties[idmanuscript] = publishing_fee;
        emit PaymentReceived(msg.sender, publishing_fee);

    }

    function set_fee(uint256 fee) public payable{
        require(msg.sender == Editor);
        publishing_fee = fee;
    }

    function set_balance(address user, uint256 value) public {
        require(msg.sender == Editor);
        balances = balances;
    }

}