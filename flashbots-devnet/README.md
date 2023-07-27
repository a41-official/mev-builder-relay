# Ethereum Proof-of-Stake Devnet

This repository provides a docker-compose file to run a fully-functional, local development network for Ethereum with proof-of-stake enabled. This configuration uses [Prysm](https://github.com/prysmaticlabs/prysm) as a consensus client and [go-ethereum](https://github.com/ethereum/go-ethereum) for execution.

This sets up a single node development network with 64 deterministically-generated validator keys to drive the creation of blocks in an Ethereum proof-of-stake chain. Here's how it works:

1. We initialize a go-ethereum, proof-of-work development node from a genesis config
2. We initialize a Prysm beacon chain, proof-of-stake development node from a genesis config
3. We then start mining in go-ethereum proof-of-work, and concurrently run proof-of-stake using Prysm
4. Once the mining difficulty of the go-ethereum node reaches `50`, the node switches to proof-of-stake mode by letting Prysm drive the consensus of blocks

The development net is fully functional and allows for the deployment of smart contracts and all the features that also come with the Prysm consensus client such as its rich set of APIs for retrieving data from the blockchain. This development net is a great way to understand the internals of Ethereum proof-of-stake and to mess around with the different settings that make the system possible.

## Using

First, install Docker.

Then, run the devnet launch script:

```
./start-local-net.sh
```

This will build the images for the [flashbots builder](https://github.com/flashbots/builder) and [prysm fork](https://github.com/flashbots/prysm).

You will see the following:

```
$ docker compose up -d
[+] Running 7/7
 ⠿ Network eth-pos-devnet_default                          Created
 ⠿ Container eth-pos-devnet-geth-genesis-1                 Started
 ⠿ Container eth-pos-devnet-create-beacon-chain-genesis-1  Started
 ⠿ Container eth-pos-devnet-geth-account-1                 Started
 ⠿ Container eth-pos-devnet-geth-1                         Started
 ⠿ Container eth-pos-devnet-beacon-chain-1                 Started
 ⠿ Container eth-pos-devnet-validator-1                    Started
```
Next, you can inspect the logs of the different services launched. 

```
docker logs eth-pos-devnet-geth-1 -f
```

and see:

```
INFO [08-19|00:44:30.956] Imported new potential chain segment     blocks=1 txs=0 mgas=0.000 elapsed=1.356ms     mgasps=0.000 number=50 hash=e0bd7f..497d27 dirty=0.00B
INFO [08-19|00:44:31.030] Chain head was updated                   number=50 hash=e0bd7f..497d27 root=815538..801014 elapsed=1.49025ms
INFO [08-19|00:44:35.215] Imported new potential chain segment     blocks=1 txs=0 mgas=0.000 elapsed=3.243ms     mgasps=0.000 number=51 hash=a5fb7c..5e844b dirty=0.00B
INFO [08-19|00:44:35.311] Chain head was updated                   number=51 hash=a5fb7c..5e844b root=815538..801014 elapsed=1.73475ms
INFO [08-19|00:44:39.435] Imported new potential chain segment     blocks=1 txs=0 mgas=0.000 elapsed=1.355ms     mgasps=0.000 number=52 hash=b2fd97..22e230 dirty=0.00B
INFO [08-19|00:44:39.544] Chain head was updated                   number=52 hash=b2fd97..22e230 root=815538..801014 elapsed=1.167959ms
INFO [08-19|00:44:42.733] Imported new potential chain segment     blocks=1 txs=0 mgas=0.000 elapsed=2.453ms     mgasps=0.000 number=53 hash=ee046e..e56b0c dirty=0.00B
INFO [08-19|00:44:42.747] Chain head was updated                   number=53 hash=ee046e..e56b0c root=815538..801014 elapsed="821.084µs"
```

Once the mining difficulty of go-ethereum reaches 50, proof-of-stake will be activated and the Prysm beacon chain will be driving consensus of blocks.

# Available Features

- The network launches with a [Validator Deposit Contract](https://github.com/ethereum/consensus-specs/blob/dev/solidity_deposit_contract/deposit_contract.sol) deployed at address `0x4242424242424242424242424242424242424242`. This can be used to onboard new validators into the network by depositing 32 ETH into the contract
- The default account used in the go-ethereum node is address `0x123463a4b065722e99115d6c222f267d9cabb524` which comes seeded with ETH for use in the network. This can be used to send transactions, deploy contracts, and more
- The default account, `0x123463a4b065722e99115d6c222f267d9cabb524` is also set as the fee recipient for transaction fees proposed validators in Prysm. This address will be receiving the fees of all proposer activity
- The go-ethereum JSON-RPC API is available at http://geth:8545
- The Prysm client's REST APIs are available at http://beacon-chain:3500. For more info on what these APIs are, see [here](https://ethereum.github.io/beacon-APIs/)
- The Prysm client also exposes a gRPC API at http://beacon-chain:4000


# Configuring the Builder

There are 3 vars to set in the builder:

- `builder.secret_key`
- `builder.relay_secret_key`
- `BUILDER_TX_SIGNING_KEY`

You can use the private key for 0x123463a4b065722e99115d6c222f267d9cabb524 located in `sk.json`, as it has an ether balance in the devnet.

When sending bundles, make sure to send from an address other than 0x123463a4b065722e99115d6c222f267d9cabb524 (or the miner coinbase address) as it affects the block profit calculation.

Credits to [flashbots-compose](https://github.com/antonydenyer/flashbots-compose/blob/main/prysm/Dockerfile) for the Prysm and Geth Dockerfiles.
