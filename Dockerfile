FROM lambci/lambda:build-python3.8

ARG mysql_gpg_key_url="https://repo.mysql.com/RPM-GPG-KEY-mysql"
ARG mysql_repo_rpm="mysql80-community-release-el7-3.noarch.rpm"
ARG mysql_devel_package_url="https://dev.mysql.com/get/${mysql_repo_rpm}"
ARG mysql_devel_package="mysql-community-devel"
ARG python_package_to_install="mysqlclient"

RUN curl -Ls -c cookieJar -O ${mysql_devel_package_url}

# we need to allow the MySQL GPG key to install mysql-devel later
RUN curl -O ${mysql_gpg_key_url}
RUN rpm --import RPM-GPG-KEY-mysql

RUN yum install -y ${mysql_repo_rpm}

RUN yum install -y ${mysql_devel_package}

RUN pip install ${python_package_to_install} --no-cache-dir --disable-pip-version-check