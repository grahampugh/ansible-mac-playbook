ansible-mac-playbook
-----

Setting up my own Mac server and workstations.

In VERY early development.

To set up Ansible for the first time:

  * If you wish to configure hosts other than your own, copy
    `inventory_template` to `inventory` and populate it with your hosts.
  * You can specify individual ssh users for each client.
  * `inventory` is in `.git_ignore` to avoid uploading your local config to git.

```
chmod u+x bootstrap.sh
./bootstrap.sh
```

Available configurations:
-----

  * `cli_config.yaml` - setting up the command line.
  * `atom_config.yaml` - setting up Atom preferences.
  * `munki_config.yaml` - configuring the Munki client.
  * `local_installs.yaml` - installs modules from Galaxy or git, as specified
    in `requirements.yaml`.
  * `local.yaml` - complete setup for the local machine that is running Ansible.
  * `local-work.yaml` - complete setup for the local machine that is running Ansible (no Munki config included).
  * `workstation.yaml` - complete setup for other machines.

Usage
-----

  * **Local machine**:  
    The sudo password is required to set the Munki config.
```
ansible-playbook local_installs.yaml
ansible-playbook local.yaml --ask-become-pass
```
  * **Workstations**:  
    The sudo password is required to set the Munki config. Create your inventory!
```
ansible-playbook workstations -i inventory workstation.yaml --ask-become-pass
```


To-Do
-----

  * Ansible module for creating configuration profiles.
  * Ansible module for installing Munki on clients.

Won't Do
-----

  * Installing software with Homebrew.
