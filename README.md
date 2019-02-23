# Docker file with private ethereum network and fixed difficulty set to 100000.

### 1. Build docker
- First build docker container. In main directory run:
  - `docker-compose build` to build docker image
  - `docker-compose up -d myeth` to run containter
  - `docker exec -it myeth bash` to attach to running container
  
### 2. Run ethereum
- After last command you are in docker container.  To run ethereum private blockchain few more steps are requiered.
  - `geth --datadir /eth/gethData init /eth/genesis.json`  to initialize blockchain from prepared genesis file
  - `geth --datadir /eth/gethData --networkid 666 --rpc --rpcaddr "0.0.0.0" --rpccorsdomain "*" --nodiscover` to **#RUN ETHEREUM**
- Now this console will display output from geth: 
  - `INFO [02-23|11:23:57.034] New local node record                    seq=2 id=387479d51019b70b ip=127.0.0.1 udp=0 tcp=30303`
  - `INFO [02-23|11:23:57.034] Started P2P networking                   self="enode://bfc64d8d464e3e4627e2d7a816412359f14b49f0c3432611cdccd146a8353203541ad1823555da1235ec08a8e2ce73f4001be30a4190a505df34a3711eb3453f@127.0.0.1:30303?discport=0"`
  - `INFO [02-23|11:23:57.037] IPC endpoint opened                      url=/eth/gethData/geth.ipc`
  - `INFO [02-23|11:23:57.038] HTTP endpoint opened                     url=http://0.0.0.0:8545    cors=* vhosts=localhost`
- To stop geth use `Ctrl+C`. To run again from this point, use **#RUN ETHEREUM** command once again.
  
### 3. Connect to geth JS console 
- In second console on host in **main repo directory** run:
  - `docker exec -it myeth bash` to attach to running container
  - `geth attach --datadir /eth/gethData` to attach to geth JS console
    - `Welcome to the Geth JavaScript console!`
    - `instance: Geth/v1.9.0-unstable-5b8ae788/linux-amd64/go1.9.3`
    - `coinbase: 0x5c0295daf207c7bbdef07f1c77e9acb346f0e6d6`
    - `at block: 123 (Sat, 23 Feb 2019 08:02:45 UTC)`
    - `datadir: /eth/gethData`
    - `modules: admin:1.0 debug:1.0 eth:1.0 ethash:1.0 miner:1.0 net:1.0 personal:1.0 rpc:1.0 txpool:1.0 web3:1.0`
    - `> _`
    
### 4. Enjoy
- In geth JS console run:
  - `eth.accounts` to display predefined accounts. Password for both is **`123`**
    - `["0x5c0295daf207c7bbdef07f1c77e9acb346f0e6d6", "0xaa9fac0d862c09dddd3ab53001fd72d50c0f7c47"]`
      - First account is defined as a coinbase and all mined ETH will go to this account
  - `eth.getBalance("0x5c0295daf207c7bbdef07f1c77e9acb346f0e6d6")` to display account balace. Should be `0`
  - `eth.mining` to display mining status. Result `false`
  - `miner.start(1)` to start mining with 1 thread. Result `null`
  - `miner.stop()` to stop mining. Result `null`
- when mining is started first time, geth must generate DAG file (2GB in ~/.ethash/ directory). This will take a while. Geth output should look like:
  - `INFO [02-23|11:51:59.099] Generating DAG in progress               epoch=0 percentage=0 elapsed=3.499s`
  - `INFO [02-23|11:52:02.502] Generating DAG in progress               epoch=0 percentage=1 elapsed=6.902s`
  - `INFO [02-23|11:52:06.154] Generating DAG in progress               epoch=0 percentage=2 elapsed=10.553s`
  - `...`
  - `INFO [02-23|11:55:09.002] Generating DAG in progress               epoch=0 percentage=50 elapsed=3m13.401s`
  - `INFO [02-23|11:55:12.591] Generating DAG in progress               epoch=0 percentage=51 elapsed=3m16.991s`
  - `...`
  - `INFO [02-23|11:57:54.374] Generating DAG in progress               epoch=0 percentage=98 elapsed=5m58.774s`
  - `INFO [02-23|11:57:56.412] Generating DAG in progress               epoch=0 percentage=99 elapsed=6m0.811s`
  - `INFO [02-23|11:57:56.415] Generated ethash verification cache      epoch=0 elapsed=6m0.815s`
  - `INFO [02-23|11:57:56.631] Successfully sealed new block            number=1 sealhash=a6861e…3096e9 hash=ef3c77…20a29a elapsed=6m2.027s`
  - `INFO [02-23|11:57:56.631] 🔨 mined potential block                  number=1 hash=ef3c77…20a29a`
  - `INFO [02-23|11:57:56.632] Commit new mining work                   number=2 sealhash=3cf71d…11cecb uncles=0 txs=0 gas=0 fees=0 elapsed=178.1µs`
- now mining has been started and new blocks are commited to blockchain
- In geth JS console run:
  - `eth.getBalance(eth.coinbase)` to return account balance in WEI `535000000000000000000`
  - `personal.unlockAccount("0x5c0295daf207c7bbdef07f1c77e9acb346f0e6d6", "123", 15000)` to unlock coinbase account and give a chance to send ETH to another account
  - `eth.sendTransaction({from:"0x5c0295daf207c7bbdef07f1c77e9acb346f0e6d6", to: "0xaa9fac0d862c09dddd3ab53001fd72d50c0f7c47",value: "5000000000000000000", gasPrice:20 , gas: 21000})` to send 5 ETH to second account. As a result hash of newly created transaction `"0x60633ac673895b0bd4ec10737df7d7ef5f1f6ca98321331d791bb18290297f2f"`
  - if mining is `off` transaction will wait to be mined in `txpool.content` at pending section
  - after mining started again `txpool.content` should be empty
  - if `txpool` is empty transaction is commited to blockchain and second account balance `eth.getBalance("0xaa9fac0d862c09dddd3ab53001fd72d50c0f7c47")` should be 5 ETH in WEI `5000000000000000000`
