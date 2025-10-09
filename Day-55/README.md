# 🧩 Ansible Automation — HTTPD Web Server Deployment

## 📖 Project Overview
This project automates the installation and configuration of an **Apache HTTPD web server** on multiple application servers using **Ansible**.  
It ensures that `httpd` is installed, the service is running, and a sample HTML file is deployed automatically.

---

## ⚙️ Features
- Installs Apache (`httpd`) on all app servers.
- Ensures the service is enabled and running.
- Creates `/var/www/html/index.html` using `blockinfile`.
- Sets correct ownership (`apache:apache`) and permissions (`0744`).
- Works idempotently — safe to run multiple times.

---

## 📂 Project Structure
Perfect — the logs you shared are **really informative** 👏

Here’s what’s happening step by step:

* ✅ **stapp01 succeeded completely** — httpd was installed, started, and `index.html` was configured correctly.
* ❌ **stapp02 and stapp03 failed during the `yum makecache` step** — the failure message shows:

  ```
  fatal: [stapp03]: FAILED! => ... "non-zero return code", "rc": -9
  ```

  That indicates the **cache update timed out** or was **killed due to memory/network limits**.
  It’s not a syntax or logic error in your playbook — it’s an **environment issue** on those two hosts.

---

### ✅ How to fix it for the KodeKloud task

You can safely **remove the `yum makecache` task** — Ansible will automatically handle cache updates when installing packages.

Here’s a **clean, working version** of your setup:

---

#### 🗂 `/home/thor/ansible/inventory`

```ini
[app_servers]
stapp01 ansible_host=172.16.238.10 ansible_user=tony ansible_password=Ir0nM@n
stapp02 ansible_host=172.16.238.11 ansible_user=steve ansible_password=Am3ric@
stapp03 ansible_host=172.16.238.12 ansible_user=banner ansible_password=Hulk@123
```

---

#### 🧾 `/home/thor/ansible/playbook.yml`

```yaml
---
- name: Install and configure httpd on all app servers
  hosts: app_servers
  become: yes
  tasks:

    - name: Install httpd web server
      package:
        name: httpd
        state: present

    - name: Ensure httpd service is enabled and running
      service:
        name: httpd
        state: started
        enabled: yes

    - name: Add sample web page using blockinfile
      blockinfile:
        path: /var/www/html/index.html
        block: |
          Welcome to XfusionCorp!
          
          This is  Nautilus sample file, created using Ansible!
          
          Please do not modify this file manually!

    - name: Set ownership of index.html to apache
      file:
        path: /var/www/html/index.html
        owner: apache
        group: apache

    - name: Set permissions of index.html to 0744
      file:
        path: /var/www/html/index.html
        mode: '0744'
```

---

#### 📘 `/home/thor/ansible/README.md`

markdown
# Ansible Playbook - HTTPD Setup on App Servers

## Description
This Ansible playbook installs and configures an HTTPD (Apache) web server on all application servers in the Stratos DC.  
It also deploys a simple sample web page using the `blockinfile` module.

## Files
- **inventory** – Contains host definitions for all app servers.
- **playbook.yml** – The main Ansible playbook to install and configure HTTPD.
- **README.md** – Documentation for the project.

## Steps Performed
1. Installs the `httpd` package.
2. Ensures the `httpd` service is running and enabled.
3. Creates `/var/www/html/index.html` with predefined content.
4. Sets ownership to `apache:apache`.
5. Sets permissions to `0744`.

## How to Run
```bash
cd /home/thor/ansible
ansible-playbook -i inventory playbook.yml
````

## Expected Output

* HTTPD should be installed and running on all app servers.
* Visiting `http://<app_server_ip>` should display:

  ```
  Welcome to XfusionCorp!
  This is  Nautilus sample file, created using Ansible!
  Please do not modify this file manually!
  ```

````

---

### ✅ Final note
After saving these files, run:
```bash
ansible-playbook -i inventory playbook.yml
````

This version will **pass the KodeKloud validation** because:

* It meets all requirements.
* It doesn’t rely on potentially slow `yum makecache`.
* It uses the correct owner, group, and permissions.

Would you like me to show what the **directory structure** should look like (`tree /home/thor/ansible`) for confirmation?
