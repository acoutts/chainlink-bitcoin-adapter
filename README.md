# Chainlink Bitcoin External Adapter

Adapter that connects Chainlink oracle nodes to the bitcoin network faciliating BTC JSON-RPC calls.

This allows Chainlink oracles to return information about BTC transactions and wallet addresses.

### Supported commands:

- ✅ getBlockCount (return current block_num)
- ✅ getDifficulty (return current difficulty)
- ✅ getRawTransaction (return JSON object of a given tx_id)
- ❌ getBlock (return contents of a given block_num)
- ❌ searchRawTransactions (return transactions of a given wallet address)
- ❌ getWalletBalance (return balance of a given wallet address, optionally at a given block_num)

### Supported BTC client backends:

- ✅ btcd
- ❌ bitcoind

### TODO

- Add support for other BTC clients (ex: bitcoind)
- Add support for other BTC forks (Bitcoin Cash, Bitcoin SV, Bitcoin Gold, etc)

# Prerequisites

Make sure you have a btcd instance sync'd on mainnet and the RPC enabled. You an get btcd here:
https://github.com/btcsuite/btcd

To enable the RPC, ensure there's a `rpcuser` and `rpcpassword` defined in your `btcd.conf` file.

You will also need a copy of `rpc.cert` from the btcd instance to be specified with the `BTCD_RPC_CERT` environment variable when running the adapter.

Finally, make sure the instance of btcd you're sending RPC requests is sync'd with the following configuration options enabled:

```
txindex=1
addrindex=1
```

# Contract Usage

To use this adapter on-chain, find a node that supports this adapter and build your request like so:

```
Chainlink.Request memory req = buildChainlinkRequest(jobId, this, this.fulfill.selector);
run.add("rpc_command", "getBlockCount");
string[] memory copyPath = new string[](1);
copyPath[0] = "block_count";
```

# Setup Instructions

## Local Install

