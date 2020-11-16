```javascript /playable/autoplay/console
//smartdown.import=https://cdn.jsdelivr.net/npm/@solid/query-ldflex@2.7.0/dist/solid-query-ldflex.bundle.js
//smartdown.import=https://unpkg.com/@rdfjs/data-model/dist/rdf-data-model.js
//smartdown.import=https://cdn.jsdelivr.net/npm/solid-auth-client/dist-lib/solid-auth-client.bundle.js

const log = this.log;
const rdf = window.rdf;
const literal = rdf.literal;

const resourceId = 'https://doctorbud.solidcommunity.net/public/scratch/example.ttl';

const x = await solid.data[resourceId]['http://xmlns.com/foaf/0.1/name'];
console.log('solid.data[resourceId]', x + '');

```


