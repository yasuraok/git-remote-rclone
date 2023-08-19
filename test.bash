#!/usr/bin/bash
set -eo pipefail

REMOTE=grrtest
TESTDIR=~/TESTDIR
TESTDIR2=~/TESTDIR2

# test init: clear remote and local
rclone delete -v "${REMOTE}:"
rm -fr $TESTDIR
mkdir -p $TESTDIR
cd $TESTDIR

# create and push a new repo
git init .
date > testfile
git add testfile
git commit -m "Initial commit."

git remote add origin rclone://$REMOTE/
git push --set-upstream origin main

# push, no updates
git push origin main
git push origin main

# push new update
date > secondfile
git add secondfile
git commit -m "Second commit."
git push origin main

# pull update
git reset --hard HEAD~
git log
git pull --rebase

# pull, no updates
git pull --rebase

# push, no updates
git push origin main

# create new branch and push

# push from new branch, no updates

# test checkpoint: cat refs
rclone cat $REMOTE:refs

# test checkpoint: clone fresh from remote
rm -fr $TESTDIR2
mkdir -p $TESTDIR2
cd $TESTDIR2
git clone rclone://$REMOTE/ .
