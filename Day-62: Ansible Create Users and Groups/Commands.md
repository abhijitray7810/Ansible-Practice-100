# Ansible User Management Commands - Nautilus Project

## Complete Command History for User Account Setup

### 1. Initial Setup
```bash
# Navigate to playbooks directory
cd /home/thor/playbooks

# List available files and directories
ls -la
```

### 2. Create the Ansible Playbook
```bash
# Create the add_users.yml playbook
cat > add_users.yml << 'EOF'
---
- name: Add users and groups to app server 2
  hosts: stapp02
  become: yes
  vars_files:
    - data/users.yml
  
  tasks:
    - name: Create admins group
      group:
        name: admins
        state: present

    - name: Create developers group
      group:
        name: developers
        state: present

    - name: Create admin users
      user:
        name: "{{ item }}"
        groups: admins,wheel
        append: yes
        password: "{{ 'LQfKeWWxWD' | password_hash('sha512') }}"
        state: present
      loop: "{{ admins }}"

    - name: Create developer users with custom home directory
      user:
        name: "{{ item }}"
        groups: developers
        append: yes
        home: /var/www
        password: "{{ 'TmPcZjtRQx' | password_hash('sha512') }}"
        state: present
      loop: "{{ developers }}"
EOF
```

### 3. Fix Ansible Configuration
```bash
# Fix duplicate [defaults] section in ansible.cfg
cat > ansible.cfg << 'EOF'
[defaults]
host_key_checking = False
vault_password_file = secrets/vault.txt
EOF
```

### 4. Execute the Playbook
```bash
# Run the playbook to create users and groups
ansible-playbook -i inventory add_users.yml
```

### 5. Verification Commands
```bash
# SSH to app server 2 for verification
ssh steve@stapp02

# Check user accounts created
grep -E 'rob|david|joy|tim|ray|jim|mark' /etc/passwd

# Check group memberships
grep admins /etc/group
grep developers /etc/group

# Verify sudo access (wheel group membership)
id rob
id joy

# Check home directory assignments
# Admins: /home/{username}
# Developers: /var/www
```

## Summary of Configuration

### Groups Created:
- **admins**: rob, david, joy (with sudo access via wheel group)
- **developers**: tim, ray, jim, mark

### Passwords Set:
- **Admins**: LQfKeWWxWD
- **Developers**: TmPcZjtRQx

### Home Directories:
- **Admins**: Default (/home/{username})
- **Developers**: Custom (/var/www)

### Key Files:
- Playbook: `/home/thor/playbooks/add_users.yml`
- User data: `/home/thor/playbooks/data/users.yml`
- Vault password: `/home/thor/playbooks/secrets/vault.txt`
- Inventory: `/home/thor/playbooks/inventory`
- Configuration: `/home/thor/playbooks/ansible.cfg`

All tasks completed successfully for the Nautilus project onboarding process.
