---
- name: Setup Apache and PHP on App Server 1
  hosts: stapp01
  become: yes
  tasks:
    - name: Install httpd and php packages
      yum:
        name:
          - httpd
          - php
        state: present

    - name: Create custom document root directory
      file:
        path: /var/www/html/myroot
        state: directory
        mode: '0755'

    - name: Change Apache document root in httpd.conf
      lineinfile:
        path: /etc/httpd/conf/httpd.conf
        regexp: '^DocumentRoot'
        line: 'DocumentRoot "/var/www/html/myroot"'
        backup: yes

    - name: Update Directory directive for new document root
      replace:
        path: /etc/httpd/conf/httpd.conf
        regexp: '<Directory "/var/www/html">'
        replace: '<Directory "/var/www/html/myroot">'
        backup: yes

    - name: Copy phpinfo.php template to document root
      template:
        src: ~/playbooks/templates/phpinfo.php.j2
        dest: /var/www/html/myroot/phpinfo.php
        owner: apache
        group: apache
        mode: '0644'

    - name: Start and enable httpd service
      systemd:
        name: httpd
        state: started
        enabled: yes
