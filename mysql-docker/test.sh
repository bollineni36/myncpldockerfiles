#!/bin/bash
# Copyright (c) 2018, Oracle and/or its affiliates. All rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA

# This script will simply use sed to replace placeholder variables in the
# files in template/ with version-specific variants.

set -e
source ./VERSION

ARCH=amd64; [ -n "$1" ] && ARCH=$1
MAJOR_VERSIONS=("${!MYSQL_SERVER_VERSIONS[@]}"); [ -n "$2" ] && MAJOR_VERSIONS=("${@:2}")


for MAJOR_VERSION in "${MAJOR_VERSIONS[@]}"; do
    ARCH_SUFFIX="" 
    for MULTIARCH_VERSION in ${MULTIARCH_VERSIONS}; do
      if [[ "$MULTIARCH_VERSION" == "$MAJOR_VERSION" ]]; then
        ARCH_SUFFIX="-$ARCH"
      fi
    done
    docker run -d --name mysql-server mysql/mysql-server:"$MAJOR_VERSION$ARCH_SUFFIX"
    inspec exec "$MAJOR_VERSION/inspec/control.rb" --controls container
    inspec exec "$MAJOR_VERSION/inspec/control.rb" -t docker://mysql-server --controls server-package
    if [ "${MAJOR_VERSION}" == "5.7" ] || [ "${MAJOR_VERSION}" == "8.0" ]; then
      inspec exec "$MAJOR_VERSION/inspec/control.rb" -t docker://mysql-server --controls shell-package
    fi
    docker stop mysql-server
    docker rm mysql-server
done
