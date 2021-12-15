// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract DPublish {
    mapping(string => address) public artigos_enviados;
    mapping(address => uint256) public balancos; 
    mapping(string => uint256) public recebido; 
    mapping(address => string) public revisoes;
    mapping(address => bool) public revisado;

    address private instance;
    uint256 public taxa_post;
    uint16 public revisar_pagamento;

    address[10] revisores;
    uint16 contador = 0;

    event ReceberPagamentos(address origem, uint256 quantidade);
    error SemFundos(uint256 pedido, uint256 disponivel);

    constructor(){
        instance = msg.sender;
    } 

    function enviar_artigo(string memory idartigo) public payable{
        artigos_enviados[idartigo] = instance;
        uint balanco = balancos[instance];
        if (balanco < taxa_post)
            revert SemFundos(taxa_post, balanco);
        balancos[instance] = balancos[instance] - taxa_post;
        recebido[idartigo] = taxa_post;
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
            contador <= 10, "Alcancou o limite"
            // A função termina aqui
        );
        require(
            !(revisado[msg.sender] == true), "Revisor nao cadastrado"
            // A função termina aqui
        );
        revisores[contador] = usuario; 
        contador += 1 ;
        revisado[usuario] = true;
    }
    function enviar_revisao(string memory valor_pago) public{
        require(revisado[msg.sender] == true, "Revisor nao cadastrado");
        revisoes[msg.sender] = valor_pago;
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