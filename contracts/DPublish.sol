// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./DPubToken.sol";
import "./ReviewToken.sol";
import "./PaperToken.sol";

import "@openzeppelin/contracts/utils/Context.sol";



contract DPublish is Context{
    //-----------------------------------------------------------------------------------------
                                      //DEFINICAO DE VARIAVEIS
    //-----------------------------------------------------------------------------------------
    mapping(string => address) public submited_manuscripts;
    mapping(string => string) public manuscripts_links;//links dos artigos
    mapping(string => uint256) public bounties; //pagamentos por artigos
    
    //Processo de Revisao
    mapping(string => address) public review1_manuscripts;//artigos revisados uma vez
    mapping(string => address) public review2_manuscripts;//artigso revisados duas vezes
    mapping(address => bool) public reviewers;// Lista de revisores
    mapping(string => uint) public review_qtd; // Quantidade de vezes que o manuscrito foi revisado
    mapping(string => bool) public reviewing; // mostra se o arquivo ta sendo revisado
    mapping(string => bool) public  published;//arquivos publicados

    address private Editor;//Quem vai iniciar o dpublish
    uint256 public WeiDPTK = 1000;// Valor escolhido(arbitrario) pra ser o Wei do DPTK  em Wei
    uint256 public publishing_fee = 1000; //preco pra publicar
    uint256 public review_fee = 250;//preco que cada revisor recebe

    //-----------------------------------------------------------------------------------------
                             //SIMULADORES DE TOKENS
    //-----------------------------------------------------------------------------------------
    
    //simulador de aperToken
    struct papertoken{
        string idmanuscript;
        address autor;
        string link;
    }

    //simulador de ReviewToken 
    struct reviewtoken{
        string idmanuscript;
        address autor;
        address reviewer;
        uint256 review_number;
        string link;
    }

    mapping(address => uint256) public wallet_dptk;
    address[] wallet_owners;// pessoas que possuem carteiras
    mapping(address => papertoken[]) public wallet_ptk;
    mapping(address => reviewtoken[]) public wallet_rtk;


    //-----------------------------------------------------------------------------------------
                                          //EVENTOS E ERROS
    //-----------------------------------------------------------------------------------------
    event PaymentReceived(address from, uint256 amount);// evento quando o pagamento e recebido
    event PaymentSent(address to, uint256 amount);//evento quando um pagamento e enviado pra um revisorS
    event PurchasedDPTK(address buyer, uint256 amount);//evento quando alguem compra tokens
    event ManuscriptRevised(address reviwer, string idmanuscript, uint review_number);//Evento quando um artigo e revisado
    event ManuscriptPublished(address autor,address reviwer_1,address reviwer_2, string idmanuscript);//Evento quando um artigo e publicado
    
    error NotEnoughFunds(uint256 requested, uint256 avaible);

    //-----------------------------------------------------------------------------------------
                                          //CONSTRUTOR
    //-----------------------------------------------------------------------------------------
    
    //Criando carteira
    function create_wallet(address owner_wallet) public {
        wallet_dptk[owner_wallet] = 0;
        wallet_ptk[owner_wallet];
        wallet_rtk[owner_wallet];
        wallet_owners.push(owner_wallet);

    }


    constructor(){
        Editor = msg.sender;
        create_wallet(Editor);
        wallet_dptk[Editor] = 1000000000;// Valor arbitrario de DPTK para o editor

    }

    //-----------------------------------------------------------------------------------------
                                          //FUNCOES AUXILIARES
    //-----------------------------------------------------------------------------------------

    //Funcao que concatena duas strings
    function concat_string(string memory a, string memory b) internal pure returns (string memory ) {

    return string(abi.encodePacked(a, b));}

    //Gera um link para o artigo mas nao deixa aberto para o publico
    function generate_link(string memory idmanuscript)public{
        //criando um link 
        manuscripts_links[idmanuscript] = concat_string("https://dpublish.org/", idmanuscript);}

    //Descobrir se uma carteira existe
    function exist_wallet_dptk(address owner_wallet)internal view returns(bool){
        for (uint256 index = 0; index < wallet_owners.length; index++) {
            if(owner_wallet == wallet_owners[index]){
                return true;}
        }
        return false;}

    //Publica artigo
    function publish_manuscript(string memory idmanuscript) internal {
        published[idmanuscript] = true;
        //Aqui seria interessante adicionar um mecanismo que publique o artigo 
        }

    //Emite ReviewToken
    function emits_reviewtoken(string memory idmanuscript, address reviewer,uint256 review_number) internal{
        require(reviewers[reviewer]==true, "Only for reviewers");
        wallet_rtk[reviewer].push(reviewtoken(idmanuscript,submited_manuscripts[idmanuscript],reviewer,review_number,manuscripts_links[idmanuscript]));
        }

    //Emite PaperToken
    function emits_papertoken(string memory idmanuscript, address autor) internal{
        wallet_ptk[autor].push(papertoken(idmanuscript,submited_manuscripts[idmanuscript],manuscripts_links[idmanuscript]));}

    //Pagando DPTK  para os revisores
    function pay_reviewers(address reviewer, string memory idmanuscript) internal{
        require(reviewers[reviewer]==true, "Only for reviewers");
        wallet_dptk[reviewer] += review_fee;
        bounties[idmanuscript]-= review_fee;
        emit PaymentSent(reviewer, review_fee);}

    //-----------------------------------------------------------------------------------------
                                          //OBTER E CONFIGURAR VALORES DE PAGAMENTOS
    //-----------------------------------------------------------------------------------------

        //Editor pode mudar o preco do publishing fee
    function set_publishing_fee(uint256 fee) public{
        require(msg.sender==Editor, "You aren't Editor");
        publishing_fee = fee;
    }


        //Editor pode mudar o preco do review fee
    function set_review_fee(uint256 fee) public{
        require(msg.sender==Editor, "You aren't Editor");
        review_fee = fee;
    }

    //Ver o preco do publishing fee
    function get_publishing_fee() view public returns(uint256) {
        return publishing_fee ;

    }

    //Ver o preco do review fee
    function get_review_fee() view public returns(uint256) {
        return review_fee ;
    }

    //-----------------------------------------------------------------------------------------
                                          //COMPRA de DPubTokens
    //-----------------------------------------------------------------------------------------

     //Comprar DPubTokens
    function buy_DPTK(uint256 qtd_DPTK)public payable{
        require(msg.sender.balance >= WeiDPTK*qtd_DPTK, "You need more Weis");
        if(!exist_wallet_dptk(msg.sender)){
            create_wallet(msg.sender);
            wallet_dptk[msg.sender] += qtd_DPTK;}
        else{
            wallet_dptk[msg.sender] += qtd_DPTK;
        }
        emit PurchasedDPTK(msg.sender, qtd_DPTK);

    }

    //-----------------------------------------------------------------------------------------
                                          //SUBMISSAO DE ARTIGO
    //-----------------------------------------------------------------------------------------
    
    //Submete artigo
    function submit_manuscript(string memory idmanuscript) public payable{
        submited_manuscripts[idmanuscript] = msg.sender;
        generate_link(idmanuscript);
        uint balance = wallet_dptk[msg.sender];
        if (balance < publishing_fee)
            revert NotEnoughFunds(publishing_fee, balance);
        wallet_dptk[msg.sender] -= publishing_fee;
        bounties[idmanuscript] = publishing_fee;

        //artigo nao teve nenhuma revisao
        review_qtd[idmanuscript] = 0;
        //artigo nao esta sendo revisado
        reviewing[idmanuscript] = false;
        //artigo nao foi publicado
        published[idmanuscript] = false;

        emit PaymentReceived(msg.sender, publishing_fee);
    }


    //-----------------------------------------------------------------------------------------
                                    //PROCESSO DE REVISAO
    //-----------------------------------------------------------------------------------------

    //revisor se inscreve
    function subscribe_reviewer()public {
        if(!exist_wallet_dptk(msg.sender)){
            create_wallet(msg.sender);}
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
            emits_reviewtoken(idmanuscript,msg.sender, 1);
            pay_reviewers(msg.sender,idmanuscript);
            //emitindo evento
            emit ManuscriptRevised(msg.sender, idmanuscript, 1);
        }
        else{
            //Apenas a pessoa que esta revisando o arquivo pode finalizar
            require(review2_manuscripts[idmanuscript] == msg.sender,"You cannot finish this review");
            //Incrementa 1 na quantidade de revisoes
            review_qtd[idmanuscript] += 1;
            //informa que o arquivo nao esta sendo mais revisado
            reviewing[idmanuscript]  =  false;
            //informa que o artigo foi publicado
            publish_manuscript(idmanuscript);
            //pay reviewer DPTK and RTK
            emits_reviewtoken(idmanuscript,msg.sender, 1);
            pay_reviewers(msg.sender,idmanuscript);
            //paper token  pro autor
            emits_papertoken(idmanuscript, submited_manuscripts[idmanuscript]);
            //emitindo os eventos
            emit ManuscriptRevised(msg.sender, idmanuscript, 2);
            emit ManuscriptPublished(submited_manuscripts[idmanuscript], review1_manuscripts[idmanuscript],review2_manuscripts[idmanuscript], idmanuscript);

        }


        }



}