Ethereum provider
=========

This repository provides an ansible playbook to install and Ethereum provider on Debian based linux machines. The Ethereum provider can work with Gnosis XDai or Goerli networks. 
[Hoprnet](https://hoprnet.org/) has deployed this playbook into his infrastructure and it is available publicly to anyone at these endpoints:
* https://primary.gnosis-chain.rpc.hoprtech.com
* https://secondary.gnosis-chain.rpc.hoprtech.com
* https://primary.goerli-chain.rpc.hoprtech.com
* https://secondary.goerli-chain.rpc.hoprtech.com

The [Hoprnet](https://github.com/hoprnet/hoprnet) protocol is already using these ethereum provider endpoints and has no dependenecy with other third party providers.


This repo takes into consideration that you might need to provide a high availability service, and thats why we use an [HAProxy](http://www.haproxy.org/) to perform the load balancing across multiple [Nethermind Ethereum](https://nethermind.io) clients that are in charge of synchronizing the Gnosis Chain network. The frontends defined at HAProxy are configured with SSL.

This repository is shipped with the configuration of Gnosis XDai and Goerli chains but more endpoints could be provided easily by :
* Modifying the [nethermind.yaml](./playbooks/nethermind.yaml) to invoke an additional `hopr.nethermind` role by specify other values
* Modifying the [haproxy.yaml](./playbooks/haproxy.yaml) to add more domain at the list. Be sure that you add as well the specific domain name at the corresponding `./inventories/hosts_vars/primary` and `./inventories/hosts_vars/secondary`.

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

- Create 4 Debian linux machines, they can be bare metal or virtual machines.
- In case that you are using a dynamic ansible inventory, then modify the [hosts.yaml](./inventories/hosts.yaml) file to assign the hostnames to the desired groups `loadbalancers` and `nethermind`. Some dynamic ansible inventories use tag machines for grouping, so tagging the machine would be a simplier way. 
- In case that you are using a static ansible inventory, then create a file called `ssh_config` at the root of this repo that will have the ssh configuration to connect to those linux machines. Here is an example of the contents of this file:
  ````
  # Add this line to your ~/.ssh/config file
  ## Load Balancers
  Host primary
      HostName W.X.Y.Z
      User root
      Port 22
      IdentityFile ~/.ssh/<your_host_private_key>
      StrictHostKeyChecking no
      IdentitiesOnly yes

  Host secondary
      HostName W.X.Y.Z
      User root
      Port 22
      IdentityFile ~/.ssh/<your_host_private_key>
      StrictHostKeyChecking no
      IdentitiesOnly yes

  Host nethermind01
      HostName W.X.Y.Z
      User root
      Port 22
      IdentityFile ~/.ssh/<your_host_private_key>
      StrictHostKeyChecking no
      IdentitiesOnly yes

  Host nethermind02
      HostName W.X.Y.Z
      User root
      Port 22
      IdentityFile ~/.ssh/<your_host_private_key>
      StrictHostKeyChecking no
      IdentitiesOnly yes
  ````
  - Add this line into your `~/.ssh/config` file to check that you can connect to them
  ```
  Include <full_github_repo_path>/ssh_config
  ```
  - Check connectivity through
  ```
  ssh primary
  ssh secondary
  ssh nethermind01
  ssh nethermind02
  ```
  - Specify inventory hosts names at your will by modifying [hosts.yaml](./inventories/hosts.yaml)
- Install ansible role requirements
```
    make galaxy
```
- Execute ansible playbook for the Ethereum provider
```   
    make install
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

These variables are set at the inventory level. Have a look at them [here](./inventories/)


License
-------

MIT

Author Information
------------------

This role was created by [Hopr](https://hoprnet.org/)

