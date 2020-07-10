# AWS layer for `mysqlclient` for Python 3.x

## TLDR

- In a hurry?
- Are you using Python 3.8?
- Are you using MySQL v8?
- Do you want to use [mysqlclient](https://github.com/PyMySQL/mysqlclient-python) in your AWS Lambda function, but it's causing you headaches?

If you answered `yes` to all the above questions, simply upload `build_outputs/layer.zip` file as an AWS Layer to your AWS account.

After you create the required layer, you can simply `import MySQLdb` to confirm that it is working for you in a Lambda function like this:

```python
import MySQLdb

def lambda_handler(event, context):
    cf.cust_fun()
    return {
        'statusCode': 200,
        'body': 'MySQLdb was successfully imported'
    }
```

If you get the success message and don't see an error from Lambda like `ModuleNotFoundError: No module named 'MySQLdb'`, then you're all set to use `mysqlclient` on AWS Lambda.

If you answered `no` to any of those question, then read on to figure out if you need to build your own AWS layer to use `mysqlclient` using the tools provided in this repo.

## Motivation

`mysqlclient` is usually the first choice for connecting to a MySQL database in Python because of its top-notch performance in most use-cases. However, since it is a thin wrapper on a C-implementation, it has dependencies on a `so` binary, and is thus not a "pure-python" implementation. The binary it depends on, needs to be compatible with the specific `Amazon Linux 2` environment that AWS Lambda runs in, and this can be tedious to get right.

Therefore, it is non-trivial to use `mysqlclient` in AWS Lambda Python code, especially when you want to deploy it in an [AWS Lambda Layer](https://docs.aws.amazon.com/lambda/latest/dg/configuration-layers.html).

### goal
The goal of this project is to provide an easy way to build an AWS Lambda layer for `mysqlclient` so that this package can be readily used in an AWS Lambda Python function. By including the layer in your Lambda function configuration, you can just `import MySQLdb` as usual and get on with your actual code.

### mysqlclient

[mysqlclient](https://github.com/PyMySQL/mysqlclient-python) is a mature, stable driver for MySQL, actively maintained by members of the PyMySQL community, and [available on PyPI](https://pypi.org/project/mysqlclient/). It provides a Python wrapper around the MySQL C API; the [core is implemented in C](https://mysqlclient.readthedocs.io/user_guide.html).

 `mysqlclient` is in general, usually the top choice from among `mysqlclient`, `pymysql` and Oracle's `MySQL-Connector` for connecting to a MySQL DB in Python. It is the most performance across most use-cases, and very stable.

`mysqlclient` is a [top recommendation on the SQLAlchemy MySQL driver page](https://docs.sqlalchemy.org/en/13/dialects/mysql.html#module-sqlalchemy.dialects.mysql.mysqldb)

> mysqlclient supports Python 2 and Python 3 and is very stable.
> The recommended MySQL dialects are mysqlclient and PyMySQL.

### pymysql
The PyMySQL community also actively maintains another project, called [`PyMySQL`](https://github.com/PyMySQL/PyMySQL), which is a pure-python implementation.


### MySQL-Connector
Oracle (owner and maintainer of `MySQL`) also provide a pure-python library for talking to MySQL called [`MySQL Connector`](https://dev.mysql.com/doc/connector-python/en/). This is the "official" driver for Python from MySQL.

SQLAlchemy [doesn't recommend](https://docs.sqlalchemy.org/en/13/dialects/mysql.html#module-sqlalchemy.dialects.mysql.mysqlconnector) using this driver:

> Note
> The MySQL Connector/Python DBAPI has had many issues since its release, some of which may remain unresolved, and the mysqlconnector dialect is **not tested as part of SQLAlchemy’s continuous integration**. The recommended MySQL dialects are mysqlclient and PyMySQL.

### performance comparison
`mysqlclient` can run 5x-to-10x faster (on CPython) than `pymysql`, according to these discussions and tests:

[insert pic here]
- https://wiki.openstack.org/wiki/PyMySQL_evaluation#Architecture_and_Performance
- http://charlesnagy.info/it/python/python-mysqldb-vs-mysql-connector-query-performance
- https://www.programmersought.com/article/4675925085/
- https://gist.github.com/methane/90ec97dda7fa9c7c4ef1
- https://stackoverflow.com/questions/43102442/whats-the-difference-between-mysqldb-mysqlclient-and-mysql-connector-python
- https://stackoverflow.com/questions/51152183/fastest-way-to-read-huge-mysql-table-in-python


Note: `pymysql` could possibly be as fast as (or faster than) `mysqlclient` if used with `PyPy`, but according to [this post on StackOverflow](https://stackoverflow.com/a/52685419/376240), `mysqlclient` is still faster, even on PyPy3.7

### summary

For most use-cases, `mysqlclient` is the preferred choice of DB connector to MySQL, but it is not straightforward to use on AWS Lambda's Python runtime.

This project attempts to solve (or at least alleviate) this problem to a large extent by providing a relatively-straightforward path to building an AWS Layer for `mysqlclient` which can then be readily consumed in AWS Lambda Python functions.

## HowTo


## Credits and Thanks
The work in this repo is largely based off Seungyeon Kim(Acuros Kim)'s project: https://github.com/StyleShare/aws-lambda-python3-mysql - thanks!

I have adapted that project to build an AWS Layer using the MySQL-devel package for MySQL 8 (instead of 5.5) and targeting Python 3.8 (instead of 3.7) (as of this writing).