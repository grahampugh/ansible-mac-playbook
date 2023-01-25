#!/usr/bin/env bash
#Copied from http://www.eightbitraptor.com/post/bootstrapping-osx-ansible
set -e

installCommandLineTools() {
    # Installing the Xcode command line tools on 10.10+
    # This section written by Rich Trouton.
    echo "   [setup] Installing the command line tools..."
    echo
    cmd_line_tools_temp_file="/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress"

    # Installing the latest Xcode command line tools on 10.9.x or above
    osx_vers=$(sw_vers -buildVersion)
    if [[ "${osx_vers:0:2}" -ge 13 ]] ; then

        # Create the placeholder file which is checked by the softwareupdate tool
        # before allowing the installation of the Xcode command line tools.
        touch "$cmd_line_tools_temp_file"

        # Find the last listed update in the Software Update feed with "Command Line Tools" in the name
        cmd_line_tools=$(softwareupdate -l | grep "Label: Command Line Tools" | sed 's|^\* Label: ||')

        #Install the command line tools
        sudo softwareupdate -i "$cmd_line_tools"

        # Remove the temp file
        if [[ -f "$cmd_line_tools_temp_file" ]]; then
            rm "$cmd_line_tools_temp_file"
        fi
    else
        echo "   [setup] ERROR: this script is only for use on OS X/macOS >= 10.9"
        exit 1
    fi
}


echo
echo "### Ansible bootstrapper..."
echo

# if [[ ! -f "$HOME/.ssh/id_rsa.pub" ]]; then
#     echo "No SSH key found. Run ssh-keygen to set up an ssh key."
#     echo
#     exit 0
# fi

# ensure the Xcode command line tools are installed
if ! xcode-select -p >/dev/null 2>&1 ; then
    installCommandLineTools
fi

# check CLI tools are functional
if ! /usr/bin/git --version >/dev/null 2>&1 ; then
    installCommandLineTools
fi

echo
echo '### Installing Ansible'

# Install or upgrade ansible
if [[ -z $(which ansible) ]]; then
    python3 -m pip install --user ansible
else
    python3 -m pip install --upgrade --user ansible
fi

if [[ $(which ansible) ]]; then
    echo
    echo "### Ansible installed!"
    echo
    echo '### Running Ansible to configure Dev machine'
    ansible-playbook local.yaml --ask-becomes-pass

    # echo '### Sending ssh key to other machines in the inventory'
    # ansible workstations -i inventory -m authorized_key \
    #     key="{{ lookup('file', '$HOME/.ssh/id_rsa.pub') }}" \
    #     -a "path=/Users/{{ ansible_user_id }}/.ssh/authorized_keys" \
    #     --ask-pass
fi
