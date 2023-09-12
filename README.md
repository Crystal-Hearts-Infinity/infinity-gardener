# Crystal Heart Infinity - Decentralized Donation Platform

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [How It Works](#how-it-works)
- [Getting Started](#getting-started)
- [Resources](#resources)
- [License](#license)

## Introduction

Welcome to Crystal Heart Infinity Decentralized Donation Platform, a blockchain-based solution designed to enhance transparency, accountability, and privacy in the world of charitable donations. Our platform leverages the power of blockchain technology to revolutionize the way donors and charities interact, ensuring that every contribution makes a meaningful impact.

## Features

- **Fully On-Chain Transaction Tracking:** All donation transactions are recorded on the blockchain, providing donors and charities with an immutable and transparent ledger of financial activity.

- **Milestone-Based Fund Release:** Our platform uses smart contracts to release funds to charities based on predefined milestones. This ensures that donations are used efficiently and effectively to achieve specific goals.

## How It Works

![image](https://github.com/Crystal-Hearts-Infinity/infinity-gardener/assets/103866789/69a6134c-fd98-4bdd-911d-59f6a1ed7b0f)

## Getting Started

This mix provides a [simple template](contracts/Token.sol) upon which you can build your own token, as well as unit tests providing 100% coverage for core ERC20 functionality.

To interact with a deployed contract in a local environment, start by opening the console:

```bash
brownie console
```

Next, deploy a test token:

```python
>>> token = Token.deploy("Test Token", "TST", 18, 1e21, {'from': accounts[0]})

Transaction sent: 0x4a61edfaaa8ba55573603abd35403cf41291eca443c983f85de06e0b119da377
  Gas price: 0.0 gwei   Gas limit: 12000000
  Token.constructor confirmed - Block: 1   Gas used: 521513 (4.35%)
  Token deployed at: 0xd495633B90a237de510B4375c442C0469D3C161C
```

You now have a token contract deployed, with a balance of `1e21` assigned to `accounts[0]`:

```python
>>> token
<Token Contract '0xd495633B90a237de510B4375c442C0469D3C161C'>

>>> token.balanceOf(accounts[0])
1000000000000000000000

>>> token.transfer(accounts[1], 1e18, {'from': accounts[0]})
Transaction sent: 0xb94b219148501a269020158320d543946a4e7b9fac294b17164252a13dce9534
  Gas price: 0.0 gwei   Gas limit: 12000000
  Token.transfer confirmed - Block: 2   Gas used: 51668 (0.43%)

<Transaction '0xb94b219148501a269020158320d543946a4e7b9fac294b17164252a13dce9534'>
```

## Resources

To get started with Brownie:

* Check out the other [Brownie mixes](https://github.com/brownie-mix/) that can be used as a starting point for your own contracts. They also provide example code to help you get started.
* ["Getting Started with Brownie"](https://medium.com/@iamdefinitelyahuman/getting-started-with-brownie-part-1-9b2181f4cb99) is a good tutorial to help you familiarize yourself with Brownie.
* For more in-depth information, read the [Brownie documentation](https://eth-brownie.readthedocs.io/en/stable/).


Any questions? Join our [Gitter](https://gitter.im/eth-brownie/community) channel to chat and share with others in the community.

## License

This project is licensed under the [MIT license](LICENSE).
