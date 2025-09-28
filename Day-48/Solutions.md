1 Set up password-less SSH from thor user on jump host to App server 3 (stapp03)through the banner user
2 Configure the inventory file at /home/thor/absible/inventory
3 Test Ansible ping to App Server 3


# Step 1: Generate SSH Key Pair for thor user (if not already exists)Let me proceed with the implementation. Based on my research, I'll now complete the task step by step.
- Generate SSH key pair for thor user
  ```bash
   ssh-keygen -t rsa -b 4096 -C "thor@jump-host"
  ```
   Generate SSH key pair (if not already exists)

   - Press Enter to accept Default location
     (/home/thor/.ssh/id_rsa)

#  Step 2: Set up Password-less SSH to App Server 3
- Based on the research, App Server 3 (stapp03) details are:
- Hostname: stapp03
- IP Address: 172.16.238.12
- SSH User: banner
- Password: BigGr33n
```bash
ssh-copy-id banner@stapp03
```
# Step 3: Verify Password-less SSH Connection
```bash
ssh banner@stapp03
exit
```
# Step 4: Configure Ansible Inventory File
```bash
cat > /home/thor/ansible/inventory << 'EOF'
stapp01 ansible_host=172.16.238.10 ansible_ssh_pass=Ir0nM@n
stapp02 ansible_host=172.16.238.11 ansible_ssh_pass=Am3ric@
stapp03 ansible_host=172.16.238.12 ansible_user=banner
EOF
```
# Step 5: Test Ansible Ping
```text
stapp03 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/libexec/platform-python"
    },
    "changed": false,
    "ping": "pong"
}
```


