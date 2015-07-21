# Workshop 1: Git

## Intro to version control

Most common workflow:

1. create
2. edit
3. save
4. goto 2

```
            +------+          +--------------+
O- create ->| File |-- edit ->| Altered file |
            +------+          +--------------+
               ^                      |
               |                      |
               +-------- save --------+

```

## Workshop

### Initialise a new repository

```bash
git init playground_repo
cd playground_repo
```

```bash
subl README.md
```

### Stage a new file

Enter some text. For example:

```md
# A playground repository

This is a playground for messing around with git.
```

```bash
git add README.md
```

### Commit the file

```
git commit -m "Initial commit"
```

## Some commands to explore

```
git rebase -i HEAD~3
```
