## Ferrametas
Foram utilizados:

1. [Truffle](https://www.trufflesuite.com/docs/truffle/getting-started/creating-a-project)
2. [Open Zeppelin](https://github.com/openzeppelin/openzeppelin-contracts)

### DPublish
Contrato para as transações.
Foram utilizadas as funções:
1. *(submit_manuscript)*: permite que o autor submeta seu artigo para publicação, por meio do pagamento da taxa definida pelo revisor ;
2. *(set_fee)*: set para a taxa da revisão;
3. *(set_balance)*: set para o saldo da conta
4. *(pay_review)*: atualiza o saldo do autor após pagamento;
5. *(update_review)*: atualiza a review
6. *(send_review)*: envia a review


As funções foram implementadas em [DPublish.sol](contracts/DPublish.sol), sendo simplificadas ao máximo, no geral não necessitando comentários.
O restante dos contratos não foi modificado.

## Dificuldades

Houve certa dificuldade de entendimento da linguagem e da integração de ferramentas. Em grande parte do processo havia dificuldade em acusar se o teste estava correto ou não (sendo ainda por agora um terreno ligeiramente duvidoso).

## Referências
1. [Solidity](https://docs.soliditylang.org/en/v0.8.10/)
2. [Truffle](https://trufflesuite.com/docs/)
3. [Open Zeppelin](https://docs.openzeppelin.com/openzeppelin/)
