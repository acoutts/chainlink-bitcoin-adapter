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
LISTEN_PORT=8080 BTCD_RPC_HOST=127.0.0.1:8334 BTCD_RPC_USER=username BTCD_RPC_PASS=password BTCD_RPC_CERT=./rpc.cert ./chainlink-adapter-btcd
```

**Environment Variables**

`LISTEN_PORT` Which port the REST API listens on for Chainlink daemon to call in from.

`BTCD_RPC_HOST` Specify host:port of btcd instance

`BTCD_RPC_USER` Specify RPC username for btcd

`BTCD_RPC_PASS` Specify RPC password for btcd

`BTCD_RPC_CERT` Path to RPC cert for btcd

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

## Usage Example (JobSpec)

Submit this as a job to run

```json
{
  "initiators": [
    {
      "type": "runat",
      "params": {
        "time": "2019-09-20T12:20:00Z",
        "ran": true
      }
    }
  ],
  "tasks": [
    {
      "type": "bitcoin",
      "confirmations": 0,
      "params": {
        "rpc_command": "getrawtransaction",
        "tx_id": "96f4cfef79bedea7b389dd07dff5aaf491a8932ec7d5a2bd2d96dfbc916031ee",
        "verbose": "true"
      }
    }
  ],
  "startAt": null,
  "endAt": null
}
```

It should return a result JSON like this:

```json
{
  "id": "014f67c54b274503bdd73faa6e9c963f",
  "jobId": "979dfa3c1cee40188cd450a683a41b94",
  "result": {
    "data": {
      "rpc_command": "getrawtransaction",
      "tx_hex": "010000000001018c2be8c4a8872dad66cd6e9cc1d8d36b8b04735f2d48710056c9eaa1c957ca390100000000ffffffff02eb3a8a0000000000160014f4095d233efcfea8a7005a20869eae7eb6a7d8f9e80300000000000017a914cac486d4e32224f429465c4664f6e1598344bdd1870248304502210094b3bac87d240d7ee9af8a748292f955a40182b63bb7aafefb05e976edc178c6022056ef4118bb4ea7dcc4d2cb423b414e4c4fb0f4e374c55159adb30c0be870f0940121023ec6a38c7696056b7cfd4fafa8c5717e9409bcc590c0650a6939ef15d564f92b00000000",
      "tx_id": "96f4cfef79bedea7b389dd07dff5aaf491a8932ec7d5a2bd2d96dfbc916031ee",
      "tx_raw": {
        "blockhash": "00000000000000000010bf70a87dea443ebf75475b0cb4c05cca5d200b1a9142",
        "blocktime": 1579104247,
        "confirmations": 315,
        "hash": "67785759f32a8b346cf3c72729302126077791f6909662e24c9c2842a6047f45",
        "hex": "010000000001018c2be8c4a8872dad66cd6e9cc1d8d36b8b04735f2d48710056c9eaa1c957ca390100000000ffffffff02eb3a8a0000000000160014f4095d233efcfea8a7005a20869eae7eb6a7d8f9e80300000000000017a914cac486d4e32224f429465c4664f6e1598344bdd1870248304502210094b3bac87d240d7ee9af8a748292f955a40182b63bb7aafefb05e976edc178c6022056ef4118bb4ea7dcc4d2cb423b414e4c4fb0f4e374c55159adb30c0be870f0940121023ec6a38c7696056b7cfd4fafa8c5717e9409bcc590c0650a6939ef15d564f92b00000000",
        "locktime": 0,
        "size": 224,
        "time": 1579104247,
        "txid": "96f4cfef79bedea7b389dd07dff5aaf491a8932ec7d5a2bd2d96dfbc916031ee",
        "version": 1,
        "vin": [
          {
            "scriptSig": {
              "asm": "",
              "hex": ""
            },
            "sequence": 4294967295,
            "txid": "39ca57c9a1eac9560071482d5f73048b6bd3d8c19c6ecd66ad2d87a8c4e82b8c",
            "txinwitness": [
              "304502210094b3bac87d240d7ee9af8a748292f955a40182b63bb7aafefb05e976edc178c6022056ef4118bb4ea7dcc4d2cb423b414e4c4fb0f4e374c55159adb30c0be870f09401",
              "023ec6a38c7696056b7cfd4fafa8c5717e9409bcc590c0650a6939ef15d564f92b"
            ],
            "vout": 1
          }
        ],
        "vout": [
          {
            "n": 0,
            "scriptPubKey": {
              "addresses": ["bc1q7sy46ge7lnl23fcqtgsgd84w06m20k8e4zz7ea"],
              "asm": "0 f4095d233efcfea8a7005a20869eae7eb6a7d8f9",
              "hex": "0014f4095d233efcfea8a7005a20869eae7eb6a7d8f9",
              "reqSigs": 1,
              "type": "witness_v0_keyhash"
            },
            "value": 0.09059051
          },
          {
            "n": 1,
            "scriptPubKey": {
              "addresses": ["3LB9rCxg5d7ynhGAm9nxVTxzm2qw8f359s"],
              "asm": "OP_HASH160 cac486d4e32224f429465c4664f6e1598344bdd1 OP_EQUAL",
              "hex": "a914cac486d4e32224f429465c4664f6e1598344bdd187",
              "reqSigs": 1,
              "type": "scripthash"
            },
            "value": 0.00001
          }
        ],
        "vsize": 142,
        "weight": 566
      },
      "verbose": "true"
    },
    "error": null
  },
  "status": "completed",
  "taskRuns": [
    {
      "id": "d67424cade0445cb8e58bceb0b396a8f",
      "result": {
        "data": {
          "rpc_command": "getrawtransaction",
          "tx_hex": "010000000001018c2be8c4a8872dad66cd6e9cc1d8d36b8b04735f2d48710056c9eaa1c957ca390100000000ffffffff02eb3a8a0000000000160014f4095d233efcfea8a7005a20869eae7eb6a7d8f9e80300000000000017a914cac486d4e32224f429465c4664f6e1598344bdd1870248304502210094b3bac87d240d7ee9af8a748292f955a40182b63bb7aafefb05e976edc178c6022056ef4118bb4ea7dcc4d2cb423b414e4c4fb0f4e374c55159adb30c0be870f0940121023ec6a38c7696056b7cfd4fafa8c5717e9409bcc590c0650a6939ef15d564f92b00000000",
          "tx_id": "96f4cfef79bedea7b389dd07dff5aaf491a8932ec7d5a2bd2d96dfbc916031ee",
          "tx_raw": {
            "blockhash": "00000000000000000010bf70a87dea443ebf75475b0cb4c05cca5d200b1a9142",
            "blocktime": 1579104247,
            "confirmations": 315,
            "hash": "67785759f32a8b346cf3c72729302126077791f6909662e24c9c2842a6047f45",
            "hex": "010000000001018c2be8c4a8872dad66cd6e9cc1d8d36b8b04735f2d48710056c9eaa1c957ca390100000000ffffffff02eb3a8a0000000000160014f4095d233efcfea8a7005a20869eae7eb6a7d8f9e80300000000000017a914cac486d4e32224f429465c4664f6e1598344bdd1870248304502210094b3bac87d240d7ee9af8a748292f955a40182b63bb7aafefb05e976edc178c6022056ef4118bb4ea7dcc4d2cb423b414e4c4fb0f4e374c55159adb30c0be870f0940121023ec6a38c7696056b7cfd4fafa8c5717e9409bcc590c0650a6939ef15d564f92b00000000",
            "locktime": 0,
            "size": 224,
            "time": 1579104247,
            "txid": "96f4cfef79bedea7b389dd07dff5aaf491a8932ec7d5a2bd2d96dfbc916031ee",
            "version": 1,
            "vin": [
              {
                "scriptSig": {
                  "asm": "",
                  "hex": ""
                },
                "sequence": 4294967295,
                "txid": "39ca57c9a1eac9560071482d5f73048b6bd3d8c19c6ecd66ad2d87a8c4e82b8c",
                "txinwitness": [
                  "304502210094b3bac87d240d7ee9af8a748292f955a40182b63bb7aafefb05e976edc178c6022056ef4118bb4ea7dcc4d2cb423b414e4c4fb0f4e374c55159adb30c0be870f09401",
                  "023ec6a38c7696056b7cfd4fafa8c5717e9409bcc590c0650a6939ef15d564f92b"
                ],
                "vout": 1
              }
            ],
            "vout": [
              {
                "n": 0,
                "scriptPubKey": {
                  "addresses": ["bc1q7sy46ge7lnl23fcqtgsgd84w06m20k8e4zz7ea"],
                  "asm": "0 f4095d233efcfea8a7005a20869eae7eb6a7d8f9",
                  "hex": "0014f4095d233efcfea8a7005a20869eae7eb6a7d8f9",
                  "reqSigs": 1,
                  "type": "witness_v0_keyhash"
                },
                "value": 0.09059051
              },
              {
                "n": 1,
                "scriptPubKey": {
                  "addresses": ["3LB9rCxg5d7ynhGAm9nxVTxzm2qw8f359s"],
                  "asm": "OP_HASH160 cac486d4e32224f429465c4664f6e1598344bdd1 OP_EQUAL",
                  "hex": "a914cac486d4e32224f429465c4664f6e1598344bdd187",
                  "reqSigs": 1,
                  "type": "scripthash"
                },
                "value": 0.00001
              }
            ],
            "vsize": 142,
            "weight": 566
          },
          "verbose": "true"
        },
        "error": null
      },
      "status": "completed",
      "task": {
        "ID": 2,
        "CreatedAt": "2020-01-17T11:22:51.955138437-05:00",
        "UpdatedAt": "2020-01-17T11:22:51.955138437-05:00",
        "DeletedAt": null,
        "type": "bitcoin",
        "confirmations": 0,
        "params": {
          "rpc_command": "getrawtransaction",
          "tx_id": "96f4cfef79bedea7b389dd07dff5aaf491a8932ec7d5a2bd2d96dfbc916031ee",
          "verbose": "true"
        }
      },
      "minimumConfirmations": null,
      "confirmations": null
    }
  ],
  "createdAt": "2020-01-17T11:22:51.965404161-05:00",
  "finishedAt": "2020-01-17T11:22:52.138462225-05:00",
  "updatedAt": "2020-01-17T11:22:52.139800526-05:00",
  "creationHeight": null,
  "observedHeight": null,
  "overrides": {},
  "initiator": {
    "type": "runat",
    "params": {
      "time": "2019-09-20T12:20:00Z",
      "ran": true
    }
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
run.add("tx_id", "ffb7421e996d7b922157d36d082a6acac0b8313822bd44b935439bc861996dd6")
run.add("verbose", "true")
string[] memory copyPath = new string[](2);
copyPath[0] = "tx_raw";
copyPath[1] = "blocktime";
```
