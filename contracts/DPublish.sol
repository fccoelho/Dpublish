// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract DPublish {
    // Armazena no dicionario os enderecos
    mapping(string => address) public submitted_manuscripts;
    // Armazena o total de tokens que o usuario possui
    mapping(address => uint256) public balances;
    // Dicionario que armazena o pagamento para os revisores
    mapping(string => uint256) public bounties;
    
    // Endereco do editor
    address private Editor;
    // taxa de publiacao
    uint256 public publishing_fee;
    // tempo de revisao
    uint16 public review_time;

    // Eventos
    event PaymentReceived(address from, uint256 amount);
    
    ///Erro
    error NotEnoughFunds(uint256 requested, uint256 available);

    constructor(){
        // Salvando o endereco do autor do contrato
        Editor = msg.sender;
    }


    function submit_manuscript(string memory idmanuscript) public payable{
        // Armazenando o endereço do usuário que publicou
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
        // Se o endereco for o mesmo do admnistrador, sera feita a publicação
        require(msg.sender == Editor);
        publishing_fee = fee;
    }

    function set_balance(address user, uint256 value) public{
        require(msg.sender == Editor);
        // Atribuindo um saldo
        balances[user] = value;
    }

}