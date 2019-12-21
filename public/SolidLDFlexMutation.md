### Creating, Modifying, Deleting Solid Objects

In [Smartdown using Solid via LDFlex](:@/public/SolidLDFlex.md) and [Smartdown/Solid Container Navigation](:@/public/SolidLDFlexContainer.md) we explored some of the *read-only* possibilities using Smartdown, Solid, Sparql, and LDFlex. Here in this document, we'll look at the possibilities and mechanisms we can use to perform the other CRUD operations.

In theory, any person viewing this document via https://smartdown.solid.community should be able to perform the operations of Deleting, Creating, and Adding edges to the resource [/public/scratch/example.ttl](https://doctorbud.solid.community/public/scratch/example.ttl). This is because I adjusted the ACL for `/public/scratch` to so that https://smartdown.solid.community is considered an Owner (in the `:ReadWriteControl` category of the `.acl`), with Read, Write and Control permissions.

##### References

- [solid-auth-client](https://github.com/solid/solid-auth-client)
- [tripledoc cheatsheet](https://vincenttunru.gitlab.io/tripledoc/docs/cheatsheet#ldflex-7)
- [Using the Fetch API](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API/Using_Fetch)


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
  let popupUri = 'https://solid.community/common/popup.html';
  if (!session)
    session = await solid.auth.popupLogin({ popupUri });
    that.log(`Logged in as ${session.webId}`);
    smartdown.setVariable('current', session.webId);
}
const result = popupLogin();

that.log(JSON.stringify(result, null, 2));
```


#### Authenticate via Redirect

This technique avoids the display of a popup, and instead redirects (if necessary) to the identity provider's page, where the user can log in. Upon a successful login, the browser will be directed back to this Smartdown page, where the user can exercise the subsequent playables on this page.

```javascript /playable/xautoplay/console
//smartdown.import=https://cdn.jsdelivr.net/npm/solid-auth-client/dist-lib/solid-auth-client.bundle.js

var that = this;

async function login(idp) {
  const session = await solid.auth.currentSession();
  // The terminal / is necessary for /login redirect to work on
  // solid.community. It's not necessary for local dev (but works fine).
  // Beware of removing the slash.
  //
  let callback = window.location.origin + '/public/login/';
  if (window.location.origin === 'https://smartdown.github.io') {
    callback = window.location.origin + '/solid/public/login/'
  }

  const loginOptions = {
    callbackUri: callback,
    // clientName?: string,
    // contacts?: Array<string>,
    // logoUri?: string,
    // popupUri: string,
    // storage: AsyncStorage
  };

  if (!session) {
    await solid.auth.login(idp, loginOptions);
  }
  else {
    that.log(`Logged in as ${session.webId}`);
    smartdown.setVariable('current', session.webId);
  }
}

const result = login('https://doctorbud.solid.community');
this.log(JSON.stringify(result, null, 2));
```



#### Delete existing resource

```javascript /playable/xautoplay/console
//smartdown.import=https://cdn.jsdelivr.net/npm/solid-auth-client/dist-lib/solid-auth-client.bundle.js

const resourceId = 'https://doctorbud.solid.community/public/scratch/example.ttl';

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


#### Create new resource

```javascript /playable/xautoplay/console
//smartdown.import=https://cdn.jsdelivr.net/npm/solid-auth-client/dist-lib/solid-auth-client.bundle.js

const resourceId = 'https://doctorbud.solid.community/public/scratch/example.ttl';

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


### Add some edges to our object

```javascript /playable/xautoplay/console
//smartdown.import=https://cdn.jsdelivr.net/npm/@solid/query-ldflex@2.7.0/dist/solid-query-ldflex.bundle.js
//smartdown.import=https://unpkg.com/@rdfjs/data-model/dist/rdf-data-model.js

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

const resourceId = 'https://doctorbud.solid.community/public/scratch/example.ttl';
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

#### View the final result

The resulting `example.ttl` file is visible via [https://doctorbud.solid.community/public/scratch/example.ttl](https://doctorbud.solid.community/public/scratch/example.ttl)

or via the [LDFlex Playground](https://solid.github.io/ldflex-playground/#%5B'https%3A%2F%2Fdoctorbud.solid.community%2Fpublic%2Fscratch%2Fexample.ttl'%5D%5B'http%3A%2F%2Fxmlns.com%2Ffoaf%2F0.1%2Fnick'%5D)

---

[Back to Home](:@/public/Home.md)

