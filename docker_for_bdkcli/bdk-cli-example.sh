#!/usr/bin/env bash

set -eux

WALLET_NAME=alice

# xprv is created by
# bdk-cli --network=regtest key generate | jq .xprv | xargs -IXX bdk-cli key derive --xprv XX --path='m/84'/1'/0'/0'' | jq -r .xprv
xprv="[8363c57a/84/1/0/0]tprv8ipJLdeSxdgmsVBJDd1aymCPLe7v8UVgQtMU6nkzWLcJNEKtGPjQYFrqEAm5krFV2KN3BqFgPgMZWrGroEGLh3q2UqLGhAqzwMDphs9T1ak/*"

bdk_wallet(){
  bdk-cli --network=regtest wallet --descriptor="wpkh($xprv)" $@
}

# ./bitcoin-cli.sh createwallet $WALLET_NAME
# bitcoind_address=$(./bitcoin-cli.sh -rpcwallet=$WALLET_NAME getnewaddress)
# ./bitcoin-cli.sh generatetoaddress 101 $bitcoind_address

bdk_address=$(bdk_wallet get_new_address | jq -r ".address")
./bitcoin-cli.sh -rpcwallet=$WALLET_NAME sendtoaddress  $bdk_address 5
