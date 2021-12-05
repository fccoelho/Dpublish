// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract DPublish {
    // "Convertendo" string para um endereço
    mapping(string => address) public submitted_manuscripts;
    // Total de tokens que o usuario possui
    mapping(address => uint256) public balances;
    // Pagamentos para os revisores
    mapping(string => uint256) public bounties;

    address private Editor;

    uint256 public publishing_fee;

    uint16 public review_time;

    // Eventos
    event PaymentReceived(address from, uint256 amount);
    
    ///Erro
    error NotEnoughFunds(uint256 requested, uint256 available);

    constructor(){
        Editor = msg.sender;
    }

    function submit_manuscript(string memory idmanuscript) public payable{
        // Armazenando o endereço do usuário
        submitted_manuscripts[idmanuscript] = msg.sender;
        // Adquirindo o saldo em conta do usuário
        uint balance = balances[msg.sender];
        // Verificando se o usuário possui saldo suficiente
        if (balance < publishing_fee) 
        // Retornando erro caso falte saldo
            revert NotEnoughFunds(publishing_fee, balance);
        
        // Retirando o saldo cliente
        balances[msg.sender] -= publishing_fee;
        // Salvando a quantidade paga
        bounties[idmanuscript] = publishing_fee;
        
        emit PaymentReceived(msg.sender, publishing_fee);
    }

    function set_fee(uint256 fee) public payable{
        require(msg.sender == Editor);
        publishing_fee = fee;
    }

    // function set_balance(address user, uint256 valeu) public{
    //     require(msg.sender == Editor);
    // }

}