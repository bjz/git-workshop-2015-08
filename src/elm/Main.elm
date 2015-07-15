import Array
import History
import Html exposing (Html)
import Keyboard
import Markdown
import Signal exposing ((<~), (~))
import String
import Task exposing (Task)

import SlideShow exposing (SlideShow)

-- Presentation

parseMarkdown =
  Markdown.toHtmlWith
    { githubFlavored = Just { tables = True, breaks = True }
    , sanitize = False
    , smartypants = False
    }

slides =
  src
    |> String.split "---"
    |> List.map parseMarkdown

src = """

# Git

---

So, you're working on a project:

```
my_project
└── main.c
```

---

Now you make some changes, but you don't want to overwrite your old file because
you want to look back on it later:

```
my_project
├── main.c
└── main_2.c
```

---

Before long:

```
my_project
├── main.c
├── main_2.c
└── main_3.c
```

---

Now lets say you want to test something:

```
my_project
├── main.c
├── main_2.c
├── main_3.c
├── main_test_3.c
├── main_test_4.c
└── main_test_4b.c
```

---

Programmers have had a solution to this for decades.

---

Git is a version control system that you can run from the terminal.

There are GUIs available for it, but I think it is important to learn it from
the command line first.

This has the added benefit of making you look like a wizard in front of your
friends.

---

### Starting a git repository

In a new directory:

```
git init
```

This will initialize a new repository in that directory.

---

### Staging changes

You might have made a change to a file:

```
  function hi() {
-   console.log("hi");
+   console
  }
```

```
git add <file-name>
git add .
```

---

### Committing changes

```
git commit -m "Commit message"
```

Each commit comes with:

  - an identification code
  - a message
  - a date
  - the committer's name and email address

---

### Checking the state of a repository

```
git status
```

```
git log
```

```
git log --graph --decorate
```

---

### Branching

---

### Merging

---

## Working with remote repositories

---

### Cloning a repository

```
git clone <path>
```

This can be a repository in your file system, or one from a remote server.

---

### Pushing to a remote

```
git push
```


---

### Common workflows

```bash
mkdir my_project
cd my_project
git init
echo 'This is my git repository!' > README.md
git add README.md
git commit -m 'Initial commit'
```

---

```
$ git init my_project
$ cd my_project
$ git add .
$ git commit -m "Initial commit"
```

---

# Git grows with you

---

Add changes peice by peice:

```
$ git add -p README.md
```

Render an ASCII history graph:

```
$ git log --graph --decorate --abbrev-commit \\
   --all --pretty=oneline
```

Rewrite your history interactively:

```
$ git rebase -i HEAD~3
```

"""

-- Routing

port initialHash : String

hashToInt : String -> Maybe Int
hashToInt =
  String.dropLeft 1 -- Drop the preceding '#'
    >> String.toInt
    >> Result.toMaybe

makeHash slideShow =
  "#" ++ toString slideShow.currentIndex

port runTask : Signal (Task error ())
port runTask =
  History.setPath <~ (makeHash <~ slideShows)

makeTitle slideShow =
  "Git Tutorial Presentation (slide " ++ toString slideShow.currentIndex ++ ")"

port title : Signal String
port title =
  makeTitle <~ slideShows

-- Update

update : Action -> SlideShow -> SlideShow
update action =
  case action of
    NoOp       -> identity
    Navigate f -> f

-- View

view : SlideShow -> Html
view = SlideShow.toHtml

-- Input

type Action
  = NoOp
  | Navigate SlideShow.Update

keysToAction : { x : Int, y : Int } -> Action
keysToAction keys =
  if | keys.x > 0 -> Navigate SlideShow.gotoNext
     | keys.x < 0 -> Navigate SlideShow.gotoPrevious
     | otherwise  -> NoOp

hashToAction : String -> Action
hashToAction hash =
  case hashToInt hash of
    Just index -> Navigate (SlideShow.gotoIndex index)
    Nothing    -> NoOp

input : Signal Action
input =
    Signal.mergeMany
      [ hashToAction <~ Signal.dropRepeats History.hash
      , keysToAction <~ Keyboard.arrows
      ]

slideShows : Signal SlideShow
slideShows =
  Signal.foldp update slideShow input |> Signal.dropRepeats

-- Main

slideShow : SlideShow
slideShow =
  SlideShow.new
    (slides |> Array.fromList)
    (hashToInt initialHash |> Maybe.withDefault 0)

main : Signal Html
main =
  view <~ slideShows
