# git-workshop-2015-08

## Development

### Prerequisites

- [elm](http://elm-lang.org)
- [npm](https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager)
- [gulp](http://gulpjs.com) (`npm install --global gulp`)

### Setting up the project

Clone the repository:

```
git clone https://github.com/bjz/git-workshop-2015-08.git
cd git-workshop-2015-08
```

Install the javascript dependencies:

```
npm install
```

### Running the watcher

```
gulp watch
```

If you edit the pages within `./src`, they will automatically rebuilt to `./tmp` by `gulp-watch`. You can view the resulting website at `./tmp/index.html`.

Press `ctrl + C` to stop watching.

### Deploying to Github Pages

```
gulp deploy
```

