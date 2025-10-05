Commands to Execute the Playbook
Below are the commands to verify and run the Ansible playbook for extracting devops.zip on app servers:

Navigate to the Ansible directory:
```
cd /home/thor/ansible
```

Check playbook syntax:
```
ansible-playbook -i inventory playbook.yml --syntax-check
```

Run the playbook:
```
ansible-playbook -i inventory playbook.yml
```

Verify connectivity to app servers:
```
ansible -i inventory all -m ping
```

Verify extracted files:
```
ansible -i inventory all -m shell -a "ls -l /opt/sysops/unarchive"
```

Verify directory permissions and ownership:
```
ansible -i inventory all -m shell -a "ls -ld /opt/sysops/unarchive"
```

