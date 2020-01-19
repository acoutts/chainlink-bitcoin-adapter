# bitcoin-tx-blocktime

This example queries for a Bitcoin transaction using a supplied `tx_id` and saves the resulting block time of the transaction into the contract state.

## Jobspec

```json
{
  "initiators": [
    {
      "type": "runlog",
      "params": {
        "address": "YOUR_ORACLE_CONTRACT_ADDRESS_HERE"
      }
    }
  ],
  "tasks": [
    {
      "type": "bitcoin",
      "confirmations": null,
      "params": {}
    },
    {
      "type": "copy",
      "confirmations": null,
      "params": {}
    },
    {
      "type": "ethint256",
      "confirmations": null,
      "params": {}
    },
    {
      "type": "ethtx",
      "confirmations": null,
      "params": {}
    }
  ],
  "startAt": null,
  "endAt": null
}
```

## `requestBlockTime`

Call the request function with the following paramters:

```
address _oracle, string _jobId, string _tx_id, string _path
```

Example (replace oracle, jobId, and tx_id with your values):

```
0x671f9d685d02fccC69C93AceE0E3ED2930Fb6972, acfb1adbefd646639bc5688ddf52b8c6,  96f4cfef79bedea7b389dd07dff5aaf491a8932ec7d5a2bd2d96dfbc916031ee, tx.blocktime
```

## JSON result

