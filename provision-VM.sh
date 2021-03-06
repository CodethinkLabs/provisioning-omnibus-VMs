#!/bin/bash

set -eux

usage() {
  cat <<EOF
  usage: $0 -a VM_IP_ADDRESS -p VM_ROOT_PASSWORD [-f]

  This script installs the required software and configures the VM,
  described by its VM_IP_ADDRESS passed as argument to be able to
  build the packages in omnibus-codethink-toolchain repository.
  (https://github.com/CodethinkLabs/omnibus-codethink-toolchain).

  OPTIONS:
    -h Show this message
    -a IP address of the VM which is going to be configured.
    -p root password of the VM which is going to be configured.
    -f configure the VM to be able to build LLVM suite.

  EXAMPLE:
    $0 -a 192.168.256.256 -p insecure
EOF
}

configure_vm() {
  pushd "$script_dir"
  ansible-playbook -i hosts user-creation.yml \
                   -e "ansible_user=root ansible_ssh_pass=$vm_root_password"
  ansible-playbook -i hosts gcc-vm.yml \
                   -e "ansible_user=rpm_omnibus ansible_ssh_pass=1ns3cur3" \
                   -vv

  if [[ -n "$with_flang" ]];then
    ansible-playbook -i hosts flang-vm.yml \
                     -e "ansible_user=rpm_omnibus ansible_ssh_pass=1ns3cur3" \
                     -vv
  fi
  popd
}

main() {

  echo "$@"
  script_dir="$( cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd )"
  vm_ip_address=""
  vm_root_password=""
  with_flang=""
  while getopts "ha:p:f" option; do
    case $option in
      h)
        usage
        exit 0
        ;;
      a)
        vm_ip_address="$OPTARG"
        ;;
      p)
        vm_root_password="$OPTARG"
        ;;
      f)
        with_flang="yes"
        ;;
    esac
  done

  if [[ -z "$vm_root_password" ]];then
    echo -e "ERROR: Passing root password is mandatory\n"
    usage
    exit 1
  fi

  if [[ ! -f "$script_dir/hosts" ]] && [[ -z "$vm_ip_address" ]];then
    echo -e "ERROR: Passing vm_ip_address is mandatory when hosts file is not available\n"
    usage
    exit 1
  fi

  if [[ -n "$vm_ip_address" ]];then
    echo "GCCVM ansible_ssh_host=$vm_ip_address" > "$script_dir/hosts"
  fi

  configure_vm
}

main "$@"
