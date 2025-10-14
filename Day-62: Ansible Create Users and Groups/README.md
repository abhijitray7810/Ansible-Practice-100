# User Management Automation - Nautilus Project

## Overview
This Ansible playbook automates user and group management for new developers and DevOps engineers joining the xFusionCorp industries Nautilus project. It creates user accounts, groups, and configures permissions on app server 2 in Stratos DC.

## Project Structure
```
~/playbooks/
├── README.md              # This file
├── ansible.cfg            # Ansible configuration with vault settings
├── add_users.yml          # Main playbook for user management
├── inventory              # Inventory file with server details
├── data/
│   └── users.yml          # User lists for admins and developers
└── secrets/
    └── vault.txt          # Vault password file for encryption
```

## Prerequisites
- Ansible installed on jump host
- SSH access to app server 2 (stapp02) configured
- Vault password file created at `~/playbooks/secrets/vault.txt`
- User data file exists at `~/playbooks/data/users.yml`

## Configuration Files

### ansible.cfg
```ini
[defaults]
vault_password_file = secrets/vault.txt
host_key_checking = False
inventory = inventory
```

### data/users.yml (Example Format)
```yaml
admins:
  - rob
  - david
  - joy

developers:
  - tim
  - ray
  - jim
  - mark
```

## Features

### Group Management
- **admins**: Group for administrative users
- **developers**: Group for development team members

### Admin Users Configuration
| Setting | Value |
|---------|-------|
| Home Directory | Default (`/home/{username}`) |
| Password | `LQfKeWWxWD` (SHA512 encrypted) |
| Groups | `admins`, `wheel` |
| Sudo Access | Yes (via wheel group) |

### Developer Users Configuration
| Setting | Value |
|---------|-------|
| Home Directory | Shared `/var/www` |
| Password | `TmPcZjtRQx` (SHA512 encrypted) |
| Groups | `developers` |
| Sudo Access | No |

## Usage

### Running the Playbook
Execute from the playbooks directory:
```bash
cd ~/playbooks
ansible-playbook -i inventory add_users.yml
```

### Expected Output
```
PLAY [Add users and groups to app server 2] ************************************
TASK [Gathering Facts] *********************************************************
ok: [stapp02]
TASK [Create admins group] *****************************************************
changed: [stapp02]
TASK [Create developers group] *************************************************
changed: [stapp02]
TASK [Create admin users] ******************************************************
changed: [stapp02] => (item=rob)
changed: [stapp02] => (item=david)
changed: [stapp02] => (item=joy)
TASK [Create developer users with custom home directory] ***********************
changed: [stapp02] => (item=tim)
changed: [stapp02] => (item=ray)
changed: [stapp02] => (item=jim)
changed: [stapp02] => (item=mark)
PLAY RECAP *********************************************************************
stapp02                    : ok=5    changed=4    unreachable=0    failed=0
```

## Verification

### Check Groups
```bash
ssh stapp02
getent group admins
getent group developers
```

### Check User Details
```bash
# Check user info
id rob
id tim

# Verify home directories
grep rob /etc/passwd
grep tim /etc/passwd

# Check sudo access for admin users
sudo -l -U rob
```

### Verify Group Membership
```bash
# Admin users should be in: admins, wheel
groups rob

# Developer users should be in: developers
groups tim
```

## Playbook Tasks Breakdown

1. **Create admins group** - Creates the admins group on target server
2. **Create developers group** - Creates the developers group on target server
3. **Create admin users** - Adds admin users with:
   - Default home directories
   - wheel group membership (sudo access)
   - Encrypted passwords
4. **Create developer users** - Adds developer users with:
   - Shared `/var/www` home directory
   - developers group membership
   - Encrypted passwords

## Security Features

- **Password Encryption**: All passwords are hashed using SHA512 algorithm
- **Vault Integration**: Ansible vault password file configured for sensitive data
- **Sudo Control**: Only admin users have sudo access via wheel group
- **Group-based Access**: Users organized by functional groups

## Troubleshooting

### Common Issues

**Issue**: "Permission denied" error
```bash
# Solution: Ensure you have SSH access to stapp02
ssh stapp02
```

**Issue**: "Vault password not found"
```bash
# Solution: Verify vault.txt exists
ls -la ~/playbooks/secrets/vault.txt
```

**Issue**: "Host unreachable"
```bash
# Solution: Check inventory file and network connectivity
ansible -i inventory stapp02 -m ping
```

### Deprecation Warning
If you see a warning about Python crypt module:
```
[DEPRECATION WARNING]: Encryption using the Python crypt module is deprecated.
```
This is informational only. To suppress:
- Install passlib: `pip install passlib`
- Or add to ansible.cfg: `deprecation_warnings=False`

## Maintenance

### Adding New Users
1. Edit `~/playbooks/data/users.yml`
2. Add usernames to appropriate group (admins or developers)
3. Run the playbook again

### Modifying Passwords
1. Update password values in `add_users.yml`
2. Ensure passwords are properly encrypted with `password_hash` filter
3. Re-run the playbook

### Removing Users
Create a separate playbook or use the `user` module with `state: absent`

## Best Practices

✅ Always test in a non-production environment first  
✅ Keep vault password file secure and backed up  
✅ Document any changes to user lists in version control  
✅ Regularly audit user accounts and permissions  
✅ Use strong passwords and rotate them periodically  
✅ Review sudo access logs for admin users  

## Author
xFusionCorp Industries - DevOps Team

## Version History
- **v1.0** - Initial release with user and group management for Nautilus project

## Support
For issues or questions, contact the DevOps team or refer to the Ansible documentation:
- [Ansible User Module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/user_module.html)
- [Ansible Group Module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/group_module.html)

## License
Internal use only - xFusionCorp Industries
