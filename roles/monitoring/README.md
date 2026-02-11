Role Name
=========

Monitoring Role is a combination of various applications such as: Prometheus, Grafana, Alert Manager, InfluxDB to monitor analytics & metrics for other applications

Requirements
------------

- Linux Platform (Debian/Red Hat)
- Ansible AWX (For executing playbooks)
- Sysadmin Skills (For troubleshooting as needed)
- Containers Concept


Role Variables
--------------

- app_dir: "/srv/AppData"
- app_user: "k0ng"
- compose_dir: "{{ app_dir }}/compose"
- domain: "superasian.net"
- mon_dir: "{{ app_dir }}/monitoring"
- grafana_dir: "{{ mon_dir }}/grafana"
- influxdb_dir: "{{ mon_dir }}/influxdb"
- prometheus_dir: "{{ mon_dir }}/prometheus"
- telegraf_dir: "{{ mon_dir }}/telegraf"
- repo_url: "https://www.superasian.net/repo"
- srv_ip: "10.0.0.19"

Dependencies
------------

- Common Role
- Nginx Role

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: username.rolename, x: 42 }

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
