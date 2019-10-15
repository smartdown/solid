# Smartdown on Solid, Solid in Smartdown

> Smartdown is like cheese. You can put it in stuff, and you can put stuff in it.
>
> -- Dan Keith, 2018

This repository is a tree of mostly Smartdown documents, and a pair of scripts to publish this tree to either a Solid POD or a GitHub Pages site.

- The target POD: [https://smartdown.solid.community/](https://smartdown.solid.community/)
- The target GHPages site: [https://smartdown.github.io/solid/](https://smartdown.github.io/solid/)
- More on Solid here: [https://www.solidproject.org](https://www.solidproject.org)
- More on Smartdown here: [https://smartdown.io](https://smartdown.io)

**These docs are partial, but may be helpful.**

### Installing Smartdown for Solid

The installation has been tested for the following configuration:

- Markdown/Smartdown files placed in `/public/`
- A `/public/Home.md` file
- Files suffixed with `.md`
- A folder named `smartdown/` placed in `/public/smartdown/`
- An `index.html` placed in `/public/smartdown/index.html`

### Publish to Solid with a Script: publishToSolid.sh

I wrote a `publishToSolid.sh` script that uses `curl` to upload relevant files to the https://smartdown.solid.community site. For security purposes, the `publishToSolid.connect.sid` file is NOT placed in Git, and it should be customized with your particular `connect.sid` value as per the instructions [here](https://github.com/megoth/solid-update-index-tutorial).

In addition, if you adapt `publishToSolid.sh` for your own purposes, you will want to edit the line beginning with `export base=`.


### Publish to GitHub Pags with a Script: publishToGitHub.sh

I wrote a `publishToGitHub.sh` script that creates a `dist/` directory, populates it with a heirarchy of files, and then pushes the tree to GitHub in a `gh-pages` branch. GitHub will then serve up these files via `https://smartdown.github.io/solid/`.


