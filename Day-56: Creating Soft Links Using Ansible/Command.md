#!/bin/bash
# Ansible Syntax Check Commands

# Navigate to the ansible directory
```
cd /home/thor/ansible
```
# 1. Check playbook syntax
echo "=== Checking Playbook Syntax ==="
```
ansible-playbook -i inventory playbook.yml --syntax-check
```
# 2. Dry run (check mode) - shows what would change without making changes
echo -e "\n=== Dry Run (Check Mode) ==="
```
ansible-playbook -i inventory playbook.yml --check
```
# 3. List hosts that will be affected
echo -e "\n=== Listing Target Hosts ==="
```
ansible-playbook -i inventory playbook.yml --list-hosts
```
# 4. List all tasks that will be executed
echo -e "\n=== Listing All Tasks ==="
```
ansible-playbook -i inventory playbook.yml --list-tasks
```
# 5. Verify inventory file
echo -e "\n=== Verifying Inventory ==="
```
ansible-inventory -i inventory --list
```
# 6. Test connectivity to all hosts
echo -e "\n=== Testing Connectivity ==="
```
ansible -i inventory all -m ping
```
# 7. Run playbook with verbose output (for debugging)
echo -e "\n=== Running with Verbose Output ==="
```
ansible-playbook -i inventory playbook.yml -v
```

# For more verbosity, use -vv, -vvv, or -vvvv
# ansible-playbook -i inventory playbook.yml -vvv
