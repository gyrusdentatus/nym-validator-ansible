# Ansible Role: nym validator

## !!! This role was for an older testnet of Nym v0.10.0-0.10.1 and is deprecated - please see the newer repo, the role itself is way better and will be probably updated for the mainnet with added features. 

## Description

Deploy nym validator using ansible. With an option to install the right version of Go on your local machine to compile binaries locally.
This role also takes care of TLS certs with a little help of certbot and installs nginx on your domain. 


## Requirements

- Ansible >= 2.9 (It might work on previous versions, but we cannot guarantee it)
- Go version >=1.15 (possible to use included go-install task if you need to automate this. Stock version on my Ubuntu 20.04 was 1.14 and it did not work.)
- Debian-based distro (other distros will be added soon.)
- domain name with set up DNS records for your host ip. 

## Role Variables

All variables which can be overridden are stored in [roles/nym-validator-ansible/defaults/main.yml](defaults/main.yml)
Check that file first and edit as needed. 

## Usage


- `git clone https://github.com/gyrusdentatus/nym-validator-ansible`

You can use this as it is or put the role in your ansible roles directory. 
If you decide to use this as a solo lone repo outside ~/.ansible or /etc/ansible then make sure you edit the `ansible.cfg` and add your **ssh-key** path. 
- uncomment this and add the correct path for your ssh key`#private_key_file = ~/.ssh/<SSH-KEY>` 


Then execute the playbook from a directory you just cloned where you have your **inventory**(hosts) file(edit the example from this repo) and **playbook1.yaml**.

Ansible will look for the supplied role in nym-validator/roles/nym-validator/ directory and for tasks within that directory. 

The example playbook looks like this:
```yaml
- hosts: all
  roles: 
    - nym-validator
  environment: 
    LD_LIBRARY_PATH: /home/nym/nymd/
```
You need to include the LD_LIBRARY_PATH either in the playbook itself or set in vars at some place. This worked the best for me. 

Make sure to check list of tasks in [tasks/main.yml](tasks/main.yml) ! 

To compile the binaries on the target host run the playbook with following tags as in this example:

```sh
ansible-playbook -i hosts.yaml playbook1.yaml --tags="install_go_remote, nginx_proxy, remote_host_build, validator_init, validator_run" -v
```
Here is a list of all tags: `install_go_local, install_go_remote, localhost_build, nginx_proxy, remote_host_build, validator_init, validator_run`

For compiling the validator the usual way on a local/master machine, run it as in the example above, only change "remote" to "local" from the very same example. 

**WARNING:** If you do not want to install latest version of **Go** on your local machine, then uncomment the first *import_tasks:* or use option to exclude tags. Tags are listed in `/roles/tasks/go_install.yml` - this is still a rough draft so they are not listed in this README.  

To execute the sample playbook after you tweak variables in [defaults/main.yml](defaults/main.yml) and hosts.yaml, simply run this from ~/.ansible/ directory:
```
ansible-playbook -i hosts.yaml playbook1.yaml -v 
```
add `--step` if you want to confirm each task. 

You might also run into issues with permissions on your local machine - if that is the case, then add `--become -K` 
