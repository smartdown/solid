### Smartdown, Solid, and Sparqlines

*Smartdown is a Markdown-compatible language for authoring interactive documents. It resembles Jupyter, but has a version-compatible source format, and requires no server to remain interactive. Good for experimenting with, integrating and discussing other technology*.

Solid complements Smartdown nicely, by providing a *place* and an authentication scheme to enable controlled access (read and write) to this data.

In [Smartdown using Solid via LDFlex](:/public/SolidLDFlex.md), we showed how the LDFlex capability could be used to query RDF data sources in a mostly-obvious pattern. In [LDF Demo](:@/public/SolidLDFlex.md), we see how client-side Sparql libraries can be used to query LDF servers. In [Inline Playables](:@/public/Inlines.md), we showed how any Smartdown playable can be rendered *inline* with its adjacent text in the same way that a Smartdown *cell* would be, enabling [sparklines](https://en.wikipedia.org/wiki/Sparkline), as well as other possibilities.

### List the Beatles

In the first example below, we want to find the members of the Beatles by using the `<http://dbpedia.org/ontology/formerBandMember>` predicate, using `<http://dbpedia.org/resource/The_Beatles>` as subject. We'll also capture the names of the band members via `<http://www.w3.org/2000/01/rdf-schema#label>`, as well as their birth date via `<http://dbpedia.org/ontology/birthDate>`. The results will be displayed in a simple markdown table.

FYI, cdt = *C*omunica *D*BPedia *T*PF in some of the identifiers below, meaning that we are using [Comunica Sparql 1.9.1](https://github.com/comunica/comunica/tree/master/packages/actor-init-sparql#readme), targeting [DBPedia 2016-04](https://fragments.dbpedia.org/2016-04/en), via its [Triple Pattern Fragment](https://linkeddatafragments.org/in-depth/#tpf) endpoint.

We are using Comunica v1.9.1 via [githack.com](https://rawcdn.githack.com/rdfjs/comunica-browser/6e039533038a46155512bc50b5c8a59294a0a0d7/versions/1.9.1/packages/actor-init-sparql-file/comunica-browser.js).


```javascript /playable/autoplay
//smartdown.import=https://rawcdn.githack.com/rdfjs/comunica-browser/6e039533038a46155512bc50b5c8a59294a0a0d7/versions/1.9.1/packages/actor-init-sparql/comunica-browser.js

let query =
`
SELECT ?beatle ?label ?birthDate WHERE {
  <http://dbpedia.org/resource/The_Beatles> <http://dbpedia.org/ontology/formerBandMember> ?beatle .
  ?beatle <http://www.w3.org/2000/01/rdf-schema#label> ?label .
  ?beatle <http://dbpedia.org/ontology/birthDate> ?birthDate .
}
`;

function trace(message, data ) {
  console.log('Comunica trace', message, data);
}

function debug(message, data ) {
  console.log('Comunica debug', message, data);
}

function info(message, data ) {
  console.log('Comunica info', message, data);
}

function warn(message, data ) {
  console.log('Comunica warn', message, data);
}

function error(message, data ) {
  console.log('Comunica error', message, data);
}

function fatal(message, data ) {
  console.log('Comunica fatal', message, data);
}

const logger = {
  trace: trace,
  debug: debug,
  info: info,
  warn: warn,
  error: error,
  fatal: fatal,
};

const httpProxyHandler = {
  getProxy: function getProxy(request) {
    request.input = request.input.replace('http://fragments.dbpedia.org', 'https://fragments.dbpedia.org');
    return request;
  },
};

Comunica.newEngine().query(
  query,
  {
    log: logger,
    httpProxyHandler: httpProxyHandler,
    sources: [
      {
        type: '',
        value: 'https://fragments.dbpedia.org/2016-04/en'
      }
    ]
  })
  .then(function (result) {
    const triples = [];
    result.bindingsStream.on('data', function (data) {
      triples.push({
        id: data.get('?beatle').value,
        label: data.get('?label').value,
        birthDate: data.get('?birthDate').value,
      });
    });
    result.bindingsStream.on('end', function () {
      let table = '\n\n';

      table += '|Beatle|Label|BirthDate|\n';
      table += '|:---|:---|:---|\n';

      triples.forEach(triple => {
        const id = triple.id;
        const label = triple.label;
        const birthDate = triple.birthDate;

        table += `|${id}|${label}|${birthDate}|\n`;
      });
      table += '\n\n\n';

      smartdown.setVariable('cdtTableLength', triples.length);
      smartdown.setVariable('cdtTable', table, 'markdown');
    });
  })
  .catch(function (err) {
    console.log('err', err);
  });
```

- Request Time: [](:!cdtTime)ms.
- Number of Results: [](:!cdtTableLength)rows.

[](:!cdtTable|markdown)

#### Replicating this via other sources

The above example uses the latest (v1.9.1) Comunica Sparql client (`comunica-browser.js`) to query the DBPedia TPF endpoint. The following links perform this same query via different means.

[Direct TPF Query](http://fragments.dbpedia.org/2016-04/en?subject=http%3A%2F%2Fdbpedia.org%2Fresource%2FThe_Beatles&predicate=http%3A%2F%2Fdbpedia.org%2Fontology%2FformerBandMember&object=)

[pre-Comunica Sparql Query](http://client.linkeddatafragments.org/#datasources=http%3A%2F%2Ffragments.dbpedia.org%2F2016-04%2Fen&query=SELECT%20%3Flabel%20WHERE%20%7B%0A%20%20%3Chttp%3A%2F%2Fdbpedia.org%2Fresource%2FThe_Beatles%3E%20%3Chttp%3A%2F%2Fdbpedia.org%2Fontology%2FformerBandMember%3E%20%3Fbeatle%20.%0A%20%20%3Fbeatle%20%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23label%3E%20%3Flabel.%0A%7D)

[Comunica Sparqlx Query](http://query.linkeddatafragments.org/#transientDatasources=http%3A%2F%2Ffragments.dbpedia.org%2F2016-04%2Fen&query=SELECT%20%3Flabel%20WHERE%20%7B%0A%20%20%3Chttp%3A%2F%2Fdbpedia.org%2Fresource%2FThe_Beatles%3E%20%3Chttp%3A%2F%2Fdbpedia.org%2Fontology%2FformerBandMember%3E%20%3Fbeatle%20.%0A%20%20%3Fbeatle%20%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23label%3E%20%3Flabel%20.%0A%7D)

---

The source for this [Smartdown](https://smartdown.io) card is available at https://smartdown.solid.community/public/SolidQueries.md and via [GitHub](https://github.com/smartdown/solid/public/SolidQueries.md).

---

[Back to Home](:@/public/Home.md)





