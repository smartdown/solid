### Crossword Puzzles via Solid

I've been wanting to add Crossword puzzles to Smartdown, and the idea of using [Solid](http://solidproject.org) as a way to persist a single-user crossword session and to enable multi-participant crossword puzzles via Solid. This seemed very plausible after my experiments with [SolidLDFlexMutation](:@/public/SolidLDFlexMutation.md) and [SolidPubSub](:@/public/SolidPubSud.md). I haven't consulted [Solid Chess](https://github.com/pheyvaer/solid-chess) yet, but I think it will come in handy when I need to add niceties like Login, Invite and more restrictive access to a puzzle session.


#### Crossword Puzzles via `exolve` and Smartdown

So I took a little time and evaluated [exolve](https://github.com/viresh-ratnakar/exolve) and I really liked the simple UI and vanilla Javascript nature of exolve. So I hacked it a bit to make it work as a Smartdown Playable via a generic Javascript playable and `smartdown.import`. My biggest challenge with exolve was to take a bunch of code that assumed it occupied a whole web page, and make it reentrant and isolated so that I could place several crosswords on a page. I hacked on [Exolve v0.36 October 22 2019](https://github.com/viresh-ratnakar/exolve/blob/master/CHANGELOG.md#version-exolve-v036-october-22-2019), although the author has already advanced to v0.38 at the time of this writing. The result of my efforts is explorable at [Crosswords](https://smartdown.site/#gallery/Crossword.md)

#### Adding Solid to the Mix

My next step was to learn about using the Websocket-based PubSub mechanism that a Solid server provides. My adventures are partially described in [Solid PubSub](:@/public/SolidPubSub.md). Then I combined the crossword playable with the PubSub playable to create a document (this document) that allows for a crossword puzzle to be played collaboratively, and to have its state reflected in a Solid POD resource.

The following crossword puzzle will save its state to a Solid resource, and will react to that resource changing by updating the display. This is intended to enable collaborative puzzle solving between distributed and asynchronous participants.


#### Basic Crossword

I've added two crossword examples to this page. The first is based on [example basic with solution](https://github.com/viresh-ratnakar/exolve/blob/master/example-basic-with-solution.exolve), although I removed the answers. I also create a *very simple* Solid-oriented puzzle. You can use the buttons below to switch puzzles.


[Use Basic Puzzle](:=PuzzleIndex=0) [Use Solid Puzzle](:=PuzzleIndex=1)

The state of both puzzles is shared via [crossword.ttl](https://doctorbud.solidcommunity.net/public/PubSub/crossword.ttl).

---

```javascript /playable/autoplay
//smartdown.import=/public/exolve/exolve-multi.css
//smartdown.import=/public/exolve/exolve-multi.js
//xsmartdown.import=https://unpkg.com/smartdown-gallery/exolve-multi.css
//xsmartdown.import=https://unpkg.com/smartdown-gallery/exolve-multi.js
//xsmartdown.import=https://localhost:4000/gallery/exolve-multi.css
//xsmartdown.import=https://localhost:4000/gallery/exolve-multi.js



const puzzleText0 = `
exolve-begin
  exolve-id: example-basic
  exolve-title: Smartdown/Solid Crossword Demo
  exolve-setter: DoctorBud
  exolve-width: 5
  exolve-height: 5
  exolve-grid:
    HELLO
    O...L
    WORLD
    L...E
    STEER
  exolve-across:
    1 Greeting (5) Example annotation shown for clue, upon "Reveal all"
    3 Earth (5)
    4 Guide (5)
  exolve-down:
    1 Emits cry (5)
    2 More ancient (5)
  exolve-explanations:
    This text gets shown on clicking "Reveal all" and may include
    explanations, commentary, annotations, etc.
exolve-end
`;


const puzzleText1 = `
exolve-begin
  exolve-id: example-solid
  exolve-title: Smartdown/Solid Crossword
  exolve-setter: DoctorBud
  exolve-width: 6
  exolve-height: 6
  exolve-grid:
    .MIT.I
    W.N..N
    E.RDF.
    B.U..P
    I.P..O
    DATA.D
  exolve-across:
    1 University where Solid originated (3)
    3 Earth with a long long clue with a long long clue with a long long clue with a long long clue with a long long clue with a long long clue with a long long clue with a long long clue (5)
    5 Resource Description Framework (3)
    7 The Solid ___ Browser enables read/write of a user's information. (4)
  exolve-down:
    2 The company supporting the Solid project. (6)
    3 The opposite of out
    4 You authenticate with Solid via your ___ (5)
    6 Your information is in your Solid ___ (3)
exolve-end
`;

const puzzleTexts = [puzzleText0, puzzleText1];

const log = this.log;
let puzzle;


function getBrowser() {
  let type = '';

  if (navigator.userAgent.indexOf('Chrome') != -1 ) {
    type = 'Chrome';
  }
  else if (navigator.userAgent.indexOf('Firefox') != -1 ) {
    type = 'Firefox';
  }
  else if (navigator.userAgent.indexOf('MSIE') != -1 ) {
    type = 'MSIE';
  }
  else if (navigator.userAgent.indexOf('Edge') != -1 ) {
    type = 'Edge';
  }
  else if (navigator.userAgent.indexOf('Safari') != -1 ) {
    type = 'Safari';
  }
  else if (navigator.userAgent.indexOf('Opera') != -1 ) {
    type = 'Opera';
  }

  return type;
}

let player = 'Player-' + getBrowser();
let session = await solid.auth.currentSession();
if (session) {
  player = 'Player-' + session.webId;
}


this.dependOn.RestoreState1 = () => {
  if (env.RestoreState1 &&
      (env.SaveState1 !== env.RestoreState1) &&
      (env.SavePlayer1 !== env.RestorePlayer1)) {
    puzzle.setState(env.RestoreState1);
  }
};


this.dependOn.PuzzleIndex = () => {
  puzzle = new Puzzle();
  this.div.innerHTML = puzzle.getHtml();
  this.div.style.background = 'aliceblue';

  puzzle.createPuzzle(puzzleTexts[env.PuzzleIndex]);
  puzzle.stateChangeListener = (state) => {
    smartdown.setVariable('Errors1', undefined);
    smartdown.setVariable('SavePlayer1', player);
    smartdown.setVariable('SaveState1', state);
  };
  // smartdown.setVariable('EraseSolidResource', true);
};

smartdown.setVariable('PuzzleIndex', 0);

```

---

[](:!Errors1|json)

#### Bind the Crossword State to Solid

This playable will *depend on* the `SaveState1` variable that is mutated when the user changes a letter in the puzzle above. In addition, it will *listen* via a Websocket to the Solid resource at [public/PubSub/crossword.ttl](https://doctorbud.solidcommunity.net/public/PubSub/crossword.ttl) and will reflect any changes back to the above playable via the variable `RestoreState1`. There is no need to make this playable and the state variables visible in a *real* app; I am doing so for *debugging* and *explanation* purposes.

---

[SaveState1](:!SaveState1)
[SavePlayer1](:!SavePlayer1)

[RestorePlayer1](:!RestorePlayer1)
[RestoreState1](:!RestoreState1)

[Erase Solid Resource](:=EraseSolidResource=true)

```javascript /playable/autoplay
//smartdown.import=https://cdn.jsdelivr.net/npm/solid-auth-client/dist-lib/solid-auth-client.bundle.js
//smartdown.import=https://cdn.jsdelivr.net/npm/@solid/query-ldflex@2.7.0/dist/solid-query-ldflex.bundle.js
//smartdown.import=https://unpkg.com/@rdfjs/data-model/dist/rdf-data-model.js

const log = this.log;

const rdf = window.rdf;
const literal = rdf.literal;
const resourceId = 'https://doctorbud.solidcommunity.net/public/PubSub/crossword.ttl';
const wss = 'wss://doctorbud.solidcommunity.net';
let puzzleIndex = env.PuzzleIndex;

async function getStates(resourceId, puzzleIndex) {
  // log('getStates', resourceId, puzzleIndex);
  const resource = solid.data[resourceId];
  const states = [];
  try {
    for await (const state of resource['http://www.w3.org/2000/01/rdf-schema#label']) {
      states.push(state);
    }
    return states
      .filter(node => {
        // DRY this up so the split() isn't duplicated
        let result = false;
        if (node.termType === 'Literal') {
          const stateParts = node.value.split('|');
          result = (stateParts[1] === '' + puzzleIndex);
        }
        return result;
      })
      .map(state => {
        const stateParts = state.value.split('|');
        return {
          timestamp: stateParts[0],
          puzzleIndex: stateParts[1],
          player: stateParts[2],
          board: stateParts[3]
        };
      });
  }
  catch (e) {
    log('getStates exception: ', e);
    debugger;
  }
}


async function addState(resourceId, puzzleIndex, player, state) {
  try {
    // solid.data.clearCache(resourceId);
    const resource = solid.data[resourceId];
    const sequencedLabel = `${(new Date()).toISOString()}|${puzzleIndex}|${player}|${state}`;
    await resource['http://www.w3.org/2000/01/rdf-schema#label'].add(literal(sequencedLabel));
  }
  catch (e) {
    log('addState() exception', typeof e, e, `"${state}"`);
    log('Try again after clearing cache');
    await solid.data.clearCache(resourceId);
    await getStates(resourceId, puzzleIndex);
    await addState(resourceId, puzzleIndex, player, state);
  }
}

this.dependOn.SaveState1 = async () => {
  await addState(resourceId, env.PuzzleIndex, env.SavePlayer1, env.SaveState1);
};

this.dependOn.EraseSolidResource = async () => {
  env.EraseSolidResource = false;
  const resource = solid.data[resourceId];
  '' + (await resource['http://www.w3.org/2000/01/rdf-schema#label'].delete());
};


async function restoreState(resourceId, puzzleIndex) {
  await solid.data.clearCache(resourceId);
  const states = await getStates(resourceId, puzzleIndex);
  if (states && states.length > 0) {
    const newState = states[states.length - 1];

    smartdown.setVariables([
      {lhs: 'RestorePlayer1', rhs: newState.player, type: 'string'},
      {lhs: 'RestoreState1', rhs: newState.board, type: 'string'}]);
  }
}

// Listen to changes via WebSocket
var socket = new WebSocket(wss);

this.dependOn.PuzzleIndex = async () => {
  if (env.PuzzleIndex !== puzzleIndex) {
    puzzleIndex = env.PuzzleIndex;
      await restoreState(resourceId, env.PuzzleIndex);
    }
};

socket.onopen = async function() {
  // log('onopen', puzzleIndex);
  this.send(`sub ${resourceId}`);
  await restoreState(resourceId, puzzleIndex);
};

socket.onmessage = async function(msg) {
  // log('onmessage', puzzleIndex, msg.data);
  if (msg.data && msg.data.slice(0, 3) === 'pub') {
    await restoreState(resourceId, puzzleIndex);
  }
};

```

---

[Back to Home](:@/public/Home.md)

