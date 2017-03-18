#!/usr/bin/env bash
#Copied from http://www.eightbitraptor.com/post/bootstrapping-osx-ansible
set -e

echo
echo "### Ansible bootstrapper..."
echo

if [[ -z "$HOME/.ssh/id_rsa.pub" ]]; then
    echo "No SSH key found. Run ssh-keygen to set up an ssh key."
    echo
    exit 0
fi

echo
echo '### Installing Ansible'

# Install pip
if [[ -z $(which pip) ]]; then
    sudo easy_install pip
fi

if [[ $(which pip) && -z $(which ansible) ]]; then
    sudo pip install ansible
fi

if [[ $(which ansible) ]]; then
    echo
    echo "### Ansible installed!"
    echo
    echo '### Running Ansible to configure Dev machine'
    ansible-playbook local.yaml --ask-sudo-pass

    echo '### Sending ssh key to other machines in the inventory'
    ansible workstations -i inventory -m authorized_key \
        key="{{ lookup('file', '$HOME/.ssh/id_rsa.pub') }}" \
        -a "path=/Users/{{ ansible_user_id }}/.ssh/authorized_keys" \
        --ask-pass
fi
