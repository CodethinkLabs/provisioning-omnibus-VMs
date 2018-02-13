Documentation
=============
This repository provides a bash script (provision-VM.sh) which calls two
playbooks to configure a CentOS 6.x VM with the packages and configuration
required to build codethink-toolchain
(https://github.com/CodethinkLabs/omnibus-codethink-toolchain).

The script assume the CentOS 6.x VM is accessible by ssh client using
root and its password.

The script will create a rpm_omnibus user which meant to be used to
configure the installed packages and run the builds.

NOTE: This script has been tested in CentOS 6.6 and 6.8 VMs.

You could find CentOS ISO images in:
  - http://mirror.nsc.liu.se/centos-store
  - https://www.centos.org/download/

NOTE: if you are creating the VM using the ISO image, remember to configure the
      network enabling eth0 on connection always.

provision-VM.sh
===================
For more information about this script run it with -h argument,
e.g. `./provision-VM.sh -h`
