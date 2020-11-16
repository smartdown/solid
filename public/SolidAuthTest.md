### Solid Authorization Test

There is a folder at [https://doctorbud.solidcommunity.net/public/scratch2/](https://doctorbud.solidcommunity.net/public/scratch2/) whose ACL looks like this:

```

@prefix : <#>.
@prefix n0: <http://www.w3.org/ns/auth/acl#>.
@prefix scr: <./>.
@prefix c: </profile/card#>.
@prefix n1: <http://xmlns.com/foaf/0.1/>.

:ControlReadWrite
    a n0:Authorization;
    n0:accessTo scr:;
    n0:agent c:me;
    n0:default scr:;
    n0:mode n0:Control, n0:Read, n0:Write.
:Read
    a n0:Authorization;
    n0:accessTo scr:;
    n0:agentClass n1:Agent;
    n0:default scr:;
    n0:mode n0:Read.
:ReadWrite
    a n0:Authorization;
    n0:accessTo scr:;
    n0:default scr:;
    n0:mode n0:Read, n0:Write;
    n0:origin <https://127.0.0.1:8989>, <https://smartdown.solidcommunity.net>.

```

The last clause above indicates that both:
- https://127.0.0.1:8989
- https://smartdown.solidcommunity.net

are in the ReadWrite category. This should allow requests from these origins to perform read and write operations on `/scratch2` and its contents. For the example below, we are going to try to create `example.ttl` as a resource within `/scratch2` by using `solid.auth.fetch()`.

This doesn't appear to work and write requests are rejected with a `403 - Origin Unauthorized` error.

Similarly,

#### Check current login status

This autoplay playable will use solid-auth-client to determine
whether `solid.data.user` is defined, and if so, it will set the Smartdown variable `current` to the current user's webID.

[Current](:!current)

```javascript /playable/autoplay/console
//smartdown.import=https://cdn.jsdelivr.net/npm/solid-auth-client/dist-lib/solid-auth-client.bundle.js

smartdown.setVariable('current', 'NotLoggedInToSolid');
let session = await solid.auth.currentSession();
if (session) {
  smartdown.setVariable('current', session.webId);
}
```


#### Logout existing user

```javascript /playable/xautoplay/console
//smartdown.import=https://cdn.jsdelivr.net/npm/solid-auth-client/dist-lib/solid-auth-client.bundle.js

let session = await solid.auth.currentSession();
if (session) {
  solid.auth.logout();
  smartdown.setVariable('current', 'NotLoggedInToSolid');
}
```


#### Authenticate via Popup

```javascript /playable/xautoplay/console
//smartdown.import=https://cdn.jsdelivr.net/npm/solid-auth-client/dist-lib/solid-auth-client.bundle.js

var that = this;
async function popupLogin() {
  let session = await solid.auth.currentSession();
  let popupUri = 'https://solidcommunity.net/common/popup.html';
  if (!session)
    session = await solid.auth.popupLogin({ popupUri });
    that.log(`Logged in as ${session.webId}`);
    smartdown.setVariable('current', session.webId);
}
const result = popupLogin();

that.log(JSON.stringify(result, null, 2));
```



#### Create new resource

```javascript /playable/xautoplay/console
//smartdown.import=https://cdn.jsdelivr.net/npm/solid-auth-client/dist-lib/solid-auth-client.bundle.js

const resourceId = 'https://doctorbud.solidcommunity.net/public/scratch2/example.ttl';

async function createEmptyDocument(location) {
  const options = {
    body: '',
    // Make sure to include credentials with the request, set by solid-auth-client:
    credentials: 'include',
    headers: {
      'Content-Type': 'text/turtle'
    },
    method: 'PUT',
  };
  const response = await solid.auth.fetch(location, options);


  return {
    status: response.status,
    statusText: response.statusText,
    url: response.url,
  };
};

const result = await createEmptyDocument(resourceId);
console.log('result', result);
smartdown.setVariable('CreationResult', result);

```

[Creation Result](:!CreationResult|json)


#### Delete existing resource

```javascript /playable/xautoplay/console
//smartdown.import=https://cdn.jsdelivr.net/npm/solid-auth-client/dist-lib/solid-auth-client.bundle.js

const resourceId = 'https://doctorbud.solidcommunity.net/public/scratch2/example.ttl';

async function deleteDocument(location) {
  const options = {
    body: '',
    // Make sure to include credentials with the request, set by solid-auth-client:
    credentials: 'include',
    headers: {
      'Content-Type': 'text/turtle'
    },
    method: 'DELETE',
  };
  const response = await solid.auth.fetch(location, options);
  return {
    status: response.status,
    statusText: response.statusText,
    url: response.url,
  };
};

const result = await deleteDocument(resourceId);
console.log('result', result);
smartdown.setVariable('DeletionResult', result);


```

[Deletion Result](:!DeletionResult|json)


### Add some edges to our object

```javascript /playable/xautoplay/console
//smartdown.import=https://cdn.jsdelivr.net/npm/@solid/query-ldflex@2.5.1/dist/solid-query-ldflex.bundle.js
//smartdown.import=https://unpkg.com/@rdfjs/data-model@1.1.2/dist/rdf-data-model.js

// The above smartdown.import statements mimic:
//  import data from "@solid/query-ldflex";
//  import { literal } from "@rdfjs/data-model";
//

const rdf = window.rdf;
const literal = rdf.literal;
// console.log(Object.keys(rdf));

async function setName(resourceId, name) {
  const resource = solid.data[resourceId];
  await resource['http://xmlns.com/foaf/0.1/name'].add(literal(name));
  await resource['http://www.w3.org/2000/01/rdf-schema#label'].add(literal(name));
}

async function setNicknames(resourceId, nicknames) {
  const resource = solid.data[resourceId];
  await resource['http://xmlns.com/foaf/0.1/nick'].set(...nicknames.map(nickname => literal(nickname)));
}

const resourceId = 'https://doctorbud.solidcommunity.net/public/scratch2/example.ttl';
const nicknames = [
  'that guy',
  'bud',
  'doctorbud',
  'dan',
  'dad',
  'frodo',
  'bilbo',
  'A really really really long nickname',
];

await setName(resourceId, 'Dan Keith');
await setNicknames(resourceId, nicknames);
```


---

[Back to Home](:@/public/Home.md)

