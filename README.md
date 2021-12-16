# DAPH: Decentralized Autonomous Publishing House.
Sistema de publicação de artigos distribuída baseada [neste artigo](https://www.scielo.br/j/mioc/a/pGbLcFHfhKGvXvTYPcGrfWw/?lang=en)

Esta solução não implementa o modelo do artigo de referência por completo.

## Ferrametas
Foram utilizados:

1. [Truffle](https://www.trufflesuite.com/docs/truffle/getting-started/creating-a-project)
2. [Open Zeppelin](https://github.com/openzeppelin/openzeppelin-contracts)

## Sistema
Os [contratos](contracts) do sistema foram detalhados abaixo. Em cada descrição foram incluidas notas sobre as modificações realizadas, caso haja: 

### DPublish
Contrato para as transações de tokens. 

Nesta implementação, criei funções para:

1. *(submit_manuscript)*: permite que o autor submeta seu artigo para publicação, por meio do pagamento da taxa definida pelo revisor (que publicou o contrato);
2. *(authorize_payment)*: verifica se a conta possui o valor necessário para pagamento da taxa;
3. *(get_balance)*: retorna o saldo da conta
4. *(set_fee)*: define a taxa da revisão;
5. *(set_balance)*: define o saldo de uma conta;
6. *(review_article)*: permite que o revisor publique o link para do artigo revisado e receba seu pagamento;
7. *(receive_payment)*: realiza a transação para o revisor
8. *(make_payment)*: remove o valor pago da conta do autor
9. *(assign_reviewer)*: designa revisores para o manuscrito

As funções acima também possuem alguns comentário em [DPublish.sol](contracts/DPublish.sol), mas, no geral, sua implementação é simples, permitindo fácil entendimento.

*Obs: Os contratos abaixo não sofreram modificações, por isso mantem-se a descrição original*
### DPubGovernor
Contrato que definirá a API que representa o workflow de todo o sistema de publicação.

### DPubToken
Contrato de criação de tokens, utilizado para a remuneração das tarefas. 

### PaperTokes
Registrará publicações aceitas pelos revisores. 

### ReviewToken
Cria um contrato não-fungível que fará o papel de certificado de revisão. 


## Dificuldades

Uma vez que não finalizei a implementação de todos os contratos, tive dificuldades em realizar as suas devidas conexões como no diagrama. Naturalmente, como esperado, tive dificuldades em traduzir o modelo do artigo para Solidity, especialmente por ser uma nova ferramenta - ou seja, soma-se a dificuldade de aprende-la melhor. Além disso, tive muitos problemas de hardware para executar o truffle develop, o que, infelizmente, acaretou em vários tavamentos prolongados da ferramenta.

## Referências
1. Conteúdo visto em aula
2. Documentação Truffle
3. Documenação Open Zeppelin
4. [Workshop Reactor São Paulo - Build Smart Contracts](https://github.com/microsoft/ReactorSaoPaulo/tree/main/Workshops/Blockchain/Build_Smart_Contracts)
   