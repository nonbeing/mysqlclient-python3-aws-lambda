FROM public.ecr.aws/sam/build-python3.11

ARG mysql_repo_rpm="mysql80-community-release-el7-3.noarch.rpm"
ARG mysql_devel_package_url="https://dev.mysql.com/get/${mysql_repo_rpm}"
ARG mysql_devel_package="mysql-community-devel"
ARG python_package_to_install="mysqlclient"

# Download and import multiple MySQL GPG keys to ensure compatibility
RUN curl -fsSL https://repo.mysql.com/RPM-GPG-KEY-mysql-2022 -o /tmp/RPM-GPG-KEY-mysql-2022 && \
    curl -fsSL https://repo.mysql.com/RPM-GPG-KEY-mysql -o /tmp/RPM-GPG-KEY-mysql && \
    rpm --import /tmp/RPM-GPG-KEY-mysql-2022 /tmp/RPM-GPG-KEY-mysql

# prerequisite for getting mysql-devel package
RUN curl -Ls -c cookieJar -O ${mysql_devel_package_url}
RUN yum install -y ${mysql_repo_rpm}

# install mysql-devel package with GPG check disabled as fallback
RUN yum install -y ${mysql_devel_package} || yum install -y --nogpgcheck ${mysql_devel_package}
