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
                    //SIMULADORES DE TOKENS E CRIACAO DE UMA ESTRUTURA DE CARTEIRA
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

    //Estrutura da carteira
        struct wallet {
        uint256 DPTK;//quantidade de DPTK
        reviewtoken[] RTKs;//lista de RTKs
        papertoken[] PTKs;//lista de PTKs
        }

    mapping(address => wallet) public wallets;
    address[] wallet_owners;//lista com todos que possuem carteiras


    //-----------------------------------------------------------------------------------------
                                          //EVENTOS E ERROS
    //-----------------------------------------------------------------------------------------
    event PaymentReceived(address from, uint256 amount);// evento quando o pagamento e recebido
    event ManuscriptRevised(address reviwer, string idmanuscript, uint review_number);//Evento quando um artigo e revisado
    event ManuscriptPublished(address autor,address reviwer_1,address reviwer_2, string idmanuscript);//Evento quando um artigo e publicado
    
    error NotEnoughFunds(uint256 requested, uint256 avaible);

    //DPubToken  private DPubTokens;
    //ReviewToken private ReviewTokens;
    //PaperToken private PaperTokens;

    //-----------------------------------------------------------------------------------------
                                          //CONSTRUTOR
    //-----------------------------------------------------------------------------------------


    constructor(){
        Editor = msg.sender;
        create_wallet(msg.sender);
        wallets[msg.sender].DPTK = 1000000000;// Valor arbitrario de DPTK para o editor
        //DPubTokens = new DPubToken();
        //ReviewTokens  = new ReviewToken();
        //PaperTokens = new PaperToken();

    }

    //Funcao que concatena duas strings
    //precisa de teste
    function append(string memory a, string memory b) internal pure returns (string memory ) {

    return string(abi.encodePacked(a, b));

}

    //-----------------------------------------------------------------------------------------
                                          //FUNCOES AUXILIARES
    //-----------------------------------------------------------------------------------------


    //Gera um link para o artigo mas nao deixa publico
    function generate_link(string memory idmanuscript)public{
        //criando um link , precisa de teste
        manuscripts_links[idmanuscript] = append("https://dpublish.org/", idmanuscript);

    }

    //Criar uma carteira
    function create_wallet(address owner_wallet)internal{
    reviewtoken[] memory rtk;
    papertoken[] memory ptk;
    wallets[owner_wallet] = wallet(0,rtk,ptk);
    wallet_owners.push(owner_wallet);
    }


    //Descobrir se uma carteira existe
    function exist_wallet(address owner_wallet)internal view returns(bool){
        for (uint256 index = 0; index < wallet_owners.length; index++) {
            if(owner_wallet == wallet_owners[index]){
                return true;}
        }
        return false;
    }

    //Editor pode mudar o preco do publishing fee
    function set_publishing_fee(uint256 fee) private{
        require(msg.sender == Editor);
        publishing_fee = fee;
    }


        //Editor pode mudar o preco do review fee
    function set_review_fee(uint256 fee) private{
        review_fee = fee;
    }

    //Publica artigo
    function publish_manuscript(string memory idmanuscript) internal {
        published[idmanuscript] = true;
    }

    //Emite ReviewToken
    function emits_reviewtoken(string memory idmanuscript, address reviewer,uint256 review_number) internal{
        //ReviewTokens.safeMint(reviewer, tokenId);
        wallets[reviewer].RTKs.push(reviewtoken(idmanuscript,submited_manuscripts[idmanuscript],reviewer,review_number,manuscripts_links[idmanuscript]));
        }

    //Emite PaperToken
    function emits_papertoken(string memory idmanuscript, address autor) internal{
        //PaperTokens.safeMint(reviewer, tokenId);
        wallets[autor].PTKs.push(papertoken(idmanuscript,submited_manuscripts[idmanuscript],manuscripts_links[idmanuscript]));
        }

    //Pagando DPTK  para os revisores
    function pay_reviewers(address reviewer) internal{
        require(reviewers[reviewer]==true, "Only for reviewers");
        wallets[reviewer].DPTK += review_fee;

    }

    //-----------------------------------------------------------------------------------------
                                          //OBTER VALORES DE PAGAMENTOS
    //-----------------------------------------------------------------------------------------

    //Ver o preco do publishing fee
    function get_publishing_fee() view public returns(uint256) {
        return publishing_fee ;

    }

    //Ver o preco do review fee
    function get_review_fee() view public returns(uint256) {
        return review_fee ;
    }

    //-----------------------------------------------------------------------------------------
                                          //COMPRAR DPubTokens
    //-----------------------------------------------------------------------------------------




     //Comprar DPubTokens
    function buy_DPTK(uint256 qtd_DPTK)public payable{
        require(msg.sender.balance >= WeiDPTK*qtd_DPTK, "You need more Weis");
        if(exist_wallet(msg.sender)){
            wallets[msg.sender].DPTK += qtd_DPTK;
            //nao sei como tirar o valor do msg.sender.balance
            //msg.sender.balance -= WeiDPTK*qtd_DPTK;
        }
        else{
            //Criando uma carteira
            create_wallet(msg.sender);
            //Adicionando o endereco do comprador na lista de proprietarios de carteira
            wallets[msg.sender].DPTK += qtd_DPTK;
            //nao sei como tirar o valor do msg.sender.balance
            //msg.sender.balance -= WeiDPTK*qtd_DPTK;

        }

    }

    //-----------------------------------------------------------------------------------------
                                          //ENVIAR MANUSCRITO
    //-----------------------------------------------------------------------------------------

    
    //Envia manuscrito
    function submit_manuscript(string memory idmanuscript) public payable{
        submited_manuscripts[idmanuscript] = msg.sender;
        generate_link(idmanuscript);
        uint balance = wallets[msg.sender].DPTK;
        if (balance < publishing_fee)
            revert NotEnoughFunds(publishing_fee, balance);
        wallets[msg.sender].DPTK -= publishing_fee;
        bounties[idmanuscript] = publishing_fee;

        //nao esta sendo revisado
        review_qtd[idmanuscript] = 0;
        reviewing[idmanuscript] = false;
        published[idmanuscript] = false;

        emit PaymentReceived(msg.sender, publishing_fee);
    }


    //-----------------------------------------------------------------------------------------
                                    //PROCESSO DE REVISÃO
    //-----------------------------------------------------------------------------------------

    //revisor se inscreve
    function subscribe_reviewer()public {
        //Criando uma carteira
        if(!exist_wallet(msg.sender)){
            //Criando a carteira
            create_wallet(msg.sender);
            //Adicionando o endereco do comprador na lista de proprietarios de carteira
        }
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
            pay_reviewers(msg.sender);
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
            pay_reviewers(msg.sender);
            //paper token  pro autor
            emits_papertoken(idmanuscript, submited_manuscripts[idmanuscript]);
            //emitindo os eventos
            emit ManuscriptRevised(msg.sender, idmanuscript, 2);
            emit ManuscriptPublished(submited_manuscripts[idmanuscript], review1_manuscripts[idmanuscript],review2_manuscripts[idmanuscript], idmanuscript);

        }


        }



}