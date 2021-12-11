# Dpublish
Distributed platform for peer-reviewing scientific articles based on the Ethereum Blockchain.

___

A versão final do projeto pode ser encontrada no folder project_A2_Levy.

Para a entrega do projeto, apenas o contrato DPublish.sol foi modificado, assim como o arquivo 2_deploy_contracts.js, para permitir a migração correta do projeto. 

Foram incluídos mappings adicionais para armazenamento da quantidade de tokens do usuário, pagamento dos revisores e das revisões; eventos de pagamento recebido e transferência; um construtor que armazena o endereço do autor do contrato; e as seguintes funções:

A função submit_manuscripts foi implementada, agora ela armazena o endereço do usuário que publicou o contrato, o saldo desse usuário, desconta a taxa de publicação do usuário e armazena o novo saldo; uma função set_fee, que atribui uma taxa para publicação do artigo, e requer que o usuário que o publicou seja o próprio autor. A função set_balance atribui um saldo ao usuário; subscribe_to_review permite a inscrição de revisores, e ela requer que o revisor tenha revisto no máximo 10 artigos, sendo impossível revisar mais do que isso. A função sent_review permite o envio da revisão e desconta o valor do pagamento para evitar pagamentos adicionais; e por fim a função pay_review paga o revisor.  

Uma das dificuldades encontradas no projeto está relacionada à compilação do arquivo ERC20Votes.sol, já que ele é um contrato abstrato e consequentemente não pôde ser lançado. O fato do Solidity ser uma linguagem fortemente tipada também dificultou a elaboração do contrato, já que qualquer variável definida incorretamente prejudicava toda a compilação.
