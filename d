[1mdiff --git a/group_vars/HWSRV004.yml b/group_vars/HWSRV004.yml[m
[1mindex 21dda4c..d982444 100644[m
[1m--- a/group_vars/HWSRV004.yml[m
[1m+++ b/group_vars/HWSRV004.yml[m
[36m@@ -1,3 +1,2 @@[m
 ---[m
 conf_src: zabbix_agent2HWSRV004.conf[m
[31m-conf_dest: /etc/zabbix/zabbix_agent2.conf[m
[1mdiff --git a/mysteps/debian.yml b/mysteps/debian.yml[m
[1mdeleted file mode 100644[m
[1mindex c6e3d32..0000000[m
[1m--- a/mysteps/debian.yml[m
[1m+++ /dev/null[m
[36m@@ -1,57 +0,0 @@[m
[31m----[m
[31m-- name: Load os version on vars[m
[31m-  include_vars: "debian{{ ansible_distribution_major_version }}.yml"[m
[31m-[m
[31m-- name: Download repo[m
[31m-  get_url:[m
[31m-      url: "{{ zabbix_repo_url }}"[m
[31m-      dest: /tmp/zabbix-release.deb[m
[31m-[m
[31m-- name: Ensure basic packages are installed[m
[31m-  become: yes[m
[31m-  apt:[m
[31m-    name:[m
[31m-      - apt-utils[m
[31m-      - dpkg[m
[31m-    state: present[m
[31m-    update_cache: yes[m
[31m-[m
[31m-- name: Install repo[m
[31m-  apt:[m
[31m-    deb: /tmp/zabbix-release.deb[m
[31m-  become: yes[m
[31m-  environment:[m
[31m-    PATH: "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"[m
[31m-[m
[31m-- name: Update cache[m
[31m-  apt:[m
[31m-    update_cache: yes[m
[31m-[m
[31m-- name: Install zabbix-agent2[m
[31m-  apt:[m
[31m-    name: zabbix-agent2[m
[31m-    state: latest[m
[31m-[m
[31m-- name: Copy zabbix_agent_conf[m
[31m-  copy:[m
[31m-    src: "{{ conf_src }}"[m
[31m-    dest: "{{ conf_dest }}"[m
[31m-    owner: root[m
[31m-    group: root[m
[31m-    mode : '0644'[m
[31m-  notify: restart zabbix agent[m
[31m-[m
[31m-- name: Run agent[m
[31m-  service: [m
[31m-    name: zabbix-agent2[m
[31m-    state: started[m
[31m-    enabled: yes[m
[31m-[m
[31m-- name: Get zabbix-agent2 status[m
[31m-  shell: systemctl status zabbix-agent2[m
[31m-  register: agent_status[m
[31m-  ignore_errors: yes[m
[31m-[m
[31m-- name: Status agent[m
[31m-  debug:[m
[31m-    msg: "{{ agent_status.stdout_lines }}"[m
[1mdiff --git a/mysteps/ubuntu.yml b/mysteps/ubuntu.yml[m
[1mdeleted file mode 100644[m
[1mindex 0547486..0000000[m
[1m--- a/mysteps/ubuntu.yml[m
[1m+++ /dev/null[m
[36m@@ -1,49 +0,0 @@[m
[31m----[m
[31m-- name: Load os version on vars[m
[31m-  include_vars: "ubuntu{{ ansible_distribution_major_version }}.yml"[m
[31m-[m
[31m-- name: Download repo[m
[31m-  get_url:[m
[31m-      url: "{{ zabbix_repo_url }}" [m
[31m-      dest: /tmp/zabbix-release.deb[m
[31m-[m
[31m-- name: Install repo[m
[31m-  apt:[m
[31m-    deb: /tmp/zabbix-release.deb[m
[31m-[m
[31m-- name: Update cache[m
[31m-  apt:[m
[31m-    update_cache: yes[m
[31m-[m
[31m-- name: Install zabbix-agent2[m
[31m-  apt:[m
[31m-    name: zabbix-agent2[m
[31m-    state: latest[m
[31m-[m
[31m-- name: check config[m
[31m-  debug:[m
[31m-    var: conf_src[m
[31m-[m
[31m-- name: Copy zabbix_config[m
[31m-  copy:[m
[31m-    src: '{{ conf_src }}'[m
[31m-    dest: '{{ conf_dest }}'[m
[31m-    owner: root[m
[31m-    group: root[m
[31m-    mode: '0644'[m
[31m-  notify: restart zabbix agent[m
[31m-[m
[31m-- name: Start and Run[m
[31m-  service:[m
[31m-    name: zabbix-agent2[m
[31m-    state: started[m
[31m-    enabled: yes[m
[31m-[m
[31m-- name: Get zabbix-agent2 status[m
[31m-  shell: systemctl status zabbix-agent2[m
[31m-  register: agent_status[m
[31m-  ignore_errors: yes[m
[31m-[m
[31m-- name: Status agent[m
[31m-  debug:[m
[31m-    msg: "{{ agent_status.stdout_lines }}"[m
[1mdiff --git a/roles/zabbix_agent/tasks/debian.yml b/roles/zabbix_agent/tasks/debian.yml[m
[1mdeleted file mode 100644[m
[1mindex e65c6df..0000000[m
[1m--- a/roles/zabbix_agent/tasks/debian.yml[m
[1m+++ /dev/null[m
[36m@@ -1,69 +0,0 @@[m
[31m----[m
[31m-- name: Load OS version on vars[m
[31m-  include_vars: "debian{{ ansible_distribution_major_version }}.yml"[m
[31m-[m
[31m-- name: Archive old zabbix_agent2.conf if it exists[m
[31m-  become: yes[m
[31m-  shell: |[m
[31m-    if [ -f "{{ conf_dest }}" ]; then[m
[31m-      cp "{{ conf_dest }}" "/etc/zabbix/zabbix_agent2.conf.backup_$(date +%Y.%m.%d)"[m
[31m-    fi[m
[31m-  args:[m
[31m-    executable: /bin/bash[m
[31m-[m
[31m-- name: Ensure basic packages are installed[m
[31m-  become: yes[m
[31m-  apt:[m
[31m-    name:[m
[31m-      - apt-utils[m
[31m-      - dpkg[m
[31m-    state: present[m
[31m-    update_cache: yes[m
[31m-[m
[31m-- name: Download Zabbix repo[m
[31m-  get_url:[m
[31m-    url: "{{ zabbix_repo_url }}"[m
[31m-    dest: /tmp/zabbix-release.deb[m
[31m-[m
[31m-- name: Install Zabbix repo[m
[31m-  become: yes[m
[31m-  apt:[m
[31m-    deb: /tmp/zabbix-release.deb[m
[31m-  environment:[m
[31m-    PATH: "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"[m
[31m-[m
[31m-- name: Update apt cache[m
[31m-  apt:[m
[31m-    update_cache: yes[m
[31m-[m
[31m-- name: Install zabbix-agent2[m
[31m-  apt:[m
[31m-    name: zabbix-agent2[m
[31m-    state: latest[m
[31m-[m
[31m-- name: Copy new zabbix_agent2.conf[m
[31m-  become: yes[m
[31m-  copy:[m
[31m-    src: "{{ conf_src }}"[m
[31m-    dest: "{{ conf_dest }}"[m
[31m-    owner: root[m
[31m-    group: root[m
[31m-    mode: '0644'[m
[31m-  notify: restart zabbix agent[m
[31m-[m
[31m-- name: Start and enable zabbix-agent2 service[m
[31m-  become: yes[m
[31m-  service:[m
[31m-    name: zabbix-agent2[m
[31m-    state: started[m
[31m-    enabled: yes[m
[31m-[m
[31m-- name: Get zabbix-agent2 status[m
[31m-  become: yes[m
[31m-  shell: systemctl status zabbix-agent2[m
[31m-  register: agent_status[m
[31m-  ignore_errors: yes[m
[31m-[m
[31m-- name: Display zabbix-agent2 status[m
[31m-  debug:[m
[31m-    msg: "{{ agent_status.stdout_lines }}"[m
[1mdiff --git a/roles/zabbix_agent/tasks/main.yml b/roles/zabbix_agent/tasks/main.yml[m
[1mindex 4d53331..873472b 100644[m
[1m--- a/roles/zabbix_agent/tasks/main.yml[m
[1m+++ b/roles/zabbix_agent/tasks/main.yml[m
[36m@@ -1,3 +1,7 @@[m
 ---[m
[31m-- name: Choose task[m
[31m-  include_tasks: "{{ ansible_distribution | lower }}.yml"[m
[32m+[m[32m- include_tasks: setup.yml[m
[32m+[m[32m- include_tasks: repo.yml[m
[32m+[m[32m- include_tasks: install.yml[m
[32m+[m[32m- include_tasks: configure.yml[m
[32m+[m[32m- include_tasks: service.yml[m
[32m+[m[32m- include_tasks: status.yml[m
[1mdiff --git a/roles/zabbix_agent/tasks/ubuntu.yml b/roles/zabbix_agent/tasks/ubuntu.yml[m
[1mdeleted file mode 100644[m
[1mindex 214d404..0000000[m
[1m--- a/roles/zabbix_agent/tasks/ubuntu.yml[m
[1m+++ /dev/null[m
[36m@@ -1,66 +0,0 @@[m
[31m----[m
[31m-- name: Load os version on vars[m
[31m-  include_vars: "ubuntu{{ ansible_distribution_major_version }}.yml"[m
[31m-[m
[31m-- name: Archive old zabbix_agent2.conf if it exists[m
[31m-  become: yes[m
[31m-  shell: |[m
[31m-    if [ -f "{{ conf_dest }}" ]; then[m
[31m-      cp "{{ conf_dest }}" "/etc/zabbix/zabbix_agent2.conf.backup_$(date +%Y.%m.%d)"[m
[31m-    fi[m
[31m-  args:[m
[31m-    executable: /bin/bash[m
[31m-[m
[31m-- name: Download repo[m
[31m-  get_url:[m
[31m-      url: "{{ zabbix_repo_url }}" [m
[31m-      dest: /tmp/zabbix-release.deb[m
[31m-[m
[31m-- name: Install repo[m
[31m-  apt:[m
[31m-    deb: /tmp/zabbix-release.deb[m
[31m-  become: yes[m
[31m-  environment:[m
[31m-    PATH: "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"[m
[31m-[m
[31m-- name: Update cache[m
[31m-  apt:[m
[31m-    update_cache: yes[m
[31m-[m
[31m-- name: Ensure basic packages are installed[m
[31m-  become: yes[m
[31m-  apt:[m
[31m-    name:[m
[31m-      - apt-utils[m
[31m-      - dpkg[m
[31m-    state: present[m
[31m-    update_cache: yes[m
[31m-[m
[31m-- name: Install zabbix-agent2[m
[31m-  apt:[m
[31m-    name: zabbix-agent2[m
[31m-    state: latest[m
[31m-[m
[31m-- name: Copy zabbix_config[m
[31m-  copy:[m
[31m-    src: '{{ conf_src }}'[m
[31m-    dest: '{{ conf_dest }}'[m
[31m-    owner: root[m
[31m-    group: root[m
[31m-    mode: '0644'[m
[31m-  notify: restart zabbix agent[m
[31m-[m
[31m-- name: Start and Run[m
[31m-  service:[m
[31m-    name: zabbix-agent2[m
[31m-    state: started[m
[31m-    enabled: yes[m
[31m-[m
[31m-- name: Get zabbix-agent2 status[m
[31m-  shell: systemctl status zabbix-agent2[m
[31m-  register: agent_status[m
[31m-  ignore_errors: yes[m
[31m-[m
[31m-- name: Status agent[m
[31m-  debug:[m
[31m-    msg: "{{ agent_status.stdout_lines }}"[m
[1mdiff --git a/roles/zabbix_agent/vars/debian11.yml b/roles/zabbix_agent/vars/debian11.yml[m
[1mindex 1b83066..1b65983 100644[m
[1m--- a/roles/zabbix_agent/vars/debian11.yml[m
[1m+++ b/roles/zabbix_agent/vars/debian11.yml[m
[36m@@ -1,2 +1,6 @@[m
 ---[m
[31m-zabbix_repo_url: https://repo.zabbix.com/zabbix/7.4/release/debian/pool/main/z/zabbix-release/zabbix-release_7.4-1+debian11_all.deb[m
[32m+[m[32mzabbix_repo_url: "https://repo.zabbix.com/zabbix/7.4/release/debian/pool/main/z/zabbix-release/zabbix-release_7.4-1+debian11_all.deb"[m
[32m+[m[32mzabbix_repo_env:[m[41m [m
[32m+[m[32m  PATH: "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"[m
[32m+[m[32mconf_src: "zabbix_agent2HWSRV004.conf"[m
[32m+[m[32mconf_dest: "/etc/zabbix/zabbix_agent2.conf"[m
[1mdiff --git a/roles/zabbix_agent/vars/debian12.yml b/roles/zabbix_agent/vars/debian12.yml[m
[1mindex 74f6c7a..836d6cc 100644[m
[1m--- a/roles/zabbix_agent/vars/debian12.yml[m
[1m+++ b/roles/zabbix_agent/vars/debian12.yml[m
[36m@@ -1,5 +1,9 @@[m
 ---[m
[31m-zabbix_repo_url: https://repo.zabbix.com/zabbix/7.4/release/debian/pool/main/z/zabbix-release/zabbix-release_7.4-1+debian12_all.deb[m
[32m+[m[32mzabbix_repo_url: "https://repo.zabbix.com/zabbix/7.4/release/debian/pool/main/z/zabbix-release/zabbix-release_7.4-1+debian12_all.deb"[m
[32m+[m[32mzabbix_repo_env:[m[41m [m
[32m+[m[32m  PATH: "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"[m
[32m+[m[32mconf_src: "zabbix_agent2HWSRV004.conf"[m
[32m+[m[32mconf_dest: "/etc/zabbix/zabbix_agent2.conf"[m
 [m
 [m
 [m
[1mdiff --git a/roles/zabbix_agent/vars/debian13.yml b/roles/zabbix_agent/vars/debian13.yml[m
[1mindex b91a908..245e9e8 100644[m
[1m--- a/roles/zabbix_agent/vars/debian13.yml[m
[1m+++ b/roles/zabbix_agent/vars/debian13.yml[m
[36m@@ -1,4 +1,8 @@[m
 ---[m
[31m-zabbix_repo_url: https://repo.zabbix.com/zabbix/7.4/release/debian/pool/main/z/zabbix-release_7.4-1+debian13_all.deb[m
[32m+[m[32mzabbix_repo_url: "https://repo.zabbix.com/zabbix/7.4/release/debian/pool/main/z/zabbix-release/zabbix-release_7.4-1+debian13_all.deb"[m
[32m+[m[32mzabbix_repo_env:[m[41m [m
[32m+[m[32m  PATH: "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"[m
[32m+[m[32mconf_src: "zabbix_agent2HWSRV004.conf"[m
[32m+[m[32mconf_dest: "/etc/zabbix/zabbix_agent2.conf"[m
 [m
 [m
[1mdiff --git a/roles/zabbix_agent/vars/ubuntu20.yml b/roles/zabbix_agent/vars/ubuntu20.yml[m
[1mindex 2c65634..2740bed 100644[m
[1m--- a/roles/zabbix_agent/vars/ubuntu20.yml[m
[1m+++ b/roles/zabbix_agent/vars/ubuntu20.yml[m
[36m@@ -1,3 +1,6 @@[m
 ---[m
[31m-zabbix_repo_url: https://repo.zabbix.com/zabbix/7.4/release/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.4+ubuntu20.04_all.deb[m
[32m+[m[32mzabbix_repo_url: "https://repo.zabbix.com/zabbix/7.4/release/ubuntu/pool/main/z/zabbix-release/zabbix-release_7.4-1+ubuntu20.04_all.deb"[m
[32m+[m[32mzabbix_repo_env: {}[m
[32m+[m[32mconf_src: "zabbix_agent2HWSRV004.conf"[m
[32m+[m[32mconf_dest: "/etc/zabbix/zabbix_agent2.conf"[m
 [m
[1mdiff --git a/roles/zabbix_agent/vars/ubuntu22.yml b/roles/zabbix_agent/vars/ubuntu22.yml[m
[1mindex 30005fe..ed168cf 100644[m
[1m--- a/roles/zabbix_agent/vars/ubuntu22.yml[m
[1m+++ b/roles/zabbix_agent/vars/ubuntu22.yml[m
[36m@@ -1,4 +1,7 @@[m
 ---[m
[31m-zabbix_repo_url: https://repo.zabbix.com/zabbix/7.4/release/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.4+ubuntu22.04_all.deb[m
[32m+[m[32mzabbix_repo_url: "https://repo.zabbix.com/zabbix/7.4/release/ubuntu/pool/main/z/zabbix-release/zabbix-release_7.4-1+ubuntu22.04_all.deb"[m
[32m+[m[32mzabbix_repo_env: {}[m
[32m+[m[32mconf_src: "zabbix_agent2HWSRV004.conf"[m
[32m+[m[32mconf_dest: "/etc/zabbix/zabbix_agent2.conf"[m
 [m
 [m
[1mdiff --git a/roles/zabbix_agent/vars/ubuntu24.yml b/roles/zabbix_agent/vars/ubuntu24.yml[m
[1mindex 58ba98a..d520619 100644[m
[1m--- a/roles/zabbix_agent/vars/ubuntu24.yml[m
[1m+++ b/roles/zabbix_agent/vars/ubuntu24.yml[m
[36m@@ -1,5 +1,7 @@[m
 ---[m
 zabbix_repo_url: https://repo.zabbix.com/zabbix/7.4/release/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.4+ubuntu24.04_all.deb[m
[31m-[m
[32m+[m[32mzabbix_repo_env: {}[m
[32m+[m[32mconf_src: "zabbix_agent2HWSRV004.conf"[m
[32m+[m[32mconf_dest: "/etc/zabbix/zabbix_agent2.conf"[m
 [m
 [m
