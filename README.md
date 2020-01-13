# Chainlink Bitcoin External Adapter

Adapter that connects Chainlink oracle nodes to the bitcoin network faciliating BTC JSON-RPC calls.

This allows Chainlink oracles to return information about BTC transactions and wallet addresses.

Currently tested with btcd backend.
Below is the current status of supported RPC commands and how to call them:
| **RPC Command** | **Status** |
|---------------|--------|
| getblockcount | ✔️ |

# Prerequisites

Make sure you have a btcd instance sync'd and the RPC enabled. You an get btcd here:
https://github.com/btcsuite/btcd

To enable the RPC, ensure there's a `rpcuser` and `rpcpassword` defined in your `btcd.conf` file.

You will also need a copy of `rpc.cert` from the btcd instance to be specified with the `BTCD_RPC_CERT` environment variable when running the adapter.

### Configuration (btcd)

Make sure the instance of btcd you're sending RPC requests was sync'd with the following configuration options enabled:

```
txindex=1
addrindex=1
```

### Contract Usage

To use this adapter on-chain, find a node that supports this adapter and build your request like so:

```
Chainlink.Request memory req = buildChainlinkRequest(jobId, this, this.fulfill.selector);
run.add("rpc_command", "getBlockcount");
string[] memory copyPath = new string[](1);
copyPath[0] = "block_count";
```

### Setup Instructions

#### Local Install

Make sure [Golang](https://golang.org/pkg/) is installed.

Build:

```
make build
```

Then run the adapter:

```
BTCD_RPC_HOST=127.0.0.1:8334 BTCD_RPC_USER=username BTCD_RPC_PASS=password BTCD_RPC_CERT=./rpc.cert ./chainlink-adapter-btcd
```

#### Docker

To run the container:

```
docker run -it -e API_KEY=apikey -p 8080:8080 acoutts/chainlink-bitcoin-adapter
```

Container also supports passing in CLI arguments.

You can add and modify the keys to match what's specified in the API documentation.

### Usage

```
curl -X POST -H 'Content-Type: application/json' \
-d @- << EOF
{
	"jobRunId": "1234",
	"data": {
		"function": "GLOBAL_QUOTE",
		"symbol": "MSFT"
	}
}
EOF
```

Response:

```json
{
  "jobRunId": "1234",
  "status": "completed",
  "error": null,
  "pending": false,
  "data": {
    "Global Quote": {
      "01. symbol": "MSFT",
      "02. open": "133.7900",
      "03. high": "135.6500",
      "04. low": "131.8284",
      "05. price": "135.2800",
      "06. volume": "26682074",
      "07. latest trading day": "2019-08-07",
      "08. previous close": "134.6900",
      "09. change": "0.5900",
      "10. change percent": "0.4380%"
    },
    "function": "GLOBAL_QUOTE",
    "symbol": "MSFT"
  }
}
```
