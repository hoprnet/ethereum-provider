Ethereum provider
=========

This repository provides ansible playbooks to install and Ethereum provider. The Ethereum provider can work with Gnosis XDai or Goerli networks. 
[Hoprnet](https://hoprnet.org/) has deployed this repository into his infrastructure and it is available publicly to anyone at these endpoints:
* https://primary.gnosis-chain.rpc.hoprtech.com
* https://secondary.gnosis-chain.rpc.hoprtech.com
* https://primary.goerli-chain.rpc.hoprtech.com
* https://secondary.goerli-chain.rpc.hoprtech.com


This ansible playbook uses an [HAProxy](http://www.haproxy.org/) to provide SSL frontends and load balancing across multiple [Nethermind Ethereum](https://nethermind.io) clients that are in charge of synchronizing the Gnosis Chain network.

The [Hoprnet](https://github.com/hoprnet/hoprnet) protocol is already using these ethereum provider endpoints and has no dependenecy with other third party providers.


Architecture
------------
The next diagram shows the infrastructure example that is deployed for Gnosis XDai. 
![Gnosis xDai infrastructure](./diagram.png "Gnosis xDai infrastructure")


An equivalent infrastructure has been deployed to Goerli

Test endpoints
------------

Gnosis XDai
```
curl -H "Origin: http://primary.gnosis-chain.rpc.hoprtech.com" -X POST --data '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":67}' https://primary.gnosis-chain.rpc.hoprtech.net
```
```
curl -H "Origin: http://secondary.gnosis-chain.rpc.hoprtech.com" -X POST --data '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":67}' https://secondary.gnosis-chain.rpc.hoprtech.net
```

Goerli
```
curl -H "Origin: http://primary.goerli-chain.rpc.hoprtech.com" -X POST --data '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":67}' https://primary.goerli-chain.rpc.hoprtech.net
```
```
curl -H "Origin: http://secondary.goerli-chain.rpc.hoprtech.com" -X POST --data '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":67}' https://secondary.goerli-chain.rpc.hoprtech.net
```



Installation
------------

- Specify inventory hosts names at your will by modifying [hosts.yaml](./inventories/stage/hosts.yaml)


- Install requirements
```
    make galaxy
```
- Install Ethereum provider
```   
    make install env=stage
```
Requirements
------------

This playbook requires this roles to be installed (It is done throught the `make galaxy` command):


  - [Ansible docker role](https://github.com/geerlingguy/ansible-role-docker)
  - [Ansible nethermind role](https://github.com/hoprnet/ansible-role-nethermind.git)
  - [Ansible certbot role](https://github.com/hoprnet/ansible-role-certbot.git)
  - [Ansible haproxy role](https://github.com/hoprnet/ansible-role-haproxy.git)

Playbook Variables
--------------

| Variables | Required | Default value | Description |
|-----------|----------|---------------|-------------|
| gnosis_domain_name  | true     | *primary.gnosis-chain.rpc.hoprtech.net*          | DNS name for the gnosis chain. Should be specified as host variable at the inventory to provide different values for each host. |
| goerli_domain_name  | true     | *primary.goerli-chain.rpc.hoprtech.net*          | DNS name for the goerli chain. Should be specified as host variable at the inventory to provide different values for each host. |
| gnosis_backend_port  | true     | *8545*          | Port used to communicate between HA Proxy and Nethermind for Gnosis |
| goerli_backend_port  | true     | *8546*          | Port used to communicate between HA Proxy and Nethermind for Goerli |
| gnosis_backend_hosts  | true     | *[IP1, IP2]*          | List of IP of the Nethermind hosts for Gnosis |
| goerli_backend_hosts  | true     | *[IP1, IP2]*          | List of IP of the Nethermind hosts for Goerli |

These variables are set at the inventory level. Have a look at them [here](./inventories/stage/)


License
-------

MIT
Author Information
------------------

This role was created by [Hopr](https://hoprnet.org/)

