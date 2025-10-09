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
