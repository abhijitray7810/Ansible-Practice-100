# Apache Web Server Setup with Ansible

## Overview
This Ansible playbook automates the deployment of Apache web servers across all app servers in Stratos DC. It creates a custom HTML page displaying system architecture information gathered from Ansible facts.

## Prerequisites
- Ansible installed on the jump host (Ansible controller)
- Valid inventory file at `/home/thor/playbooks/inventory`
- SSH access to all app servers (stapp01, stapp02, stapp03)
- Sudo privileges on target servers

## Project Structure
```
/home/thor/playbooks/
├── inventory        # Ansible inventory file
├── index.yml        # Main playbook
└── README.md        # This documentation
```

## Playbook Details

### File: `index.yml`

The playbook performs the following tasks:

1. **Facts Gathering**: Collects system information from all target hosts
2. **Create facts.txt**: Uses `blockinfile` module to create `/root/facts.txt` with architecture information
3. **Install Apache**: Installs the `httpd` package with retry logic
4. **Deploy HTML**: Copies `facts.txt` to `/var/www/html/index.html`
5. **Start Service**: Starts and enables the httpd service

### Key Features
- **Fact-based content**: Dynamically inserts the system architecture using `{{ ansible_architecture }}`
- **Retry mechanism**: Automatically retries httpd installation up to 3 times if it fails
- **Idempotent**: Safe to run multiple times without unwanted side effects

## Usage

### Run on All App Servers
```bash
cd /home/thor/playbooks
ansible-playbook -i inventory index.yml
```

### Run on Specific Host
```bash
ansible-playbook -i inventory index.yml --limit stapp01
```

### Run on Multiple Specific Hosts
```bash
ansible-playbook -i inventory index.yml --limit stapp01,stapp02
```

### Dry Run (Check Mode)
```bash
ansible-playbook -i inventory index.yml --check
```

### Verbose Output
```bash
ansible-playbook -i inventory index.yml -v    # verbose
ansible-playbook -i inventory index.yml -vv   # more verbose
ansible-playbook -i inventory index.yml -vvv  # very verbose
```

## Verification

### Check if httpd is running
```bash
ansible all -i inventory -m shell -a "systemctl status httpd" -b
```

### View the generated HTML content
```bash
ansible all -i inventory -m shell -a "cat /var/www/html/index.html" -b
```

### Test web server response
```bash
ansible all -i inventory -m shell -a "curl http://localhost"
```

### Check facts.txt file
```bash
ansible all -i inventory -m shell -a "cat /root/facts.txt" -b
```

## Troubleshooting

### Issue: Module Failure (rc=137)
**Symptom**: Task fails with "MODULE FAILURE" and return code 137

**Cause**: Process killed, usually due to memory constraints

**Solution**: 
- Run the playbook again (transient issue)
- Run only for failed host: `ansible-playbook -i inventory index.yml --limit <failed_host>`
- The playbook includes automatic retry logic

### Issue: httpd service fails to start
**Check service status**:
```bash
ansible all -i inventory -m shell -a "systemctl status httpd" -b
```

**Check httpd configuration**:
```bash
ansible all -i inventory -m shell -a "httpd -t" -b
```

### Issue: Permission denied
**Ensure sudo privileges**:
```bash
ansible-playbook -i inventory index.yml --ask-become-pass
```

### Issue: Connection timeout
**Test connectivity**:
```bash
ansible all -i inventory -m ping
```

## Expected Output

After successful execution, each app server will have:
- `/root/facts.txt` with architecture information
- Apache httpd installed and running
- `/var/www/html/index.html` serving the architecture information

**Example content**:
```
# BEGIN ANSIBLE MANAGED BLOCK
Ansible managed node architecture is x86_64
# END ANSIBLE MANAGED BLOCK
```

## Playbook Execution Summary

A successful run will show:
```
PLAY RECAP
stapp01  : ok=5  changed=4  unreachable=0  failed=0
stapp02  : ok=5  changed=4  unreachable=0  failed=0
stapp03  : ok=5  changed=4  unreachable=0  failed=0
```

## Notes

- The playbook uses `gather_facts: yes` to collect system information
- The `blockinfile` module adds managed block markers to the file
- The `remote_src: yes` parameter is used in the copy task since we're copying files on the remote host itself
- The httpd service is configured to start automatically on system boot

## Maintenance

### Updating the Content
To modify the content displayed on the web page, edit the `block` section in the playbook and re-run it.

### Adding More Hosts
Add new hosts to the inventory file and run the playbook again.

### Removing the Setup
```bash
ansible all -i inventory -m service -a "name=httpd state=stopped" -b
ansible all -i inventory -m package -a "name=httpd state=absent" -b
ansible all -i inventory -m file -a "path=/root/facts.txt state=absent" -b
ansible all -i inventory -m file -a "path=/var/www/html/index.html state=absent" -b
```

## Author
Nautilus DevOps Team

## Version
1.0.0
