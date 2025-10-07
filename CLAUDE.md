# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Purpose

This repository builds AWS Lambda layers for Python packages with platform-specific dependencies (`.so` files), primarily focused on `mysqlclient` (MySQLdb). It provides:
- Ready-made layer.zip files for mysqlclient on different Python/MySQL versions
- Docker-based build system that replicates AWS Lambda's Amazon Linux 2 environment
- Multi-branch architecture for different Python/MySQL version combinations

## Branch Structure

Different branches target different Python and MySQL versions:
- `master`: Python 3.11 + MySQL 8.0.x
- `mysql8-py3.8`: Python 3.8 + MySQL 8.0.x
- `mysql5.6-py3.8`: Python 3.8 + MySQL 5.6.x
- `general-purpose`: For building layers for any Python package (not MySQL-specific)

The master branch currently uses Python 3.11 as standard. Each branch contains its own `build_output/layer.zip`.

## Build System Architecture

The build uses a 3-step Docker-based process:

1. **Dockerfile**: Creates Docker image based on `public.ecr.aws/sam/build-python3.11` (or other Python version). Installs MySQL-devel RPM packages needed to compile mysqlclient.

2. **build.sh**:
   - Cleans `build_output/` directory
   - Builds Docker image with tag from `IMAGE_NAME` variable
   - Runs container to execute `pip_and_copy.sh`
   - Zips `build_output/python/` and `build_output/lib/` into `layer.zip`

3. **pip_and_copy.sh**:
   - Runs inside Docker container
   - Installs packages from `requirements.txt` to `build_output/python/`
   - Copies `libmysqlclient.so.[digit]` from `/usr/lib64/mysql/` to `build_output/lib/`
   - Uses regex to copy only the versioned `.so` file (e.g., `.so.21`), not symlinks

## Build Commands

Build a new layer.zip:
```bash
bash build.sh
```

This requires:
- Docker installed and running
- *nix environment (tested on Ubuntu 20.04, WSL2, macOS)
- sudo access for cleaning build_output

The final artifact is `build_output/layer.zip`, ready to upload to AWS Lambda.

## Key Configuration Files

- **requirements.txt**: Python packages to install (currently `mysqlclient==2.0.3`)
- **Dockerfile**: Controls MySQL version via `mysql_repo_rpm` and `mysql_devel_package_url` args
- **build.sh**: Docker image name in `IMAGE_NAME` variable
- **pip_and_copy.sh**: Takes PKG_DIR and LIB_DIR as arguments from build.sh

## Adapting for Different Versions

To target a different MySQL or Python version:
1. Update Dockerfile `mysql_repo_rpm` and `mysql_devel_package_url` for MySQL version
2. Change base image `FROM public.ecr.aws/sam/build-python3.X` for Python version
3. Update requirements.txt for desired mysqlclient version
4. Run `bash build.sh`

## Adapting for Other Packages

For non-MySQL packages (see `general-purpose` branch):
1. Modify Dockerfile to install required system dependencies
2. Update requirements.txt with target package
3. Modify pip_and_copy.sh to copy appropriate `.so` files if needed
4. Run `bash build.sh`

## Output Structure

The layer.zip contains:
- `python/`: Python packages and modules (installed by pip)
- `lib/`: Shared libraries (.so files) required at runtime

AWS Lambda automatically adds `python/` to PYTHONPATH and `lib/` to LD_LIBRARY_PATH when the layer is attached.

## GPG Key Handling

The Dockerfile fetches multiple MySQL GPG keys (RPM-GPG-KEY-mysql-2022 and RPM-GPG-KEY-mysql) to handle MySQL repository signature verification. Falls back to `--nogpgcheck` if GPG verification fails during yum install.