```json
{
  "id": "4df6702ccc654f25b24e063ed6abc6c6",
  "jobId": "acfb1adbefd646639bc5688ddf52b8c6",
  "result": {
    "data": {
      "ethereumReceipts": [
        {
          "blockHash": "0x17a1973d39ac3320c3ebf73646fe802ca425046e38eb9098dfc1a445a395e777",
          "blockNumber": 7151117,
          "logs": [
            {
              "address": "0xdb619553b2fcd33017df31e24236847161143e1e",
              "blockHash": "0x17a1973d39ac3320c3ebf73646fe802ca425046e38eb9098dfc1a445a395e777",
              "blockNumber": "0x6d1e0d",
              "data": "0x",
              "logIndex": "0x0",
              "removed": false,
              "topics": [
                "0x7cc135e0cebb02c3480ae5d74d377283180a2601f8f644edf7987b009316c63a",
                "0x3bbad9971300df3c3cddca0cc9b407d9f72469fb098fac2c03fa9825dc3b3bf1"
              ],
              "transactionHash": "0x81e406adfd205258799047a3c32587df57250a9246b65d447dad88180b8fc417",
              "transactionIndex": "0x1"
            },
            {
              "address": "0xdb619553b2fcd33017df31e24236847161143e1e",
              "blockHash": "0x17a1973d39ac3320c3ebf73646fe802ca425046e38eb9098dfc1a445a395e777",
              "blockNumber": "0x6d1e0d",
              "data": "0x",
              "logIndex": "0x1",
              "removed": false,
              "topics": [
                "0x18755818b6bb5cb3a40bc144c3f4c9dbd63e615abd19d95099da6536178a4f34",
                "0x3bbad9971300df3c3cddca0cc9b407d9f72469fb098fac2c03fa9825dc3b3bf1",
                "0x000000000000000000000000000000000000000000000000000000005e1f37f7"
              ],
              "transactionHash": "0x81e406adfd205258799047a3c32587df57250a9246b65d447dad88180b8fc417",
              "transactionIndex": "0x1"
            }
          ],
          "transactionHash": "0x81e406adfd205258799047a3c32587df57250a9246b65d447dad88180b8fc417"
        }
      ],
      "latestOutgoingTxHash": "0x81e406adfd205258799047a3c32587df57250a9246b65d447dad88180b8fc417",
      "result": "0x81e406adfd205258799047a3c32587df57250a9246b65d447dad88180b8fc417"
    },
    "error": null
  },
  "status": "completed",
  "taskRuns": [
    {
      "id": "bb99881c9dbd41f4a6d2aa3d1f07ee99",
      "result": {
        "data": {
          "address": "0x671f9d685d02fccC69C93AceE0E3ED2930Fb6972",
          "copyPath": "tx_raw.blocktime",
          "dataPrefix": "0x3bbad9971300df3c3cddca0cc9b407d9f72469fb098fac2c03fa9825dc3b3bf10000000000000000000000000000000000000000000000000de0b6b3a7640000000000000000000000000000db619553b2fcd33017df31e24236847161143e1ebef52c0100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005e23ba5c",
          "functionSelector": "0x4ab0d190",
          "rpc_command": "getRawTransaction",
          "tx_id": "96f4cfef79bedea7b389dd07dff5aaf491a8932ec7d5a2bd2d96dfbc916031ee",
          "tx": {
            "blockhash": "00000000000000000010bf70a87dea443ebf75475b0cb4c05cca5d200b1a9142",
            "blocktime": 1579104247,
            "confirmations": 499,
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
          }
        },
        "error": null
      },
      "status": "completed",
      "task": {
        "ID": 43,
        "CreatedAt": "2020-01-18T21:04:04.53717837-05:00",
        "UpdatedAt": "2020-01-18T21:04:04.53717837-05:00",
        "DeletedAt": null,
        "type": "bitcoin",
        "confirmations": null,
        "params": {}
      },
      "minimumConfirmations": 3,
      "confirmations": 3
    },
    {
      "id": "07ac50e2f0834ce38e5ac9722d512171",
      "result": {
        "data": {
          "result": 1579104247
        },
        "error": null
      },
      "status": "completed",
      "task": {
        "ID": 44,
        "CreatedAt": "2020-01-18T21:04:04.537417436-05:00",
        "UpdatedAt": "2020-01-18T21:04:04.537417436-05:00",
        "DeletedAt": null,
        "type": "copy",
        "confirmations": null,
        "params": {}
      },
      "minimumConfirmations": 3,
      "confirmations": null
    },
    {
      "id": "dccd501cdcae43f5911f9df125fbb8fd",
      "result": {
        "data": {
          "result": "0x000000000000000000000000000000000000000000000000000000005e1f37f7"
        },
        "error": null
      },
      "status": "completed",
      "task": {
        "ID": 45,
        "CreatedAt": "2020-01-18T21:04:04.537637282-05:00",
        "UpdatedAt": "2020-01-18T21:04:04.537637282-05:00",
        "DeletedAt": null,
        "type": "ethint256",
        "confirmations": null,
        "params": {}
      },
      "minimumConfirmations": 3,
      "confirmations": null
    },
    {
      "id": "3c44af3f9e1840bdac97760db7d28f3c",
      "result": {
        "data": {
          "ethereumReceipts": [
            {
              "blockHash": "0x17a1973d39ac3320c3ebf73646fe802ca425046e38eb9098dfc1a445a395e777",
              "blockNumber": 7151117,
              "logs": [
                {
                  "address": "0xdb619553b2fcd33017df31e24236847161143e1e",
                  "blockHash": "0x17a1973d39ac3320c3ebf73646fe802ca425046e38eb9098dfc1a445a395e777",
                  "blockNumber": "0x6d1e0d",
                  "data": "0x",
                  "logIndex": "0x0",
                  "removed": false,
                  "topics": [
                    "0x7cc135e0cebb02c3480ae5d74d377283180a2601f8f644edf7987b009316c63a",
                    "0x3bbad9971300df3c3cddca0cc9b407d9f72469fb098fac2c03fa9825dc3b3bf1"
                  ],
                  "transactionHash": "0x81e406adfd205258799047a3c32587df57250a9246b65d447dad88180b8fc417",
                  "transactionIndex": "0x1"
                },
                {
                  "address": "0xdb619553b2fcd33017df31e24236847161143e1e",
                  "blockHash": "0x17a1973d39ac3320c3ebf73646fe802ca425046e38eb9098dfc1a445a395e777",
                  "blockNumber": "0x6d1e0d",
                  "data": "0x",
                  "logIndex": "0x1",
                  "removed": false,
                  "topics": [
                    "0x18755818b6bb5cb3a40bc144c3f4c9dbd63e615abd19d95099da6536178a4f34",
                    "0x3bbad9971300df3c3cddca0cc9b407d9f72469fb098fac2c03fa9825dc3b3bf1",
                    "0x000000000000000000000000000000000000000000000000000000005e1f37f7"
                  ],
                  "transactionHash": "0x81e406adfd205258799047a3c32587df57250a9246b65d447dad88180b8fc417",
                  "transactionIndex": "0x1"
                }
              ],
              "transactionHash": "0x81e406adfd205258799047a3c32587df57250a9246b65d447dad88180b8fc417"
            }
          ],
          "latestOutgoingTxHash": "0x81e406adfd205258799047a3c32587df57250a9246b65d447dad88180b8fc417",
          "result": "0x81e406adfd205258799047a3c32587df57250a9246b65d447dad88180b8fc417"
        },
        "error": null
      },
      "status": "completed",
      "task": {
        "ID": 46,
        "CreatedAt": "2020-01-18T21:04:04.537851243-05:00",
        "UpdatedAt": "2020-01-18T21:04:04.537851243-05:00",
        "DeletedAt": null,
        "type": "ethtx",
        "confirmations": null,
        "params": {}
      },
      "minimumConfirmations": 3,
      "confirmations": 3
    }
  ],
  "createdAt": "2020-01-18T21:04:48.282427909-05:00",
  "finishedAt": "2020-01-18T21:05:31.379895405-05:00",
  "updatedAt": "2020-01-18T21:05:31.381089326-05:00",
  "creationHeight": 7151113,
  "observedHeight": 7151118,
  "overrides": {
    "address": "0x671f9d685d02fccC69C93AceE0E3ED2930Fb6972",
    "copyPath": "tx_raw.blocktime",
    "dataPrefix": "0x3bbad9971300df3c3cddca0cc9b407d9f72469fb098fac2c03fa9825dc3b3bf10000000000000000000000000000000000000000000000000de0b6b3a7640000000000000000000000000000db619553b2fcd33017df31e24236847161143e1ebef52c0100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005e23ba5c",
    "functionSelector": "0x4ab0d190",
    "rpc_command": "getRawTransaction",
    "tx_id": "96f4cfef79bedea7b389dd07dff5aaf491a8932ec7d5a2bd2d96dfbc916031ee"
  },
  "payment": "1000000000000000000",
  "initiator": {
    "type": "runlog",
    "params": {
      "address": "0x671f9d685d02fccc69c93acee0e3ed2930fb6972"
    }
  }
}
```
