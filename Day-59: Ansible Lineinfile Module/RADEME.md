
# Ansible Httpd Web Server Setup

## Overview
This Ansible playbook automates the installation and configuration of the Apache httpd web server across all app servers in the Stratos Datacenter. It also deploys a sample web page with specific content and permissions.

## Prerequisites
- Ansible installed on the jump host
- SSH access to all app servers (stapp01, stapp02, stapp03)
- Inventory file configured with server details
- Sudo/root privileges on target servers

## Directory Structure
```
/home/thor/ansible/
├── inventory          # Inventory file with app server details
├── playbook.yml       # Main playbook for httpd setup
└── README.md          # This documentation file
```

## Inventory Configuration
The inventory file contains three app servers:
- **stapp01**: 172.16.238.10 (user: tony)
- **stapp02**: 172.16.238.11 (user: steve)
- **stapp03**: 172.16.238.12 (user: banner)

## Playbook Tasks

### 1. Install httpd Package
Installs the Apache httpd web server on all app servers using the package module.

### 2. Start and Enable httpd Service
Ensures the httpd service is:
- Started and running
- Enabled to start automatically on system boot

### 3. Create index.html File
Creates `/var/www/html/index.html` with the initial content:
```
This is a Nautilus sample file, created using Ansible!
```

### 4. Add Welcome Line
Uses the `lineinfile` module to add the following line at the top of the file:
```
Welcome to xFusionCorp Industries!
```

### 5. Set File Ownership and Permissions
Ensures the index.html file has:
- **Owner**: apache
- **Group**: apache
- **Permissions**: 0644

## Usage

### Run the Playbook
Execute the playbook from the `/home/thor/ansible` directory:

```bash
ansible-playbook -i inventory playbook.yml
```

### Run for Specific Host
If you need to target a specific server:

```bash
ansible-playbook -i inventory playbook.yml --limit stapp01
```

### Dry Run (Check Mode)
To see what changes would be made without applying them:

```bash
ansible-playbook -i inventory playbook.yml --check
```

### Verbose Output
For detailed execution information:

```bash
ansible-playbook -i inventory playbook.yml -v
```

For more verbosity, use `-vv`, `-vvv`, or `-vvvv`.

## Verification

### Check Playbook Syntax
```bash
ansible-playbook -i inventory playbook.yml --syntax-check
```

### Test Connectivity
```bash
ansible -i inventory all -m ping
```

### Verify httpd Service
After running the playbook, verify the service on each server:

```bash
ansible -i inventory all -m shell -a "systemctl status httpd" --become
```

### Check Web Page Content
```bash
ansible -i inventory all -m shell -a "cat /var/www/html/index.html" --become
```

### Verify File Permissions
```bash
ansible -i inventory all -m shell -a "ls -l /var/www/html/index.html" --become
```

### Test Web Server Response
```bash
ansible -i inventory all -m shell -a "curl -s http://localhost" --become
```

## Expected Output

The final `/var/www/html/index.html` file should contain:
```
Welcome to xFusionCorp Industries!
This is a Nautilus sample file, created using Ansible!
```

## Troubleshooting

### Connection Issues
If you encounter SSH connection problems:
```bash
ansible -i inventory stapp01 -m ping
```

### Permission Denied
Ensure the sudo password is configured or the user has passwordless sudo access.

### Module Failure (rc: 137)
This error typically indicates memory issues or SSH connection problems. Try:
- Running the playbook again
- Using `serial: 1` to process one host at a time
- Checking available memory on target servers

### Service Not Starting
Check httpd service logs:
```bash
ansible -i inventory all -m shell -a "journalctl -u httpd -n 50" --become
```

### Port Already in Use
If port 80 is already occupied:
```bash
ansible -i inventory all -m shell -a "netstat -tlnp | grep :80" --become
```

## Playbook Features

- **Idempotent**: Can be run multiple times safely
- **Serial Execution**: Processes one host at a time to avoid resource issues
- **Privilege Escalation**: Uses `become: yes` for root privileges
- **Error Handling**: Built-in Ansible error reporting

## File Permissions Breakdown

| Permission | Owner | Group | Others |
|------------|-------|-------|--------|
| 0644       | rw-   | r--   | r--    |

- Owner (apache): Read and Write
- Group (apache): Read only
- Others: Read only

## Additional Resources

- [Ansible Documentation](https://docs.ansible.com/)
- [Apache httpd Documentation](https://httpd.apache.org/docs/)
- [Ansible Lineinfile Module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/lineinfile_module.html)

## Support

For issues or questions regarding this playbook, contact the Nautilus DevOps team.

---
**Last Updated**: October 2025  
**Maintained By**: Nautilus DevOps Team  
**Environment**: Stratos Datacenter
