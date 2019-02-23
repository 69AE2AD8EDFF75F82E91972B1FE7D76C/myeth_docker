# Docker file with `Swarm` and `Geth` with fixed difficulty set to 100000.

### 1. Build docker
- First build docker container. In main directory run:
  - `docker-compose build` to build docker image
  - `docker-compose up -d myeth` to run containter
  - `docker exec -it myeth bash` to attach to running container
  
### 2. Run ethereum
- After last command you are in docker container.  To run ethereum private blockchain few more steps are requiered.
  - `geth --datadir /eth/gethData init /eth/genesis.json`  to initialize blockchain from prepared genesis file
  ```log
  INFO [02-23|13:33:40.683] Maximum peer count                       ETH=25 LES=0 total=25
  INFO [02-23|13:33:40.683] Allocated cache and file handles         database=/eth/gethData/geth/chaindata cache=16.00MiB handles=16
  INFO [02-23|13:33:40.700] Writing custom genesis block
  INFO [02-23|13:33:40.700] Persisted trie from memory database      nodes=0 size=0.00B time=3.8µs gcnodes=0 gcsize=0.00B gctime=0s livenodes=1 livesize=0.00B
  INFO [02-23|13:33:40.701] Successfully wrote genesis state         database=chaindata                    hash=3c53c8…98ff2b
  INFO [02-23|13:33:40.701] Allocated cache and file handles         database=/eth/gethData/geth/lightchaindata cache=16.00MiB handles=16
  INFO [02-23|13:33:40.714] Writing custom genesis block
  INFO [02-23|13:33:40.714] Persisted trie from memory database      nodes=0 size=0.00B time=4.4µs gcnodes=0 gcsize=0.00B gctime=0s livenodes=1 livesize=0.00B
  INFO [02-23|13:33:40.715] Successfully wrote genesis state         database=lightchaindata                    hash=3c53c8…98ff2b
  ```
  - `geth --datadir /eth/gethData --networkid 666 --rpc --rpcaddr "0.0.0.0" --rpccorsdomain "*" --nodiscover` to **#RUN ETHEREUM**
- Now this console will display output from geth:
  ```log
  INFO [02-23|13:33:48.712] Maximum peer count                       ETH=25 LES=0 total=25
  INFO [02-23|13:33:48.713] Starting peer-to-peer node               instance=Geth/v1.9.0-unstable-5b8ae788/linux-amd64/go1.9.3
  INFO [02-23|13:33:48.713] Allocated trie memory caches             clean=256.00MiB dirty=256.00MiB
  INFO [02-23|13:33:48.713] Allocated cache and file handles         database=/eth/gethData/geth/chaindata cache=512.00MiB handles=524288
  INFO [02-23|13:33:48.747] Initialised chain configuration          config="{ChainID: 666 Homestead: 0 DAO: <nil> DAOSupport: false EIP150: <nil> EIP155: 0 EIP158: 0 Byzantium: <nil> Constantinople: <nil>  ConstantinopleFix: <nil> Engine: unknown}"
  INFO [02-23|13:33:48.747] Disk storage enabled for ethash caches   dir=/eth/gethData/geth/ethash count=3
  INFO [02-23|13:33:48.747] Disk storage enabled for ethash DAGs     dir=/root/.ethash             count=2
  INFO [02-23|13:33:48.747] Initialising Ethereum protocol           versions="[63 62]" network=666
  INFO [02-23|13:33:48.800] Loaded most recent local header          number=0 hash=3c53c8…98ff2b td=0 age=49y10mo1w
  INFO [02-23|13:33:48.800] Loaded most recent local full block      number=0 hash=3c53c8…98ff2b td=0 age=49y10mo1w
  INFO [02-23|13:33:48.800] Loaded most recent local fast block      number=0 hash=3c53c8…98ff2b td=0 age=49y10mo1w
  INFO [02-23|13:33:48.801] Regenerated local transaction journal    transactions=0 accounts=0
  INFO [02-23|13:33:48.818] New local node record                    seq=1 id=ec175f130ff83e09 ip=127.0.0.1 udp=0 tcp=30303
  INFO [02-23|13:33:48.818] Started P2P networking                   self="enode://c36011f01125415f189119936c651551e7927159d364159c84e0886e83b18efb0e7dd0736d8305e164e34bc12c02805680a632440ecf6bae0a8ae729471703f2@127.0.0.1:30303?discport=0"
  INFO [02-23|13:33:48.819] IPC endpoint opened                      url=/eth/gethData/geth.ipc
  INFO [02-23|13:33:48.819] HTTP endpoint opened                     url=http://0.0.0.0:8545    cors=* vhosts=localhost
  INFO [02-23|13:34:29.327] Etherbase automatically configured       address=0x5C0295daF207c7bBdEF07f1C77e9aCB346f0e6D6
  ```
- To stop geth use `Ctrl+C`. To run again from this point, use **#RUN ETHEREUM** command once again.
  
