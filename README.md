Ethereum provider
=========

This repository provides an Ansible playbook to install a highly scalable, available and performant Ethereum RPC provider on Debian based linux machines. It comprises multiple load balancers and multiple Nethermind (execution layer) full nodes.

We also provide deployments for Gnosis Chain (previously known as xDai) and Goerli networks. 
At [HOPR](https://hoprnet.org/) we have deployed this playbook into our infrastructure and it is available publicly to anyone at these endpoints:
* https://primary.gnosis-chain.rpc.hoprtech.net
* https://secondary.gnosis-chain.rpc.hoprtech.net
* https://primary.goerli.rpc.hoprtech.net
* https://secondary.goerli.rpc.hoprtech.net

The [HOPR](https://github.com/hoprnet/hoprnet) protocol is already using these Ethereum provider endpoints and has no dependenecy with other third party providers.

This repo aims at providing a high availability service, and that's why we use an [HAProxy](http://www.haproxy.org/) to perform the load balancing across multiple [Nethermind Ethereum](https://nethermind.io) clients that are pre-configured to run the Gnosis Chain network. The frontends defined at HAProxy are configured with SSL.

This repository is shipped with the configuration of Gnosis Chain and Goerli chains but more endpoints could be provided easily by:
* Modifying the [nethermind.yaml](./playbooks/nethermind.yaml) to invoke an additional `hopr.nethermind` role by specify other values
* Modifying the [haproxy.yaml](./playbooks/haproxy.yaml) to add more domain at the list. Be sure that you add as well the specific domain name at the corresponding `./inventories/hosts_vars/primary` and `./inventories/hosts_vars/secondary`.

Architecture
------------
The below diagram shows the infrastructure example that is deployed for Gnosis Chain:
![Gnosis xDai infrastructure](./diagram.png "Gnosis xDai infrastructure")

An equivalent infrastructure has been deployed to Goerli

Public endpoints
------------

Gnosis Chain
```
curl -H "Origin: http://primary.gnosis-chain.rpc.hoprtech.net" -X POST --data '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":67}' https://primary.gnosis-chain.rpc.hoprtech.net
```
```
curl -H "Origin: http://secondary.gnosis-chain.rpc.hoprtech.net" -X POST --data '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":67}' https://secondary.gnosis-chain.rpc.hoprtech.net
```

Goerli
```
curl -H "Origin: http://primary.goerli.rpc.hoprtech.net" -X POST --data '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":67}' https://primary.goerli.rpc.hoprtech.net
```
```
curl -H "Origin: http://secondary.goerli.rpc.hoprtech.net" -X POST --data '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":67}' https://secondary.goerli.rpc.hoprtech.net
```



Installation
------------
If you want to create your own instance of Ethereum nodes, you can follow the following steps:
- Create 4 Debian linux machines, they can be bare metal or virtual machines.
- In case you are using a dynamic Ansible inventory, modify the [hosts.yaml](./inventories/hosts.yaml) file to assign the hostnames to the desired groups `loadbalancers` and `nethermind`. Some dynamic Ansible inventories use tag machines for grouping, so tagging the machine would be a simpler way. 
- In case you are using a static Ansible inventory, create a file called `ssh_config` at the root of this repo that will have the ssh configuration to connect to the linux machines which you created in the first step. Here is an example of the contents of that file:
  ````
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
  
  # Nethermind nodes
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
  - If your hosts have a different name than the example above, specify those names at the inventory file hosts by modifying [hosts.yaml](./inventories/hosts.yaml)
- Install ansible role requirements
```
    make galaxy
```
- Execute Ansible playbook for the Ethereum provider
```   
    make install
```
Requirements
------------

This playbook requires these roles to be installed (via the `make galaxy` command):

  - [Ansible docker role](https://github.com/geerlingguy/ansible-role-docker)
  - [Ansible nethermind role](https://github.com/hoprnet/ansible-role-nethermind.git)
  - [Ansible certbot role](https://github.com/hoprnet/ansible-role-certbot.git)
  - [Ansible haproxy role](https://github.com/hoprnet/ansible-role-haproxy.git)

Playbook Variables
--------------

| Variables | Required | Default value | Description |
|-----------|----------|---------------|-------------|
| gnosis_domain_name  | true     | *primary.gnosis-chain.rpc.hoprtech.net*          | DNS name for the gnosis chain. Should be specified as host variable at the inventory to provide different values for each host. |
| goerli_domain_name  | true     | *primary.goerli.rpc.hoprtech.net*          | DNS name for the goerli chain. Should be specified as host variable at the inventory to provide different values for each host. |
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

This role was created by [HOPR](https://hoprnet.org/)

