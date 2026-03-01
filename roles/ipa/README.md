Role Name
=========

FreeIPA Server provide domain authentication method

Requirements
------------

- RHEL base with static IP
- Hostname setup with FQDN

Role Variables
--------------

- {{ app_user }}
- {{ app_dir }}
- {{ domain }}

Dependencies
------------

- common (role)

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
        - common
        - ipa

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
