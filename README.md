###  Steps for using SSH to access vagrant machine
- Add ssh key to `./data` directory
- Run `ssh vagrant@192.168.56.10`
  - *note*: You might need to update this IP based on your machines allowed IP range

### Resources allocated to vagrant machine
- RAM: 1Gb
- CPU: 1CPU

### Start and stop vagrant machine:
- Start: `vagrant up`
- Stop: `vagrant destroy`


### Setting up node exporter
```console
python3 -m venv env
source ./env/bin/activate
ansible-galaxy install -r ansible/ansible-galaxy.yml
ansible-playbook  -i ansible/hosts.ini -u vagrant ansible/playbook.yml
```
