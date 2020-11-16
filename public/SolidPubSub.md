### Solid PubSub via Websocket

This document will explore the mechanisms in Solid that will enable a resource to be modified, and for modifications to a resource to be *watched* via a Websocket. This is key to enabling communication between two or more users via a Solid POD.

- [Solid WebSockets API Spec](https://github.com/solid/solid-spec/blob/master/api-websockets.md)


#### Test1

From [Subscribing](https://github.com/solid/solid-spec/blob/master/api-websockets.md#subscribing), I've adapted the example:

> Here is a Javascript example on how to subscribe to live updates for a test resource at https://example.org/data/test:

```javascript
socket.onopen = function() {
  this.send('sub https://example.org/data/test');
};
socket.onmessage = function(msg) {
  if (msg.data && msg.data.slice(0, 3) === 'pub') {
        // resource updated, refetch resource
  }
};
```

The following playable uses as its target the resource
- https://doctorbud.solidcommunity.net/public/PubSub/state.ttl

```javascript /playable/autoplay/console
//smartdown.import=https://cdn.jsdelivr.net/npm/solid-auth-client/dist-lib/solid-auth-client.bundle.js
//smartdown.import=https://cdn.jsdelivr.net/npm/@solid/query-ldflex@2.7.0/dist/solid-query-ldflex.bundle.js
//smartdown.import=https://unpkg.com/@rdfjs/data-model/dist/rdf-data-model.js

const log = this.log;
const rdf = window.rdf;
const literal = rdf.literal;
const resourceId = 'https://doctorbud.solidcommunity.net/public/PubSub/state.ttl';


async function getLabel(resourceId) {
  return await solid.data[resourceId]['http://www.w3.org/2000/01/rdf-schema#label'];
}

async function setLabel(resourceId, label) {
  try {
    const resource = solid.data[resourceId];
    log('setLabel', typeof label, label);
    await resource['http://www.w3.org/2000/01/rdf-schema#label'].set(literal(label));
  }
  catch (e) {
    log('setLabel() exception', label, e);
  }
}

async function restoreState(resourceId) {
  await solid.data.clearCache(resourceId);
  let label = await getLabel(resourceId);
  if (typeof label === 'undefined') {
    label = 'X';
  }
  else {
    label = '' + label;
  }
  log('Label Actual: ', label);
  smartdown.setVariable('LabelActual', label);
}

var socket = new WebSocket('wss://doctorbud.solidcommunity.net');

socket.onopen = async function() {
  log('onopen');
  this.send(`sub ${resourceId}`);
  await restoreState(resourceId);
};

socket.onmessage = async function(msg) {
  log('onmessage', msg.data);
  if (msg.data && msg.data.slice(0, 3) === 'pub') {
    await restoreState(resourceId);
  }
};

smartdown.setVariable('LabelSend', false);

this.dependOn.LabelSend = async () => {
  if (env.LabelSend) {
    env.LabelSend = false;
    log('Label Intended: ' + env.Label);
    if (env.Label) {
      await setLabel(resourceId, env.Label);
    }
    else {
      log('dependOn ignore undefined Label');
    }
  }
};

// await restoreState(resourceId);

// Make sure any await ops are AFTER the setting of this.dependOn
// Because async is weird, and Smartdown needs to register the dependencies
// upon return from the playable's initial invocation.
//

const label = await getLabel(resourceId) + '';
smartdown.setVariable('Label', label);
smartdown.setVariable('LabelActual', label);

```

#### Edit the Label

- New Label: [](:?Label) [Update](:=LabelSend=true)

[Label Actual](:!LabelActual)

#### View the Resource

The resulting `example.ttl` file is visible via [https://doctorbud.solidcommunity.net/public/PubSub/state.ttl](https://doctorbud.solidcommunity.net/public/PubSub/state.ttl)

or via the [LDFlex Playground](https://solid.github.io/ldflex-playground/#%5B'https%3A%2F%2Fdoctorbud.solidcommunity.net%2Fpublic%2Fscratch%2Fexample.ttl'%5D%5B'http%3A%2F%2Fxmlns.com%2Ffoaf%2F0.1%2Fnick'%5D)


---

The source for this [Smartdown](https://smartdown.io) card is available at https://smartdown.solidcommunity.net/public/SolidPubSub.md and via [GitHub](https://github.com/smartdown/solid/blob/master/public/SolidPubSub.md).

---

[Back to Home](:@/public/Home.md)

