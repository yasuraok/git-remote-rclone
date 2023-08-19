#!/usr/bin/env python3

import hashlib
from pathlib import Path

# compute sha for repo.7z file in current directory
repo_file = Path("repo.7z")
repo_hash = hashlib.sha1(repo_file.read_bytes()).hexdigest()
print(repo_hash)
