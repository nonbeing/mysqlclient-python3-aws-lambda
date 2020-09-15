FROM lambci/lambda:build-python3.8

ARG mysql_gpg_key_url="https://repo.mysql.com/RPM-GPG-KEY-mysql"
ARG mysql_gpg_key_name="RPM-GPG-KEY-mysql"
ARG mysql_repo_rpm="mysql80-community-release-el7-3.noarch.rpm"
ARG mysql_devel_package_url="https://dev.mysql.com/get/${mysql_repo_rpm}"
ARG mysql_devel_package="mysql-community-devel"
ARG python_package_to_install="mysqlclient"

# grab and import the MySQL repo GPG key to install mysql-devel later
RUN curl -Ls -c cookieJar -O ${mysql_gpg_key_url}
RUN rpm --import ${mysql_gpg_key_name}

# prerequisite for getting mysql-devel package; this enables the MySQL Yum Repo
RUN curl -Ls -c cookieJar -O ${mysql_devel_package_url}
RUN yum install -y ${mysql_repo_rpm}

# get the "yum-config-manager" utility
RUN yum install -y yum-utils

# enable the right repo for installing packages related to MySql 5.6
RUN yum-config-manager --disable mysql80-community
RUN yum-config-manager --enable mysql56-community

# install the "mysql-community-devel" package for MySQL 5.6
# this installs /usr/lib64/mysql/libmysqlclient.so.18
# which is what we need for `pip install mysqlclient` later
RUN yum install -y ${mysql_devel_package}
# =======================================================================================================
#  Package                        Arch           Version                 Repository                 Size
# =======================================================================================================
# Installing:
#  mysql-community-devel          x86_64         5.6.49-2.el7            mysql56-community         3.4 M
# Installing for dependencies:
#  mysql-community-common         x86_64         5.6.49-2.el7            mysql56-community         289 k
#  mysql-community-libs           x86_64         5.6.49-2.el7            mysql56-community         2.2 M
