# Git remote helper for rclone-supported services

[![GitHub release](https://img.shields.io/github/release/datalad/git-remote-rclone.svg)](https://GitHub.com/datalad/git-remote-rclone/releases/) [![PyPI version fury.io](https://badge.fury.io/py/git-remote-rclone.svg)](https://pypi.python.org/pypi/git-remote-rclone)

This is a [Git remote helper](https://git-scm.com/docs/git-remote-helpers) for
backends supported by [rclone](https://rclone.org). In other words, this
helper makes it possible to push and pull to a large number of storage services
with no native Git support.

## Usage

Visit the [rclone website](https://rclone.org) and follow the instructions for
installation of `rclone`, and configuration of access to the desired
service(s). Install this package via pip (`pip install git-remote-rclone`), or
place the `git-remote-rclone` executable provided here into the system path,
such that Git can find it. Now it is possible to use URLs like
`rclone://<remote>/<path-on-remote>` as push and pull URLs for Git.

For example, if access to a DropBox account has been configured as an rclone-remote
named `mydropbox`, the URL `rclone://mydropbox/myrepository` identifies a remote
in a directory `myrepository/` under this DropBox account.

## Technical details

At the remote end, `git-remote-rclone` maintains a directory with two files:

- `refs`: a small text file listing the refs provided by the remote
- `repo-<SHA>.tar.gz`: an archive of a bare Git repository

When interacting with a remote, `git-remote-rclone` obtains and extracts a copy
of the remote repository archive (placed at `.git/rclone/<remote-name>` in the
local Git repository). All Git operations are performed locally. Whenever the
state of the mirror repository has changed, it is compacted to minimize transfer
size and uploaded to the remote storage service. Likewise, the remote storage
service is checked for updates before the local mirror repository is updated.

`git-remote-rclone` aims to minimize API usage of remote storage services. Per
invocation, it only queries for the state of a remote repository archive
(checksum), downloads two files (if needed), and uploads two files (if needed,
and on push only).

### Tested with

- `rclone` 1.63.1
- Google Drive
- Onedrive
- DropBox


## Acknowledgements

This work is based on [datalad/git-remote-rclone](https://github.com/datalad/git-remote-rclone/issues). This work changes the
design for compatibility with rclone backends like crypt that do not support file
hashes.