### 3. Connect to geth JS console 
- In second console on host in **main repo directory** run:
  - `docker exec -it myeth bash` to attach to running container
  - `geth attach --datadir /eth/gethData` to attach to geth JS console
    ```log
    Welcome to the Geth JavaScript console!
    instance: Geth/v1.9.0-unstable-5b8ae788/linux-amd64/go1.9.3
    coinbase: 0x5c0295daf207c7bbdef07f1c77e9acb346f0e6d6
    at block: 123 (Sat, 23 Feb 2019 08:02:45 UTC)
    datadir: /eth/gethData
    modules: admin:1.0 debug:1.0 eth:1.0 ethash:1.0 miner:1.0 net:1.0 personal:1.0 rpc:1.0 txpool:1.0 web3:1.0
    > _
    ```    
### 4. Enjoy
- In geth JS console run:
  - `eth.accounts` to display predefined accounts. Password for both is **`123`**. First account is defined as a coinbase and all mined ETH will go to this account.
  ```log
  ["0x5c0295daf207c7bbdef07f1c77e9acb346f0e6d6", "0xaa9fac0d862c09dddd3ab53001fd72d50c0f7c47"]
  ```
  - `eth.getBalance("0x5c0295daf207c7bbdef07f1c77e9acb346f0e6d6")` to display account balace. Should be `0`
  - `eth.mining` to display mining status. Result `false`
  - `miner.start(1)` to start mining with 1 thread. Result `null`
  - `miner.stop()` to stop mining. Result `null`
- when mining is started first time, geth must generate DAG file (2GB in ~/.ethash/ directory). This will take a while. Geth output should look like:
  ```log
  INFO [02-23|13:44:46.632] Generating DAG in progress               epoch=0 percentage=0 elapsed=2.078s
  INFO [02-23|13:44:48.607] Generating DAG in progress               epoch=0 percentage=1 elapsed=4.053s
  INFO [02-23|13:44:50.647] Generating DAG in progress               epoch=0 percentage=2 elapsed=6.093s
  ...
  INFO [02-23|13:46:30.299] Generating DAG in progress               epoch=0 percentage=49 elapsed=1m45.745s
  INFO [02-23|13:46:32.335] Generating DAG in progress               epoch=0 percentage=50 elapsed=1m47.781s
  INFO [02-23|13:46:34.401] Generating DAG in progress               epoch=0 percentage=51 elapsed=1m49.847s
  ...
  INFO [02-23|13:48:00.295] Generating DAG in progress               epoch=0 percentage=92 elapsed=3m15.741s
  INFO [02-23|13:48:12.443] Generating DAG in progress               epoch=0 percentage=98 elapsed=3m27.890s
  INFO [02-23|13:48:14.524] Generating DAG in progress               epoch=0 percentage=99 elapsed=3m29.970s
  INFO [02-23|13:48:14.527] Generated ethash verification cache      epoch=0 elapsed=3m29.974s
  INFO [02-23|13:48:18.447] Generating DAG in progress               epoch=1 percentage=0  elapsed=3.280s
  INFO [02-23|13:48:19.305] Successfully sealed new block            number=1 sealhash=44d23c…70a2f5 hash=fba12f…74bbbf elapsed=3m35.327s
  INFO [02-23|13:48:19.305] 🔨 mined potential block                  number=1 hash=fba12f…74bbbf
  INFO [02-23|13:48:19.318] Commit new mining work                   number=2 sealhash=64a28a…ecd78c uncles=0 txs=0 gas=0 fees=0 elapsed=99.8µs
  INFO [02-23|13:48:20.223] Successfully sealed new block            number=2 sealhash=64a28a…ecd78c hash=9613bb…0fd318 elapsed=904.680ms
  INFO [02-23|13:48:20.223] 🔨 mined potential block                  number=2 hash=9613bb…0fd318
  ```
- now mining has been started and new blocks are commited to blockchain
- In geth JS console run:
  - `eth.getBalance(eth.coinbase)` to return account balance in WEI `535000000000000000000`
  - `personal.unlockAccount("0x5c0295daf207c7bbdef07f1c77e9acb346f0e6d6", "123", 15000)` to unlock coinbase account and give a chance to send ETH to another account
  - `eth.sendTransaction({from:"0x5c0295daf207c7bbdef07f1c77e9acb346f0e6d6", to: "0xaa9fac0d862c09dddd3ab53001fd72d50c0f7c47",value: "5000000000000000000", gasPrice:20 , gas: 21000})` to send 5 ETH to second account. As a result hash of newly created transaction `"0x60633ac673895b0bd4ec10737df7d7ef5f1f6ca98321331d791bb18290297f2f"`
  - if mining is `off` transaction will wait to be mined in `txpool.content` at pending section
  - after mining started again `txpool.content` should be empty
  - if `txpool` is empty transaction is commited to blockchain and second account balance `eth.getBalance("0xaa9fac0d862c09dddd3ab53001fd72d50c0f7c47")` should be 5 ETH in WEI `5000000000000000000`
