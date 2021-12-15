// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./DPubToken.sol";
import "./ReviewToken.sol";
import "./PaperToken.sol";

import "@openzeppelin/contracts/utils/Context.sol";



contract DPublish is Context{
    mapping(address => uint256) public balances; ///Quantiedade de DPTK por usuario
    mapping(string => uint256) public bounties; //pagamentos por artigos
    
    //Processo de Revisao
    
    struct manuscript{
        string id_manuscript;// id
        address autor;// autor
        address reviewer1;//revisor 1
        address reviewer2;// revisor 2
        uint review_qtd;// quantidade de revisoes
        bool reviewing;// mostra se o arquivo ta sendo revisado
        bool published;//mostra se o artigo foi publicado
    }

    mapping(string => manuscript) public manuscripts;

    // mappings antigos que foram trocados pela struct manuscript
    //mapping(string => address) public review1_manuscripts;//artigos revisados uma vez
    //mapping(string => address) public review2_manuscripts;//artigso revisados duas vezes
    //mapping(address => bool) public reviewers;// Lista de revisores
    //mapping(string => uint) public review_qtd; // Quantidade de vezes que o manuscrito foi revisado
    //mapping(string => bool) public reviewing; // mostra se o arquivo ta sendo revisado
    //mapping(string => bool) public  published;//arquivos publicados

    address private Editor;//Quem vai iniciar o dpublish
    uint256 public publishing_fee = 1000; //preco pra publicar
    uint256 public review_fee = 250;//preco que cada revisor recebe

    //events
    event PaymentReceived(address from, uint256 amount);// evento quando o pagamento e recebido
    event ManuscriptRevised(address reviwer, string idmanuscript, uint review_number);//Evento quando um artigo e revisado
    event ManuscriptPublished(address autor,address reviwer_1,address reviwer_2, string idmanuscript);//Evento quando um artigo e publicado
    //errors
    error NotEnoughFunds(uint256 requested, uint256 avaible);

    //DPubToken  private DPubTokens;
    //ReviewToken private ReviewTokens;
    //PaperToken private PaperTokens;


    constructor(){
        Editor = msg.sender;
        //DPubTokens = new DPubToken();
        //ReviewTokens  = new ReviewToken();
        //PaperTokens = new PaperToken();

    }

    //Editor pode mudar o preco do publishing fee
    function set_publishing_fee(uint256 fee) private{
        require(msg.sender == Editor);
        publishing_fee = fee;
    }

    //Ver o preco do publishing fee
    function get_publishing_fee() view public returns(uint256) {
        return publishing_fee ;
    }

        //Editor pode mudar o preco do review fee
    function set_review_fee(uint256 fee) private{
        review_fee = fee;
    }

    //Ver o preco do review fee
    function get_review_fee() view public returns(uint256) {
        return review_fee ;
    }

    //Publica artigo
    function publish_manuscript(string memory idmanuscript) public {
        manuscripts[idmanuscript].published = true;
    }

    //Emite ReviewToken
    function emits_reviewtoken(address reviewer, uint256 tokenId) public{
        //ReviewTokens.safeMint(reviewer, tokenId);

        }
    //Emite PaperToken
    function emits_papertoken(address reviewer, uint256 tokenId) public{
        //PaperTokens.safeMint(reviewer, tokenId);
        }
    
    //Envia manuscrito
    function submit_manuscript(string memory idmanuscript) public payable{
        manuscripts[idmanuscript] = msg.sender;
        uint balance = balances[msg.sender];
        if (balance < publishing_fee)
            revert NotEnoughFunds(publishing_fee, balance);
        balances[msg.sender] -= publishing_fee;
        bounties[idmanuscript] = publishing_fee;
        emit PaymentReceived(msg.sender, publishing_fee);
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
            emit ManuscriptRevised(msg.sender, idmanuscript, 2);
            emit ManuscriptPublished(submited_manuscripts[idmanuscript], review1_manuscripts[idmanuscript],review2_manuscripts[idmanuscript], idmanuscript);


            
            //FALTA: pay reviewer DPTK and RTK
            //FALTA: paper token  pro autor

        }


        }



}