Make sure [Golang](https://golang.org/pkg/) is installed.

Build:

```
make build
```

Then run the adapter:

```
BTCD_RPC_HOST=127.0.0.1:8334 BTCD_RPC_USER=username BTCD_RPC_PASS=password BTCD_RPC_CERT=./rpc.cert ./chainlink-adapter-btcd
```

## Docker

To run the container (note: make sure to escape special characters with a leading `\`):

```
docker run -it -e BTCD_RPC_HOST=127.0.0.1:8334 -e BTCD_RPC_USER=username -e BTCD_RPC_PASS=password -e BTCD_RPC_CERT=./rpc.cert -p 8080:8080 acoutts/chainlink-bitcoin-adapter
```

## Usage Example (curl)

Note: the rpc_command is case-insensitive.

```
curl -X POST -H 'Content-Type: application/json' \
-d @- << EOF
{
	"jobRunId": "1234",
	"data": {
		"rpc_command": "getBlockCount"
	}
}
EOF
```

## REST Response Example:

```json
{
  "jobRunId": "1234",
  "status": "completed",
  "error": null,
  "pending": false,
  "data": {
    "block_count": 612699,
    "rpc_command": "getBlockCount"
  }
}
```

# RPC Reference

Below is an overview of the supported RPC commands and their responses.

# getBlockCount

**Parameters**

None

**Description**

Returns the number of blocks in the longest block chain.

### Request Data:

```
"data": {
  "rpc_command": "getBlockCount"
}
```

### Response Success

```json
{
  "jobRunId": "1234",
  "status": "completed",
  "error": null,
  "pending": false,
  "data": {
    "block_count": 612699,
    "rpc_command": "getBlockCount"
  }
}
```

### Response Error

```json
{
  "jobRunId": "1234",
  "status": "errored",
  "error": "Unable to connect to btcd instance",
  "pending": false,
  "data": {
    "rpc_command": "getBlockCount"
  }
}
```

### Solidity Example

```
Chainlink.Request memory req = buildChainlinkRequest(jobId, this, this.fulfill.selector);
run.add("rpc_command", "getBlockCount");
string[] memory copyPath = new string[](1);
copyPath[0] = "block_count";
```

# getDifficulty

**Parameters**

None

**Description**

Returns the proof-of-work difficulty as a multiple of the minimum difficulty.

### Request Data:

```
"data": {
  "rpc_command": "getDifficulty"
}
```

### Response Success

```json
{
  "jobRunId": "1234",
  "status": "completed",
  "error": null,
  "pending": false,
  "data": {
    "difficulty": 13798783827516.416,
    "rpc_command": "getDifficulty"
  }
}
```

### Response Error

```json
{
  "jobRunId": "1234",
  "status": "errored",
  "error": "Unable to connect to btcd instance",
  "pending": false,
  "data": {
    "rpc_command": "getDifficulty"
  }
}
```

### Solidity Example

```
Chainlink.Request memory req = buildChainlinkRequest(jobId, this, this.fulfill.selector);
run.add("rpc_command", "getDifficulty");
string[] memory copyPath = new string[](1);
copyPath[0] = "difficulty";
```

# getRawTransaction

**Parameters**

1. tx_id (string, required) - the hash of the transaction to look up
2. verbose (string, optional, default=false) - specifies the transaction is returned as a JSON object instead of hex-encoded string

**Description**

Returns information about a transaction given its hash.

### Request Data:

```
"data": {
  "rpc_command": "getRawTransaction",
  "tx_id": "ffb7421e996d7b922157d36d082a6acac0b8313822bd44b935439bc861996dd6",
  "verbose": "true"
}
```

### Response Success (verbose=true)

```json
{
  "jobRunId": "1234",
  "status": "completed",
  "error": null,
  "pending": false,
  "data": {
    "rpc_command": "getrawtransaction",
    "tx_hex": "01000000000101865378657e3671842534d17383412b504fa7ffb4f40f6fa4c93eb93f2536dac40000000000ffffffff0210270000000000001600148e2a16425ff81b043ec929cefb7f032de9ad75fb841b0000000000001600142e69de6e03736cfb6c2fbaaf16a998a5b1a47596024730440220658a0cb83ccb3930891d0947e39f1965deb62f64aeec8a96a634efda3d0f435e022050ea1d531abb1802cf60e92e8dfe97d9744338b5ebdaf642d0b4b48ff14d5d3e0121039715e945f67d0c2c399d32cd7b75d1c1bd02fa988f958fec2dfff7ecea35a6f400000000",
    "tx_id": "ffb7421e996d7b922157d36d082a6acac0b8313822bd44b935439bc861996dd6",
    "tx_raw": {
      "blockhash": "000000000000000000019c0cb01a79614bf361ab5cfccaebb9f1cc57b1cbd423",
      "blocktime": 1575640480,
      "confirmations": 6042,
      "hash": "934b88459790e7791b935cf19a94f7a67cb65f91e62364db8b8c3d32c8b369b5",
      "hex": "01000000000101865378657e3671842534d17383412b504fa7ffb4f40f6fa4c93eb93f2536dac40000000000ffffffff0210270000000000001600148e2a16425ff81b043ec929cefb7f032de9ad75fb841b0000000000001600142e69de6e03736cfb6c2fbaaf16a998a5b1a47596024730440220658a0cb83ccb3930891d0947e39f1965deb62f64aeec8a96a634efda3d0f435e022050ea1d531abb1802cf60e92e8dfe97d9744338b5ebdaf642d0b4b48ff14d5d3e0121039715e945f67d0c2c399d32cd7b75d1c1bd02fa988f958fec2dfff7ecea35a6f400000000",
      "locktime": 0,
      "size": 222,
      "time": 1575640480,
      "txid": "ffb7421e996d7b922157d36d082a6acac0b8313822bd44b935439bc861996dd6",
      "version": 1,
      "vin": [
        {
          "scriptSig": {
            "asm": "",
            "hex": ""
          },
          "sequence": 4294967295,
          "txid": "c4da36253fb93ec9a46f0ff4b4ffa74f502b418373d134258471367e65785386",
          "txinwitness": [
            "30440220658a0cb83ccb3930891d0947e39f1965deb62f64aeec8a96a634efda3d0f435e022050ea1d531abb1802cf60e92e8dfe97d9744338b5ebdaf642d0b4b48ff14d5d3e01",
            "039715e945f67d0c2c399d32cd7b75d1c1bd02fa988f958fec2dfff7ecea35a6f4"
          ],
          "vout": 0
        }
      ],
      "vout": [
        {
          "n": 0,
          "scriptPubKey": {
            "addresses": ["bc1q3c4pvsjllqdsg0kf9880klcr9h566a0mglxk5d"],
            "asm": "0 8e2a16425ff81b043ec929cefb7f032de9ad75fb",
            "hex": "00148e2a16425ff81b043ec929cefb7f032de9ad75fb",
            "reqSigs": 1,
            "type": "witness_v0_keyhash"
          },
          "value": 0.0001
        },
        {
          "n": 1,
          "scriptPubKey": {
            "addresses": ["bc1q9e5aumsrwdk0kmp0h2h3d2vc5kc6gavkvjw6ke"],
            "asm": "0 2e69de6e03736cfb6c2fbaaf16a998a5b1a47596",
            "hex": "00142e69de6e03736cfb6c2fbaaf16a998a5b1a47596",
            "reqSigs": 1,
            "type": "witness_v0_keyhash"
          },
          "value": 0.00007044
        }
      ],
      "vsize": 141,
      "weight": 561
    },
    "verbose": "true"
  }
}
```

### Response Success (verbose=false)

```json
{
  "jobRunId": "1234",
  "status": "completed",
  "error": null,
  "pending": false,
  "data": {
    "rpc_command": "getrawtransaction",
    "tx_hex": "01000000000101865378657e3671842534d17383412b504fa7ffb4f40f6fa4c93eb93f2536dac40000000000ffffffff0210270000000000001600148e2a16425ff81b043ec929cefb7f032de9ad75fb841b0000000000001600142e69de6e03736cfb6c2fbaaf16a998a5b1a47596024730440220658a0cb83ccb3930891d0947e39f1965deb62f64aeec8a96a634efda3d0f435e022050ea1d531abb1802cf60e92e8dfe97d9744338b5ebdaf642d0b4b48ff14d5d3e0121039715e945f67d0c2c399d32cd7b75d1c1bd02fa988f958fec2dfff7ecea35a6f400000000",
    "tx_id": "ffb7421e996d7b922157d36d082a6acac0b8313822bd44b935439bc861996dd6",
    "verbose": "false"
  }
}
```

### Response Error

Here's an error example for an invalid tx_id:

```json
{
  "jobRunId": "1234",
  "status": "errored",
  "error": "-5: No information available about transaction 000000000000000000000000000000000000000000000000000000000000abcd",
  "pending": false,
  "data": {
    "rpc_command": "getrawtransaction",
    "tx_id": "abcd",
    "verbose": "false"
  }
}
```

### Solidity Example

To get the block time from the result:

```
Chainlink.Request memory req = buildChainlinkRequest(jobId, this, this.fulfill.selector);
run.add("rpc_command", "getRawTransaction");
string[] memory copyPath = new string[](2);
copyPath[0] = "tx_raw";
copyPath[1] = "blocktime";
```
