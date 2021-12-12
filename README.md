# Dpublish
Distributed platform for peer-reviewing scientific articles based on the Ethereum Blockchain.

# Setting up the project

This project uses openzeppelin contrats, so make sure to install it in your project folder:

```bash
$ npm install @openzeppelin/contracts
```

# Inconveniences 

It's 12:17 AM; I was trying to adapt DPubToken to ERC777 token. However, this requires a previuos [task](https://forum.openzeppelin.com/t/revert-when-trying-to-test-upgradeable-erc777/3330) that is beyond what is honestly doable; precisely, it gives a `VirtualMachineError: revert` on the tests. 
