## GitHub CLI
### Install git:
```
apt install git
```
### Install gh:
```
apt install gh
```
### Authorize gh:
1. **Auth login**:
```
gh auth login
```
2. **Auth delete repo**:
```
gh auth refresh -h github.com -s delete_repo
```
3. **Auth admin org**:
```
gh auth refresh -h github.com -s admin:org
```
4. **Auth check status**:
```
gh auth status
```
### Git Config:
```
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```
### Create and Push:
```
gh repo create my-org/example-repo --private
mkdir gh
cd gh
gh repo clone my-org/example-repo
cd example-repo
echo "# My Project" > README.md
echo "# GPLv3" > LICENSE.txt
git add README.md
git rm -r LICENSE
git commit -m "commit"
git push origin main
```
### Org:
1. **List**:
```
gh org list
```
2. **Membership**:
```
gh api /orgs/PythonIsSlowOrg/memberships/USERNAME
```
Return JSON
3. **Invite to org**:
```
gh api \
  -X PUT \
  -H "Accept: application/vnd.github.v3+json" \
  /orgs/ORGNAME/memberships/USERNAME\
  -f role=member
```
Return JSON
### Branch management
1. **Delete a Remote Branch**:
   ```sh
   git push origin --delete <branch-name>
   ```

2. **Delete a Local Branch**:
   ```sh
   git branch -d <branch-name>
   ```

   For force deletion, use:
   ```sh
   git branch -D <branch-name>
   ```

3. **Create a New Branch**:
   ```sh
   git checkout -b <branch-name>
   ```

4. **Switch Branches**:
   ```sh
   git checkout <branch-name>
   ```

5. **List Branches**:
   ```sh
   git branch -a
   ```

6. **Create a Pull Request**:
   ```sh
   gh pr create --base <base-branch> --head <branch-name> --title "<title>" --body "<description>"
   ```
