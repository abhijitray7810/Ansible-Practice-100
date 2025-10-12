# Ansible ACL File Management Playbook

## Overview
This playbook automates the creation of files with specific ACL (Access Control List) permissions across multiple app servers in the Stratos Data Center. All files are owned by root, with additional ACL permissions granted to specific users and groups.

## Directory Structure
```
/home/thor/ansible/
├── inventory           # Existing inventory file
├── playbook.yml        # Main playbook (to be created)
└── README.md          # This documentation
```

## Requirements
- Ansible installed on the jump host
- SSH access to all app servers (stapp01, stapp02, stapp03)
- Sudo/root privileges on target servers
- ACL support enabled on target filesystems
- Python acl library on target servers (usually pre-installed)

## Playbook Tasks

### App Server 1 (stapp01)
- **File**: `/opt/itadmin/blog.txt`
- **Owner**: root:root
- **ACL**: Group `tony` with read (`r`) permissions

### App Server 2 (stapp02)
- **File**: `/opt/itadmin/story.txt`
- **Owner**: root:root
- **ACL**: User `steve` with read+write (`rw`) permissions

### App Server 3 (stapp03)
- **File**: `/opt/itadmin/media.txt`
- **Owner**: root:root
- **ACL**: Group `banner` with read+write (`rw`) permissions

## Installation

1. Navigate to the ansible directory:
```bash
cd /home/thor/ansible
```

2. Create the playbook file:
```bash
# Copy the playbook content to playbook.yml
vi playbook.yml
```

## Execution

### Run the Playbook
```bash
ansible-playbook -i inventory playbook.yml
```

### Check Syntax
```bash
ansible-playbook --syntax-check -i inventory playbook.yml
```

### Dry Run (Check Mode)
```bash
ansible-playbook -i inventory playbook.yml --check
```

### Verbose Output
```bash
ansible-playbook -i inventory playbook.yml -v
# Or for more verbosity: -vv, -vvv, -vvvv
```

## Verification

After running the playbook, verify the ACL permissions:

### On App Server 1
```bash
ssh stapp01
getfacl /opt/itadmin/blog.txt
ls -l /opt/itadmin/blog.txt
```

Expected output should show:
- Owner: root
- Group tony with read permissions

### On App Server 2
```bash
ssh stapp02
getfacl /opt/itadmin/story.txt
ls -l /opt/itadmin/story.txt
```

Expected output should show:
- Owner: root
- User steve with read+write permissions

### On App Server 3
```bash
ssh stapp03
getfacl /opt/itadmin/media.txt
ls -l /opt/itadmin/media.txt
```

Expected output should show:
- Owner: root
- Group banner with read+write permissions

## Playbook Structure

The playbook consists of three separate plays:
1. **Play 1**: Targets stapp01 for blog.txt creation
2. **Play 2**: Targets stapp02 for story.txt creation
3. **Play 3**: Targets stapp03 for media.txt creation

Each play includes:
- Directory creation task (ensures `/opt/itadmin` exists)
- File creation task (creates empty file with root ownership)
- ACL configuration task (sets specific ACL permissions)

## Troubleshooting

### Common Issues

**Issue**: ACL module not found
```
Solution: Ensure acl package is installed on target servers
# On RHEL/CentOS: yum install acl
# On Debian/Ubuntu: apt-get install acl
```

**Issue**: Permission denied
```
Solution: Ensure SSH keys are properly configured and user has sudo access
Check: ansible all -i inventory -m ping
```

**Issue**: Directory already exists with different permissions
```
Solution: The playbook handles this by ensuring directory state
The existing directory will be updated if needed
```

**Issue**: File already exists
```
Solution: The 'touch' state is idempotent
It will update timestamp if file exists, create if not
```

## ACL Permissions Guide

| Permission | Symbol | Description |
|------------|--------|-------------|
| Read       | r      | Can read file contents |
| Write      | w      | Can modify file contents |
| Execute    | x      | Can execute file (not used here) |

## Notes

- All files are created as empty files
- Files are owned by root:root by default
- ACL permissions are in addition to standard UNIX permissions
- The playbook is idempotent (safe to run multiple times)
- No extra arguments are required for execution

## Author
Nautilus DevOps Team - Stratos DC

## Last Updated
October 2025
