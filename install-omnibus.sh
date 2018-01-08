#!/bin/bash

# This file is a wrapper to install omnibus using ansible.
# Trying to install omnibus using gem role, command/shell
# roles or even via ssh command fails because libyajl2
# (omnibus dependency) tries to build native extensions and
# their way to use makefiles and compile does not work when
# running as ssh command.
#
# Copying this script into the remote host where we want to
# install omnibus and running it seems to work around the previous
# described issue.

set -ex

gem install \
    --verbose omnibus \
    --install-dir=/home/rpm_omnibus/gem/ruby/2.2.0 \
    --no-document --no-rdoc --no-ri --minimal-deps \
    --platform ruby --no-prerelease --no-wrappers \
    --suggestions --clear-sources --backtrace
