![my badge](https://badgen.net/badge/license/MIT/green) ![my badge](https://badgen.net/badge/version/v0.0.1/green) ![my badge](https://badgen.net/badge/icon/v8.5.5/green?icon=npm&label) ![my badge](https://badgen.net/badge/nodejs/v16.15.0/green) ![my badge](https://badgen.net/badge/truffle/v5.5.9/green) ![my badge](https://badgen.net/badge/solidity-compiler/v0.8.13/green)

# 🔖 Solidity ICO Presale Smart Contract

This project demonstrates how to develop an ERC20 Token smart contract and its presale smart contract for an Initial Coin Offering deployed on BSC (but it's applicable for any Ethereum-based blockchain).

## ⚠ Disclaimer

This is a sample application with demonstration purpose only. Use it at your own risk.

## 📖 How it works

Once both SC are deployed, anybody can buy tokens with BNB on TokenPresale.sol until presale ends. After presale finishes and owner transfers funds through transferTokens() and calls addLiquidityToPS() to add liquidity to PancakeSwap (is needed to add liquidity manually by the owner before this call?), anyone can buy and sell tokens on this DEX.

## 🔧 How it must be deployed

The first SC that must be deployed is Token.sol.

TokenPresale.sol SC must be deployed (by passing ERC20 Token smart contract address in the constructor) right after Token.sol is deployed, otherwise any attacker may set the presale contract address by calling setPresaleContractAddress() from Token.sol.
If you decide to deploy both SC at once, it is done automatically by Truffle, avoiding any risk.

## 📄 Token.sol

This smart contract allows to create and manage an ERC20 Token. It has the following features:

*   It can swap BNB for TKN.
*   It allows to burn tokens.
*   It is super deflationary, each transaction charges taxes. These taxes can be set individually for buying and/or selling transactions and transferred up to 4 different wallets.
*   It allows the owner to pause tokens transfers if necessary.
*   It is lockable to any custom date (at compiling time) to avoid rug pulls.

ℹ NOTICE: Once it receives funds from the presale contract, call addLiquidityToPS() to add TKNs liquidity to PancakeSwap.

## 📄 TokenPresale.sol

This smart contract allows to manage the ICO for such ERC20 Token without intermediaries.
*   It is able to swap BNB for TKN during the presale.
*   Any user account should be whitelisted previously (if whitelist is enabled) in order to be able to buy tokens, unless this functionality is disabled.
*   User accounts may be added/removed to the whitelist with addToWhiteList(), addManyToWhitelist() and removeFromWhiteList() functions.
*   Any whitelisted user may exchange his BNBs for tokens with buyTokens() function.
*   It allows the owner to pause buyTokens() function if necessary.
*   Once the presale ends, it allows to transfer funds to the owner, then the owner should send BNBs and TKNs to PancakeSwap through addLiquidityToPS() function.
*   Once token funds are transferred to the owner, tokens are locked for X days.
