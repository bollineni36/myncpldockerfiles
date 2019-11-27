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
FROM ubuntu:latest

ENV MYSQL_USER=mysql \
    MYSQL_VERSION=5.7 \
    MYSQL_RUN_DIR=/run/mysqld \
    MYSQL_LOG_DIR=/var/log/mysql \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y mysql-server=${MYSQL_VERSION}* \
 && rm -rf ${MYSQL_DATA_DIR} \
 && rm -rf /var/lib/apt/lists/*

#ARG MYSQL_SERVER_PACKAGE=mysql-community-server-minimal-5.7.28
#ARG MYSQL_SHELL_PACKAGE=mysql-shell-8.0.18

# Install server
#RUN yum install -y https://repo.mysql.com/mysql-community-minimal-release-el7.rpm \
#      https://repo.mysql.com/mysql-community-release-el7.rpm \
#  && yum-config-manager --enable mysql57-server-minimal \
#  && yum install -y \
#      $MYSQL_SERVER_PACKAGE \
#      $MYSQL_SHELL_PACKAGE \
#      libpwquality \
#  && yum clean all \
#  && mkdir /docker-entrypoint-initdb.d

VOLUME /var/lib/mysql

COPY docker-entrypoint.sh /entrypoint.sh
COPY healthcheck.sh /healthcheck.sh
ENTRYPOINT ["/entrypoint.sh"]
HEALTHCHECK CMD /healthcheck.sh
EXPOSE 3306 33060
CMD ["mysqld"]

