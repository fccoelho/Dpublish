// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract DPublish {

    mapping(string => address) public submitted_manuscripts;
    mapping(address => uint256) public wallet_amount; // armazena o total da carteira
    mapping (address => string) public review_completed; // armazena os links dos artigos revisados
    
    address private reviewr; // endereço do revisor
    uint256 public actual_fee; // taxa pela revisao
    uint256 min_fee = 10000; // taxa mínima
    // no futuro, este valor deverá ser mutável por um usuáio com permissão (comitê)
    
    event PaymentReceived(address from, uint256 amount);

    constructor(){
        // o autor do contrato é o revisor
        reviewr = msg.sender;
    }

    function submit_manuscript(string memory idmanuscript) public payable{
        
        submitted_manuscripts[idmanuscript] = msg.sender;

        // verifica possibilidade de pagamento
        bool payment_authorize = authorize_payment(msg.sender); 

        if (payment_authorize)
    
        // realizando pagamento da revisão:
        make_payment(msg.sender);
        
        emit PaymentReceived(msg.sender, actual_fee);
    }

    function authorize_payment(address account) public view returns (bool){
        // authorize payment
        uint256 account_amount = get_balance(account);
        require(account_amount < actual_fee, "Not enough tokens");
        return true;
    }

    function get_balance(address account) public view returns (uint) {
        // get account balance
        require(msg.sender == account , "You don't have permission for that");
        return wallet_amount[account];
    }


    function set_fee(uint256 amount) public payable{
        // set revieww fee 
        require(msg.sender == reviewr, "You don't have permission for that");
        require(amount > min_fee, "Your fee must be higher");
        actual_fee = amount;
    }

    function set_balance(address account, uint256 amount) public{
        // set wallet balance for account
        require(msg.sender == reviewr);
        wallet_amount[account] = amount;
    }

    function review_article(string memory article_link) public{
        // publica o link do artigo revisado e recebe o pagamento
        review_completed[msg.sender] = article_link;
        receive_payment(msg.sender);
    }

    function receive_payment(address reviewer) private{
        wallet_amount[reviewer] += actual_fee;
    }

    function make_payment(address author) private{
        wallet_amount[author] -= actual_fee;
    }


}