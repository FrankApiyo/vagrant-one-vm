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
ansible-playbook  -i ansible/hosts.ini -u vagrant ansible/playbook.yml --vault-password-file=vault_password.txt
```
*ansible-playbook* might take around 10 minutes to complete

### copying an image to an S3 bucket:
```bash
aws s3 cp ~/Downloads/profile.jpeg s3://savannah-bucket/
```

### Check service status with monit
```
root@linux-vm:/home/test_api_user/app# monit status
Monit 5.26.0 uptime: 17m

Remote Host 'test-api'
  status                       OK
  monitoring status            Waiting
  monitoring mode              active
  on reboot                    start
  port response time           16.025 ms to localhost:8000 type TCP/IP protocol HTTP
  data collected               Sat, 14 Dec 2024 10:01:12

System 'linux-vm'
  status                       OK
  monitoring status            Monitored
  monitoring mode              active
  on reboot                    start
  load average                 [0.01] [0.11] [0.14]
  cpu                          0.6%us 0.4%sy 0.1%wa
  memory usage                 297.7 MB [30.8%]
  swap usage                   0 B [0.0%]
  uptime                       32m
  boot time                    Sat, 14 Dec 2024 09:29:50
  data collected               Sat, 14 Dec 2024 10:02:12
```

### Manage api service with systemctl

```
root@linux-vm:/home/test_api_user/app# systemctl list-units --type=service | grep api
  test-api.service                     loaded active running Docker Compose Application
root@linux-vm:/home/test_api_user/app# systemctl restart test-api.service
```

### Metrics to look out for
- `node_memory_MemAvailable_bytes`

