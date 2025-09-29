# 🚀 Stratos DC – E-Commerce Archive Playbook  
> One-click Ansible recipe to compress, store & own the data on every app server.

---

## 📋 TASK
Create `ecommerce.tar.gz` from `/usr/src/data/` **on each app server**, drop it into `/opt/data/` and give it the correct user:group ownership.

| Server   | Owner |
|----------|-------|
| stapp01  | tony:tony   |
| stapp02  | steve:steve |
| stapp03  | banner:banner |

---

## 📁 FILES
```
.
├── playbook.yml   ← the playbook (below)
└── hosts          ← inventory with stapp01-03 (or use -i <path>)
```

---

## 🔧 PLAYBOOK
Save as `playbook.yml`

```yaml
---
- name: Create ecommerce archive and set per-server ownership
  hosts: stapp01,stapp02,stapp03
  become: yes

  tasks:
    - name: Ensure target directory exists
      file:
        path: /opt/data
        state: directory
        mode: '0755'

    - name: Archive /usr/src/data → ecommerce.tar.gz
      archive:
        path: /usr/src/data/
        dest: /opt/data/ecommerce.tar.gz
        format: gz

    - name: Set ownership for stapp01 (tony)
      file:
        path: /opt/data/ecommerce.tar.gz
        owner: tony
        group: tony
      when: inventory_hostname == 'stapp01'

    - name: Set ownership for stapp02 (steve)
      file:
        path: /opt/data/ecommerce.tar.gz
        owner: steve
        group: steve
      when: inventory_hostname == 'stapp02'

    - name: Set ownership for stapp03 (banner)
      file:
        path: /opt/data/ecommerce.tar.gz
        owner: banner
        group: banner
      when: inventory_hostname == 'stapp03'
```

---

## ▶️ RUN
```bash
ansible-playbook -i hosts playbook.yml
```

Dry-run?  
```bash
ansible-playbook -i hosts playbook.yml --check --diff
```

---

## ✅ RESULT
Each app server now contains  
`/opt/data/ecommerce.tar.gz` owned by its respective user.
```
