// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract DPublish {
    mapping(string => address) public submitted_manuscripts;
    mapping(address => uint256) public balancos; 
    mapping(string => uint256) public recebido; 
    mapping(address => string) public revisoes;
    mapping(address => bool) public revisado;

    address private instance;
    uint256 public taxa_post;
    uint16 public tempo_rev;
    uint16 public revisar_pagamento;

    address[10] revisores;
    uint16 contador = 0;

    event receberPagamentos(address origem, uint256 quantidade);
    error SemFundos(uint256 pedido, uint256 disponivel);

    constructor(){
        instance = msg.sender;
    } 

    // Não tenho tenho certeza se o tipo da função é payable
    function submit_manuscripts(string memory idmanuscript) public payable{
        submitted_manuscripts[idmanuscript] = instance;
        uint balanco = balancos[instance];
        if (balanco < taxa_post)
            revert SemFundos(taxa_post, balanco);
        balancos[instance] = balancos[instance] - taxa_post;
        recebido[idmanuscript] = taxa_post;
    }
    function taxa(uint256 taxa_) public payable{
        require(
            msg.sender == instance);
        taxa_post = taxa_;
    }
    function def_balanco(address usuario, uint256 valor) public{
        require(
            msg.sender == instance);
        balancos[usuario] = valor;
    }
    function para_revisar(address usuario) public{
        require(
            contador <= 10, "Alcancou o limite"); 
        require(
            !(revisado[msg.sender] == true), "Nao cadastrado");
        revisores[contador] = usuario; 
        contador += 1 ;
        revisado[usuario] = true;
    }
    function enviar_revisao(string memory linkIPFS) public{
        require(revisado[msg.sender] == true, "Nao cadastrado");
        revisoes[msg.sender] = linkIPFS;
        balancos[msg.sender] -= revisar_pagamento;
        pagar_revisao(msg.sender);

    }
    function pagar_revisao(address revisor) private{
        balancos[revisor] += revisar_pagamento;
    }
    function revisar(address revisor) public view{
        revisoes[revisor];
    }

}