# Solution
  # Step 1: Create the inventory file
        - Create the inventory file at /home/thor/playbook/inventory with the following content:
             ```bash
                [appservers]
                 stapp01 ansible_host=172.16.238.10 ansible_user=tony
                 stapp02 ansible_host=172.16.238.11 ansible_user=steve
                 stapp03 ansible_host=172.16.238.12 ansible_user=banner
              ```
   # Step 2: Create the Ansible playbook
         - Create the playbook file at /home/thor/playbook/playbook.yml with the following content:
    
