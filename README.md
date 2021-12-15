# Dpublish
Distributed platform for peer-reviewing scientific articles based on the Ethereum Blockchain.

# Setting up the project

This project uses openzeppelin contrats, so make sure to install it in your project folder:

```bash
$ npm install @openzeppelin/contracts
```

# Relatório 


Foi interessante fazer o projeto, porém passei bastante tempo lidando com os erros e aprendendo um pouco da linguagem solidity. O meu resultado final foi parte do que foi pedido. Tentei fazer o máximo possível e vou relatar tudo aqui.


### Primeira parte : Definição de algumas variáveis

<img src="./imgs/1.png">

Na imagem acima temos a parte do código direcionado a isso, todas linhas estão comentadas, dizendo o que cada uma faz.

### Segunda parte : Simuladores de Tokens

<img src="./imgs/2.png">

Como não consegui conectar o contrado `DPublish.sol` com os demais, decidi então fazer então uma simulação dos tokens, para o PaperToken e ReviewToken eu criei uma estrutura de dados pra cada. Abaixo das estruturas temos os mappings representando as carteiras de cada token.

### Terceira parte : EVENTOS, ERROS E CONSTRUTOR

<img src="./imgs/3.png">

Nessa terceira parte criei alguns eventos pra quando um pagamento é recebido e enviado, quando alguém compra DPubTokens e  um ReviewToken ou PaperToken é emitido , e também é adicionado um erro quando a quantidade de dinheiro não é suficiente. No construtor temos uma função que cria uma carteira, ela é usada pelo Editor, que recebe um valor arbitrário de DPubTokens. 

### Quarta parte : FUNÇÕES AUXILIARES

<img src="./imgs/4.png">

Aqui  são criadas algumas funções auxiliares que ajudaram nas próximas parte do projeto. Uma função que concatena duas strings, uma geradora de link, funções que simulam a emissão de ReviewToken e PaperToken e a publicação de um artigo. Uma função que diz se um endereço tem uma carteira de DPubToken. E por fim uma função que paga os revisores.

### Quinta parte : OBTER E CONFIGURAR VALORES DE PAGAMENTO

<img src="./imgs/5.png">

Temos funções que o Editor pode configurar os valores de uma submissão de artigo e o valor que cada revisor recebe. E outras duas que qualquer pessoa pode usar, que retornam os valores da submissão e o valor que cada revisor recebe.

### Sexta parte : COMPRA DE DPubTokens E SUBMISSÃO DE ARTIGO

<img src="./imgs/6.png">

Na imagem acima temos uma função onde a pessoa que chama ela faz uma compra de DPubTokens, caso essa pessoa não tenha carteira, é criada uma pra ela. O balanço dela precisa ser maior ou igual ao valor da quantidade de DPubToken que ela deseja comprar.

Já na função de submissão de 