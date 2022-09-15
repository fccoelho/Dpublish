# Dpublish
Distributed platform for peer-reviewing scientific articles based on the Ethereum Blockchain. The implementation offered here follows [this article](https://www.scielo.br/j/mioc/a/pGbLcFHfhKGvXvTYPcGrfWw/abstract/?lang=en). This repository contains the blockchain component of the the whole platform called DAPH, the decentralized autonomous publishing house.

# Setting up the project

This project uses openzeppelin contrats, so make sure to install it in your project folder:

```bash
$ npm install @openzeppelin/contracts
```

The outline of the platform as is currently stands can be found in the [docs folder](docs/README.md).

## Frontend
The DAPH use a traditional database backend to store documents and other records associated with the publication workflow. This backend is implemented in the [DAPH_API repository](https://github.com/fccoelho/DAPH_API).
