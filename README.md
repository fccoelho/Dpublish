# Avaliação 2
> TEMA: DAPH - Decentralized Autonomous Publishing House.
> 
> LINGUAGEM: Solidity 0.8.2
> 
> DISCIPLINA: Introdução à Criptomoedas e Blockchain
> PERÍODO: 2021/2
> PROFESSOR: Flávio Coelho
> 
> Ari Oliveira

[![Truflle](https://img.shields.io/badge/Truflle-site-5e464d?style=for-the-badge)](https://trufflesuite.com/docs/index.html) [![OpenZeppelin](https://img.shields.io/badge/OPENZEPPELIN-site-4e5ee4?style=for-the-badge)](https://openzeppelin.com/) [![Source Code](https://img.shields.io/badge/this_project-code-green?style=for-the-badge&logo=github)](https://github.com/AriOliv/Dpublish) 


### Estrutura 
O projeto foi desenvolvido tendo por base o seguinte diagrama:
<center><img src="https://github.com/fccoelho/Curso_Blockchain/raw/master/A2/Fluxograma.png" class="jop-noMdConv" width="433" height="433"></center><center>Ideia DAHP</center>
Onde podemos identificar algumas ações básicas para o funcionamento da ideia, e essas ações foram resumidas nas seguintes funções:

#### Funções
- **enviar_artigo**: que como o próprio nome sugere é responsável registrar o envio dos artigos. Para isso, se faz uma verificação para ver se há fundos para isso são suficientes, sendo negativa a resposta é disparado um ==evento== que discrimina o erro. Em caso positivo para fundos, a taxa de postagem é descontada do devido usuário e registrado o pagamento.
- **taxa**: define a taxa de postagem do artigo.
- **def_balanco**: define o quanto o usuário possúi em carteira, ou seja, os fundos disponíveis para se realizar uma ação.
- **para_revisar**: inclui verificações onde o revisor pode conferir quantas revisões foram solicitadas e se o revisor está devidamente cadastrado para a função, depois adiciona o artigo ao conjunto dos revisados.
- **enviar_revisao**: verifica primeiro se o revisor está cadastrado, após, já realiza a validação da transferência para garantir que o pagamento será realizado apenas uma vez e os fundos descontados da carteira, para isso se chama a função *pagar_revisao*.
- **pagar_revisão**: apenas adiciona o valor pago ao valor da carteira de revisão.
- **revisar**: a ideia dessa função é atribuir um artigo a um revisor.

Também é importante destacar as variáveis utilizadas.

#### Variáveis

> de armazenamento

- **artigos_enviados**: `address` guarda os artigos para serem revisados.
- **balancos**: `uint256` funciona como a carteira com o saldo do usuário.
- **recebido**: `uint256` guarda os valores pagos para determinado artigo enviado.
- **revisoes**: `string` grava os artigos já revisados.
- **revisoes**: `bool` marca se determinado artigo já foi revisado.

> gerais

- **instance**: `address` para a definição do construtor.
- **taxa_post**: `uint256` define o quanto custa enviar um artigo
- **revisar_pagamento**: `uint16`
- **revisores**: quantos revisores há.
- **contador**: variável auxiliar

#### Eventos
- **ReceberPagamentos**: `event`
- **SemFundos**: `error`

### Contratos
Todas as funções e variáveis acima se encontram no arquivo `DPublish.sol`. Eu não modifiquei nenhum outro contrato na implementação do projeto.

### Percauços
Foi um tanto complicado de entender a proposta inicial do projeto, mas uma vez com a ideia em mente, foi desafiador dimensionar as funções para que elas cumprissem o seu papel e associado a isso a falta de familiaridade com a linguagem Solidity. Não tive problemas com compilação e maiores questões com a configuração do ambiente.

> Ari Oliv.