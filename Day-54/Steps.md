Setup Steps for Ansible Automation
Follow these steps to set up and execute the Ansible playbook for extracting devops.zip on app servers:

Log in to the Jump Host:

Log in as user thor:
```
su - thor
```



Install Ansible (if not already installed):

Update the package index and install Ansible on the CentOS jump host:
```
sudo yum update -y
sudo yum install epel-release -y
sudo yum install ansible -y
```
```
Verify installation:ansible --version
```



Navigate to Ansible Directory:
```
cd /home/thor/ansible
```

Create/Edit Inventory File:
```
Create or edit inventory with the following content:stapp01 ansible_user=tony ansible_ssh_pass=Ir0nM@n
stapp02 ansible_user=steve ansible_ssh_pass=Am3ric@
stapp03 ansible_user=banner ansible_ssh_pass=BigGr33n

```
Command:vi inventory




Create Playbook and Supporting Files:

Create playbook.yml, command.md, readme.md, and steps.md as provided.
Example for playbook.yml:
```
vi playbook.yml
```



Verify Connectivity:
```
ansible -i inventory all -m ping
```

Check Playbook Syntax:
```
ansible-playbook -i inventory playbook.yml --syntax-check
```

Run the Playbook:
```
ansible-playbook -i inventory playbook.yml
```

Verify Results:

Check extracted files:
```
ansible -i inventory all -m shell -a "ls -l /opt/sysops/unarchive"
```

Check permissions and ownership:
```
ansible -i inventory all -m shell -a "ls -ld /opt/sysops/unarchive"
```



Troubleshooting (if needed):

Verify unzip on app servers:
```
ansible -i inventory all -m shell -a "rpm -q unzip"
```

Manually install unzip if missing (e.g., on stapp03):
```
ssh banner@stapp03
sudo yum install unzip -y
exit

```
Check zip file on jump host:
```
ls -l /usr/src/sysops/devops.zip
```



