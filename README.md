Projeto para A2 de Blockchain - Aluno Victor de Almeida Bombarda


## Contratos e funções

Além de criar as funções, tive que mudar a versão do Solidity usados em outros contratos para 0.8.2 pois era esta versão sendo usada pelo Truffle, e só assim consegui compilar estes.

Criei alguns dicionários que permitem lidar com diferentes e diversos clientes e revisores, assim como controlar os pagamentos e as publicações. As funções que escrevi permitem enviar um projeto de artigo (armazena quem publicou e atualiza o saldo devido ao preço de publicação), permitem pagar o revisor (atualizando valores da wallet), mudar os preços e os saldos, e inscrever-se como um revisor de um determinado artigo.

Nestas funções, muitas vezes era exigido que a pessoa que as chama (interpretado no código como o msg.sender) seja um revisor, como as funções de inscrição e as funções que determinam os preços e os saldos. Isto é importante pois em um ambiente de trocar de serviços online, este funciona de forma a impedir que um usuário qualquer não possa mexer com questões de dinheiro sem que este seja credenciado (ou neste caso, um revisor).

## Dificuldades e problemas

As vezes quando mexendo com a criação de uma função e diferentes variáveis, tive problemas devido ao fato de Solidity ser fortemente tipada, porém corrigi erros deste tipo. Tive uns pequenos erros de compilação, os quais não consegui corrigir, relativos à declaração do erro dentro do DPublish, procurei em alguns links do próprio site do Solidity porém não tive sucesso. Os outros arquivos todos rodaram sem problema. 
