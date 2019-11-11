### Crossword Puzzles via Solid

I've been wanting to add Crossword puzzles to Smartdown, and the idea of using [Solid]() as a way to persist a single-user crossword session and to enable multi-participant crossword puzzles via Solid seemed very easy after my experiments with [SolidLDFlexMutation](:@/public/SolidLDFlexMutation.md). So this weekend in November, 2019, I decided to see how far I could get.

I looked around for existing crossword puzzle Javascript libraries that might be applicable to my needs, and came up with:
- [exolve](https://github.com/viresh-ratnakar/exolve)
- (unused here) [react-crossword](https://github.com/zetter/react-crossword)

I really like the simple UI and vanilla Javascript nature of exolve, so I figured out how to get it to work as a Smartdown Playable via a generic Javascript playable and `smartdown.import`. If things work out, I plan on creating a proper Smartdown plugin for the `exolve` DSL. So the current work below is really a prototype.

My biggest challenge with exolve was to take a bunch of code that assumed it occupied a whole web page, and make it reentrant and isolated so that I could place several crosswords on a page.

#### Basic Crossword

Based on [example with submit.exolve](https://github.com/viresh-ratnakar/exolve/blob/master/example-with-submit.exolve), I removed the Submit and the Questions section.


```javascript /playable/autoplay
//smartdown.import=../exolve/exolve-m.js

const puzzleText = `
======REPLACE WITH YOUR PUZZLE BELOW======
exolve-begin
  exolve-id: example-submit
  exolve-title: Tiny Demo Crossword
  exolve-setter: Exolve
  exolve-width: 5
  exolve-height: 5
  exolve-grid:
    00000
    0...0
    00000
    0...0
    00000
  exolve-across:
    1 Greeting (5)
    3 Earth... but I'm adding a bunch of words to see how really really really really really really really really really really really really really really really really really really really really really really long clues are handled. (5)
    4 Guide (5)
  exolve-down:
    1 Emits cry (5)
    2 More ancient (5)
exolve-end
======REPLACE WITH YOUR PUZZLE ABOVE======
`;

const puzzle = new Puzzle();
const html = puzzle.getHtml();
const css = puzzle.getCSS();
smartdown.importCssCode(css);
this.div.innerHTML = html;
puzzle.createPuzzle(puzzleText);
```

---


#### A Bars and Blocks Example

Based on [example-bars-and-blocks.exolve](https://github.com/viresh-ratnakar/exolve/blob/master/example-bars-and-blocks.exolve), this puzzle contains its solution, so the `Check` and `Reveal` buttons are enabled.

```javascript /playable/autoplay
//smartdown.import=../exolve/exolve-m.js

const puzzleText = `
exolve-begin
  exolve-id: example-bb
  exolve-title: Tiny Crossword With Bars And Blocks
  exolve-setter: Exolve
  exolve-width: 5
  exolve-height: 5
  exolve-grid:
    H E|B O O
    I_. . . L
    W O R L D_
    A . . . O
    S U E|A N 
  exolve-across:
    1 The man (2)
    2 Jeer (3)
    4 Planet (5)
    6 Take legal action against (3)
    7 Article (2)
  exolve-down:
    1 Greeting (2)
    3 Aged (3)
    4 Used to be (3)
    5 Working (2)
exolve-end
`;

const puzzle = new Puzzle();
const html = puzzle.getHtml();
const css = puzzle.getCSS();
smartdown.importCssCode(css);
this.div.innerHTML = html;
puzzle.createPuzzle(puzzleText);
```

#### Next Steps

Utilize Solid's abilities to enable a multi-participant crossword experience, as well as the degenerate case of a single-participant crossword session. I'm thinking of adapting the Solid Long Chat facility for this purpose, as it would enable chat AND crossword and would provide a record of each participants *moves*, which would be nice for a *playback* feature.


---

[Back to Home](:@/public/Home.md)

