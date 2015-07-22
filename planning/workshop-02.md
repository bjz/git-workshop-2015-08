# Workshop 2: Github

## Quick tour of website

## Workshop

### 1

```
mkdir my_repo
cd my_repo
git init
```

Make a `README.md` file in the root of your repository with `subl README.md`.

```
# My repository!

This is an amazing repo!
```

Now stage the changes and commit.

```
git add README.md
git commit -m "Initial commit"
```

Create a github repository, then add it as a remote and push your commits:

```
git remote add origin <url>
git push
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

## Extension

Additional tasks:

Make an `index.html` page:

```
<head>
  <title>A page!</title>
</head>
<body>
  <p>Hi there!</p>
</body>
```

Do something to make it a github page. :P

## Examples

open source projects
contributor graphs
blame
github issues
milestones for tracking assignment process
