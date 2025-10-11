# Ansible File Module Practice — Create Symbolic Links and Files

This playbook demonstrates the use of the Ansible **file module** to:
- Create directories and files with specific ownership.
- Create symbolic links between directories.

### 📁 Files
- **inventory** – Contains app server details.
- **playbook.yml** – Automates file creation and symlink tasks.

### 🧩 Tasks Overview
| Server  | File Created         | Owner  | Symlink Created                         |
|----------|----------------------|--------|------------------------------------------|
| stapp01 | /opt/dba/blog.txt    | tony   | /var/www/html → /opt/dba                |
| stapp02 | /opt/dba/story.txt   | steve  | /var/www/html → /opt/dba                |
| stapp03 | /opt/dba/media.txt   | banner | /var/www/html → /opt/dba                |

### ▶️ Run Command
```bash
ansible-playbook -i inventory playbook.yml
```
