# Workshop 2: Github

## Quick tour of website

## Workshop

### 1

Add new repository on github

```
cd ~/code
mkdir my_repo
cd my_repo
git init
echo "# my_repo" > README.md
git add README.md
git commit -m "Initial commit"
git remote add origin <url>
```

### 2

For repository
Copy repo URL

```
git pull <fork-url>
git checkout -b add-personal-file
```

Add a file with name eg. `brendan.html`

```
git add .
git commit -m "Add personal file"
git push
```

Make a new PR, targeting main repo, with a message

## Examples

open source projects
contributor graphs
blame
github issues
milestones for tracking assignment process
