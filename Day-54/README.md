Ansible Automation for Extracting devops.zip
Overview
This Ansible playbook automates the task of extracting /usr/src/sysops/devops.zip on all app servers in Stratos DC, setting the correct ownership and permissions for the extracted data.
Requirements

Jump Host: CentOS-based, with Ansible installed.
Inventory File: Defines app servers (stapp01, stapp02, stapp03) with respective users (tony, steve, banner) and passwords.
Zip File: /usr/src/sysops/devops.zip exists on the jump host.
Playbook: playbook.yml extracts the zip file to /opt/sysops/, sets ownership to the respective sudo user, and applies 0755 permissions.

Files

inventory: Lists app servers with connection details.
playbook.yml: Ansible playbook to perform the task.
command.md: Commands to run and verify the playbook.
steps.md: Step-by-step setup instructions.
readme.md: This file, providing an overview.

Usage
Run the playbook from the jump host:
```
cd /home/thor/ansible
ansible-playbook -i inventory playbook.yml
```
Verification
Check the extracted files and permissions:
```
ansible -i inventory all -m shell -a "ls -l /opt/sysops/unarchive"
ansible -i inventory all -m shell -a "ls -ld /opt/sysops/unarchive"
```
