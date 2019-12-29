### Welcome to DoctorBud's Smartdown-on-Solid POD

I've modified the default `databrowser.html` for my POD's `/public` folder so that it supports the following features:

- Slightly more compact CSS and responsivity for the default `sourcePane` and toolbar.
- Modifies the default `humanReadablePane` so detect `.md` file extension and render the Markdown via Smartdown.
- Adds ability to create and edit Markdown files (with `.md` file extension).
- Adds ability to *focus* the data browser on a particular subtree, including leaf nodes such as `.txt` and `.md` files, while retaining the data browser's editing controls and menu buttons.


#### Design Constraints

- Should be deployable on existing community servers.
- Should NOT require a rebuild of mashlib.
- Should support Smartdown, with optional downgrade to Markdown.


#### Strategy

- Copy default `databrowser.html` to `databrowser_with_markdown.html`.
- Define three new pane types:
	- Markdown-aware `humanReadablePane` which can render Markdown
	- Markdown editor `markdownPane` which can edit Markdown and save back to the POD.
	- A `browse1Pane` which adds a toolbar button and allows for the data browser to *focus* on a particular subtree or leaf node.
- Add a URL argument `browse1=<url>` which indicates that the data browser should be *focused* on `<url>`.


#### Plain Ole Smartdown Demos

- [P5JS](:@https://doctorbud.solid.community/public/P5JS.md)
- [Mobius](:@https://doctorbud.solid.community/public/Mobius.md)
- [D3](:@https://doctorbud.solid.community/public/D3.md)

#### Relative tunnels with `/public/` and `.md`

- [P5JS](:@/public/P5JS.md)
- [Mobius](:@/public/Mobius.md)
- [D3](:@/public/D3.md)

#### Relative tunnels with `public/` and `.md`

- [P5JS](:@public/P5JS.md)
- [Mobius](:@public/Mobius.md)
- [D3](:@public/D3.md)

#### Relative tunnels without `public/`, with `.md`

- [P5JS](:@P5JS.md)
- [Mobius](:@Mobius.md)
- [D3](:@D3.md)

#### Relative tunnels without `public/` or `.md`

- [P5JS](:@P5JS)
- [Mobius](:@Mobius)
- [D3](:@D3)

#### Experiments with Solid and no Smartdown

I wrote these in vanilla HTML to test performance and do some debugging without worry of Smartdown affecting my measurements.

- [PubSubWithSet](https://doctorbud.solid.community/public/PubSubWithSet.html)
- [PubSubWithAdd](https://doctorbud.solid.community/public/PubSubWithAdd.html)


#### Demos from smartdown.solid.community

I try to keep the `doctorbud.solid.community` examples and experiments separate from the `smartdown.solid.community` ones, although there is some duplication. I have not (yet) verified that all of the examples at [smartdown.solid.community](https://smartdown.solid.community/public/) are compatible with my modifications to `databrowser.html`.

- [smartdown.solid.community](https://smartdown.solid.community/public/smartdown/#/public/Home.md)
- [Querying Solid in Smartdown with Comunica](https://smartdown.solid.community/public/smartdown/#/public/SolidQueries.md)
- [Smartdown using Solid via LDFlex](https://smartdown.solid.community/public/smartdown/#/public/SolidLDFlex.md)
- [Smartdown/Solid Container Navigation](https://smartdown.solid.community/public/smartdown/#/public/SolidLDFlexContainer.md)
- [Creating, Modifying, Deleting Solid Objects in Smartdown](https://smartdown.solid.community/public/smartdown/#/public/SolidLDFlexMutation.md)
- [Smartdown/Solid PubSub](https://smartdown.solid.community/public/smartdown/#/public/SolidPubSub.md)
- [Smartdown/Solid Crosswords](https://smartdown.solid.community/public/smartdown/#/public/SolidCrossword.md)


---

This document is sourced from https://doctorbud.solid.community/public/Home.md which may be viewed using `browse1Pane` via:

https://doctorbud.solid.community/public/?browse1=https://doctorbud.solid.community/public/Home.md

but may be rendered via a different Smartdown viewer within another site.
