# Nautilus Application Development - Ansible Package Installation

## Overview
This repository contains Ansible configuration to install the `vim-enhanced` package on all application servers in the Stratos Datacenter for the Nautilus Application development team.

## Prerequisites
- Ansible installed on jump host
- SSH access to all app servers from jump host
- User `thor` should have sudo privileges on jump host
- Proper SSH key configuration for app server access

## File Structure
```
/home/thor/playbook/
├── inventory
└── playbook.yml
```

## Inventory Configuration

### File: `/home/thor/playbook/inventory`
```ini
[appservers]
stapp01 ansible_host=172.16.238.10 ansible_user=tony
stapp02 ansible_host=172.16.238.11 ansible_user=steve
stapp03 ansible_host=172.16.238.12 ansible_user=banner
```

**Server Details:**
- **stapp01**: 172.16.238.10 (user: tony)
- **stapp02**: 172.16.238.11 (user: steve)
- **stapp03**: 172.16.238.12 (user: banner)

## Playbook Configuration

### File: `/home/thor/playbook/playbook.yml`
```yaml
---
- name: Install vim-enhanced package on all app servers
  hosts: appservers
  become: yes
  tasks:
    - name: Install vim-enhanced package
      yum:
        name: vim-enhanced
        state: present
```

## Usage Instructions

### 1. Navigate to the playbook directory
```bash
cd /home/thor/playbook
```

### 2. Test inventory connectivity
```bash
ansible-inventory -i inventory --list
```

### 3. Run the playbook
```bash
ansible-playbook -i inventory playbook.yml
```

## Playbook Details

- **Target**: All servers in the `appservers` group
- **Package**: `vim-enhanced` (enhanced version of VIM editor)
- **Module**: `yum` (Yellowdog Updater Modified)
- **State**: `present` (ensures package is installed)
- **Privilege**: Uses `become: yes` for sudo access

## Validation

The playbook will:
1. Connect to each app server using the specified user accounts
2. Check if `vim-enhanced` is already installed
3. Install the package if not present
4. Provide success/failure status for each server

## Expected Output

Upon successful execution, you should see:
```
PLAY [Install vim-enhanced package on all app servers] *************************

TASK [Gathering Facts] *********************************************************
ok: [stapp01]
ok: [stapp02]
ok: [stapp03]

TASK [Install vim-enhanced package] ********************************************
changed: [stapp01]
changed: [stapp02]
changed: [stapp03]

PLAY RECAP *********************************************************************
stapp01                    : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
stapp02                    : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
stapp03                    : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

## Troubleshooting

### Common Issues:
1. **SSH Connection Failed**: Ensure SSH keys are properly configured for each user
2. **Permission Denied**: Verify sudo privileges are configured on target servers
3. **Package Not Found**: Ensure yum repositories are properly configured on app servers

### Debug Mode:
Run with verbose output for troubleshooting:
```bash
ansible-playbook -i inventory playbook.yml -vvv
```

## Security Notes
- Uses individual user accounts (tony, steve, banner) for each server
- Employs privilege escalation (`become: yes`) for package installation
- No passwords are hardcoded in the configuration files

## Maintenance
- Regularly update the inventory file if server IPs change
- Monitor playbook execution logs for any failures
- Keep Ansible version updated on jump host
```
