### P5JS

Smartdown integrates the wonderful [P5.js](https://p5js.org/) Javascript library, which provides a way for authors to embed *sketches* within their Smartdown documents.


#### P5JS Ellipse Example


```p5js/playable
p5.setup = function() {
};

p5.draw = function() {
  p5.ellipse(50, 50, 80, 80);
};
```


#### Prefixed vs Global Syntax

Most of the examples at the [p5js.org](https://p5js.org) site are written using the *Global Mode* of p5.js, which means that a sketch can refer to p5.js functions and variables using their Processing-inspired names, such as `ellipse` and `width`. The examples above are written using Smartdown's default *Instance Mode* syntax, which requires that functions are prefixed by `p5.` and that handler callbacks (aka User Functions) are declared like `p5.setup = function() {...}` rather than the Global Mode syntax `function setup {...}`.

The Global Mode syntax is experimental in Smartdown currently, and can be accessed by using the playable language `P5JS` instead of the well-supported default `p5js`. When using the `P5JS` language, sketch authors should be able to copy and paste most of the Global Mode examples of p5.js.


##### Tickle example with Instance mode Syntax

```p5js/playable
var message = "tickle",
  font,
  bounds, // holds x, y, w, h of the text's bounding box
  fontsize = 60,
  x, y; // x and y coordinates of the text

p5.preload = function preload() {
  console.log('old:', smartdown.baseURL + 'gallery/resources/SourceSansPro-Regular.otf');
  console.log('new:', 'https://unpkg.com/smartdown-gallery/resources/SourceSansPro-Regular.otf');
  font = p5.loadFont('https://unpkg.com/smartdown-gallery/resources/SourceSansPro-Regular.otf');
};

p5.setup = function setup() {
  p5.createCanvas(410, 250);

  // set up the font
  p5.textFont(font);
  p5.textSize(fontsize);

  // get the width and height of the text so we can center it initially
  bounds = font.textBounds(message, 0, 0, fontsize);
  x = p5.width / 2 - bounds.w / 2;
  y = p5.height / 2 - bounds.h / 2;
};

p5.draw = function draw() {
  p5.background(204, 120);

  // write the text in black and get its bounding box
  p5.fill(0);
  p5.text(message, x, y);
  bounds = font.textBounds(message,x,y,fontsize);

  // check if the mouse is inside the bounding box and tickle if so
  if ( p5.mouseX >= bounds.x && p5.mouseX <= bounds.x + bounds.w &&
    p5.mouseY >= bounds.y && p5.mouseY <= bounds.y + bounds.h) {
    x += p5.random(-5, 5);
    y += p5.random(-5, 5);
  }
};
```

##### Tickle example with Global mode Syntax

```P5JS/playable
var message = "tickle",
  font,
  bounds, // holds x, y, w, h of the text's bounding box
  fontsize = 60,
  x, y; // x and y coordinates of the text

function preload() {
  font = loadFont('https://unpkg.com/smartdown-gallery/resources/SourceSansPro-Regular.otf');
}

function setup() {
  createCanvas(410, 250);

  // set up the font
  textFont(font);
  textSize(fontsize);

  // get the width and height of the text so we can center it initially
  bounds = font.textBounds(message, 0, 0, fontsize);
  x = width / 2 - bounds.w / 2;
  y = height / 2 - bounds.h / 2;
}

function draw() {
  background(204, 120);

  // write the text in black and get its bounding box
  fill(0);
  text(message, x, y);
  bounds = font.textBounds(message,x,y,fontsize);

  // check if the mouse is inside the bounding box and tickle if so
  if ( mouseX >= bounds.x && mouseX <= bounds.x + bounds.w &&
    mouseY >= bounds.y && mouseY <= bounds.y + bounds.h) {
    x += random(-5, 5);
    y += random(-5, 5);
  }
}
```

---

The source for this [Smartdown](https://smartdown.io) card is available at https://smartdown.solid.community/public/P5JS.md and via [GitHub](https://github.com/smartdown/solid/public/P5JS.md).

---

[Back to Home](:@/public/Home.md)

