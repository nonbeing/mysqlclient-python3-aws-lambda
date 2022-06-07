FROM public.ecr.aws/sam/build-python3.9

ARG mysql_gpg_key_url="https://repo.mysql.com/RPM-GPG-KEY-mysql"
ARG mysql_gpg_key_name="RPM-GPG-KEY-mysql"
ARG mysql_repo_rpm="mysql80-community-release-el7-3.noarch.rpm"
ARG mysql_devel_package_url="https://dev.mysql.com/get/${mysql_repo_rpm}"
ARG mysql_devel_package="mysql-community-devel"
ARG python_package_to_install="mysqlclient"

# grab and import the MySQL repo GPG key to install mysql-devel later
RUN curl -Ls -c cookieJar -O ${mysql_gpg_key_url}
RUN rpm --import ${mysql_gpg_key_name}

# prerequisite for getting mysql-devel package
RUN curl -Ls -c cookieJar -O ${mysql_devel_package_url}
RUN yum install -y ${mysql_repo_rpm}

# install mysql-devel package
RUN yum install -y ${mysql_devel_package}
