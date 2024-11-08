## File Management of Termux and Linux
### `cp` (Copy files and directories)
- **Examples**:
  - `cp -r dir1/ dir2/`: Recursively copy `dir1` to `dir2`.
  - `cp -i file1.txt file2.txt`: Prompt before overwriting `file2.txt`.

### `mv` (Move or rename files and directories)
- **Examples**:
  - `mv file1.txt /home/user/`: Move `file1.txt` to `/home/user/`.
  - `mv oldname.txt newname.txt`: Rename `oldname.txt` to `newname.txt`.

### `rm` (Remove files or directories)
- **Examples**:
  - `rm file1.txt`: Remove `file1.txt`.
  - `rm -r dir1/`: Recursively remove `dir1` and its contents.
  - `rm -rf dir1/`: Forcefully remove `dir1` and its contents without prompts.

### `mkdir` (Create directories)
- **Examples**:
  - `mkdir newdir`: Create a directory named `newdir`.
  - `mkdir -p parentdir/childdir`: Create `parentdir` and `childdir` if they don't exist.

### `ls` (List directory contents)
- **Examples**:
  - `ls -l`: List with detailed information (permissions, ownership, size).
  - `ls -a`: List all files, including hidden ones (starting with `.`).
  - `ls -lh`: List with human-readable file sizes.

### `rmdir` (Remove empty directories)
- **Syntax**: `rmdir [options] directory`
- **Examples**:
  - `rmdir emptydir`: Remove `emptydir` if it's empty.
  - `rmdir -p parentdir/childdir`: Remove `childdir` and `parentdir` if they are empty.

### `find` (Search for files and directories)
- **Syntax**: `find [path] [options] [expression]`
- **Examples**:
  - `find /home/user/ -name '*.txt'`: Find all `.txt` files under `/home/user/`.
  - `find . -type d -name 'dir*'`: Find directories starting with `dir`.

### `touch` (Create or update file timestamps)
- **Syntax**: `touch [options] file`
- **Examples**:
  - `touch newfile.txt`: Create an empty `newfile.txt` or update its timestamp.
  - `touch -c non_existent_file.txt`: Don’t create `non_existent_file.txt` if it doesn’t exist.

### `chmod` (Change File Permissions)
`chmod` can use both numeric (octal) and symbolic modes to set file permissions.
#### Numeric (Octal) Mode
- **Syntax**: `chmod [permissions] file`
- **Examples**:
  - `chmod 755 file.txt`: 
    - `7` (rwx) for owner
    - `5` (r-x) for group
    - `5` (r-x) for others
  - `chmod 644 file.txt`:
    - `6` (rw-) for owner
    - `4` (r--) for group
    - `4` (r--) for others
**Numeric Permission Values**:
- `4` = Read (r)
- `2` = Write (w)
- `1` = Execute (x)
- Permissions are additive. For example, `7` = `4` (r) + `2` (w) + `1` (x).
#### Symbolic Mode
- **Syntax**: `chmod [who][+/-][permissions] file`
- **Examples**:
  - `chmod u+x file.txt`: Add execute permission for the user (owner).
  - `chmod g-w file.txt`: Remove write permission for the group.
  - `chmod o=r file.txt`: Set others' permissions to read-only.
**Symbolic Permission Characters**:
- `u` = User (owner)
- `g` = Group
- `o` = Others
- `a` = All (user, group, and others)
- `+` = Add permission
- `-` = Remove permission
- `=` = Set exact permission
#### Options
- `-R` or `--recursive`: Apply changes recursively to directories and their contents.

### `chown` (Change File Ownership)
#### Syntax
- **Syntax**: `chown [options] user[:group] file`
- **Examples**:
  - `chown user file.txt`: Change the owner to `user`.
  - `chown user:group file.txt`: Change the owner to `user` and the group to `group`.
  - `chown :group file.txt`: Change the group to `group` without changing the owner.
#### Options
- `-R` or `--recursive`: Apply changes recursively to directories and their contents.

### `df` (Disk Space Usage)
#### Syntax
- **Syntax**: `df [options] [file]`
- **Examples**:
  - `df -h`: Display disk space in a human-readable format (e.g., MB, GB).
  - `df -T`: Show the filesystem type along with space usage.
  - `df --total`: Show a grand total of all file systems.

### `du` (Disk Usage)
#### Syntax
- **Syntax**: `du [options] [file]`
- **Examples**:
  - `du -h`: Show disk usage in human-readable format.
  - `du -sh /path/to/dir`: Show the total size of `/path/to/dir`.
  - `du -a`: Show the size of all files and directories.
  - `du --max-depth=1`: Limit the depth of directory traversal to 1 level.
