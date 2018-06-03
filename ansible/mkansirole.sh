#!/bin/sh

# ebal, Mon, 09 Apr 2018 12:21:37 +0300
# a bash shell script for creating a directory structure within the Ansible role templates (with main.yml)

echo " "

function die() {
    exit 1
}

function usage() {
    echo -e "USAGE: mkansirole rolename\n"
    die
}

function check_args() {
    if [ $# -ne 1 ]
      then
        usage
    fi
}

function create_role() {
    role=$1
    DIRS=(tasks handlers files templates vars defaults meta)

    for i in ${DIRS[@]}; do
        mkdir -p ${role}/$i;
        touch ${role}/$i/main.yml;
    done
    
    cat <<EOF > ./${role}/tasks/main.yml 
---
  - name: Debug that our ansible role is working
    debug:
      msg: "It Works !"

  - name: Install the Extra Packages for Enterprise Linux repository
    yum:
      name: epel-release
      state: present
EOF

}

function create_playbook(){
    role=$1.yml

    cat <<EOF > ./${role}
---
- hosts: all
  gather_facts: no
  roles:
    - role: $1
EOF
}

function main() {
    check_args "$0"
    create_role "$1"
    create_playbook "$1"
    tree "$1"
    echo ""
    echo -e "Run: 'ansible-playbook "$1".yml -c local -l localhost'"
    echo ""
}

main "$@"
