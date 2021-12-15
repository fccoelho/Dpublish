# Dpublish
Distributed platform for peer-reviewing scientific articles based on the Ethereum Blockchain.
Plataforma de revisão de artigos científicos descentralizada basead na Blockchain da Ethereum
# Setting up the project

This project uses openzeppelin contrats, so make sure to install it in your project folder:

```bash
$ npm install @openzeppelin/contracts
```

Bibs do openzeppelin foram instaladas com sucesso para desenvolver o contrato inteligente de foram segura utilizando a base sólida de código verificado pela comunidade no site oficial de documentação (https://docs.openzeppelin.com/contracts/2.x/).

^^^^
ERRO DE COMPILAÇÃO:PS F:\Meus Documentos\Documents\GitHub\Dpublish> truffle version
Truffle v5.4.18 (core: 5.4.18)
Solidity - 0.8.2 (solc-js)
Node v16.13.0
Web3.js v1.5.3
^^^^
CORREÇÃO: Atualização do truffle-config.js alterando a versão do compilador para 0.8.4, de acordo com a documentação oficial do truffle config (https://trufflesuite.com/docs/truffle/reference/configuration#compiler-configuration), por fim tudo rodou corretamente:
````
> Artifacts written to F:\Meus Documentos\Documents\GitHub\Dpublish\build\contracts
> Compiled successfully using:
   - solc: 0.8.4+commit.c7e474f2.Emscripten.clang
````

Tive grande dificuldade e não entendi por que mas não foi possível utilizar o Remix via link de conexão local para os arquivos do computador, isso ocorreu nos dois sistemas que eu fui capaz de testar (Windows 10 e WSL2 rodando Linux dist. Ubuntu), segui o tutorial da aula e do site indicado mas não obtive sucesso nessa parte, durante a intalação do próprio Truffle gerou diversos erros e alertas que tentei corrigir mas me pareceu algo mais complexo que envolvia mais erros na intalação do Node Package Manager (NPM), os erros referenciavam alguns pacotes como antigos e que não eram mais utilizados. Por isso, foi utilizado para esse projeto o Truffle (mesmo com os erros) para compilações e testes operado no VSCode e Ganache como blockchain de desenvolvimento local (https://trufflesuite.com/ganache/), tudo rodou tranquilo e sem mais grandes dificuldades.

Como consulta e entendimento básico da linguagem solidity utilizei a própria documentação do truffle exemplos e o canal Smart Contract Programmer (https://www.youtube.com/channel/UCJWh7F3AFyQ_x01VKzr9eyA) no Youtube.

Funções geradas de acordo com o indicado no fluxograma do GitHub: Enviar artigos não-verificados para revisão (Preço de publicação descontado na digital_bag/carteira e autor determinado), pagar revisores (altera valores dentro da digital_bag/carteira), necessidade de cadastro para ser um revisor, limite de revisões, verificar erros de duplicidade de pagamento, seguranças de pequena possibilidade de erro e pequena declaração de aviso de evento adicionada.  