### Smartdown/Solid Container Navigation

> Smartdown is a Markdown-compatible language for authoring interactive documents. It resembles Jupyter, but has a version-compatible source format, and requires no server to remain interactive. Good for experimenting with, integrating and discussing other technology. Solid complements Smartdown nicely, by providing a *place* to store documents, and an *identity* to enable controlled access (read and write) to this data.

This document is inspired by [Build a Solid App on your Lunch Break](https://solid.inrupt.com/docs/app-on-your-lunch-break); it is an attempt to provide an example of using the *basics* of [Solid](https://www.solidproject.org) interactions, including:

- Detect the currently logged in user (defaults to `smartdown.solid.community`)
- List the contents of a POD folder.

### Use LDFlex to detect the current logged-in user.

I explored [query-ldflex](https://github.com/solid/query-ldflex) a little bit in [Smartdown using Solid via LDFlex](/public/SolidLDFlex.md). In that document, I adapted the examples from query-ldflex to perform some queries against a specified profile, such as [Ruben Verborgh's](https://ruben.verborgh.org/profile/#me) well-annotated profile, or my own, far less prolific [DoctorBud](https://doctorbud.solid.community/profile/card#me) Solid Community profile.

In this Smartdown doc, we are going to use [query-ldflex](https://github.com/solid/query-ldflex) to detect the currently logged in user, and from their profile, obtain that user's `public/` folder URL, and then list the contents and allow simple navigation throughout the visible POD heirarchy.

If you are logged into Solid, the `Logged in Solid User` below should contain your WebID.

- Example User: [Smartdown](:=person='https://smartdown.solid.community/profile/card#me')
- Example User: [DoctorBud](:=person='https://doctorbud.solid.community/profile/card#me')
- Example User: [Ruben Verborgh](:=person='https://ruben.verborgh.org/profile/#me')
- Logged in Solid User: [`current`](:=person=current)
- Try your own WebId: [WebID](:?person|text)

```javascript /playable/autoplay
//smartdown.import=https://cdn.jsdelivr.net/npm/solid-auth-client/dist-lib/solid-auth-client.bundle.js
//smartdown.import=https://cdn.jsdelivr.net/npm/@solid/query-ldflex/dist/solid-query-ldflex.bundle.js

smartdown.setVariable('current', '');
smartdown.setVariable('person', 'https://smartdown.solid.community/profile/card#me');

if (typeof solid.data.user !== 'undefined') {
  (async function() {
    try {
      const current = `${await solid.data.user}`;
      smartdown.setVariable('current', current);
    }
    catch (e) {
      console.log(e);
    }
  })();
}
```

### Find the `/public` folder

The above playable sets a variable `person` that will be initialized to either the WebID of the currently logged in user, or if not logged in, the value `https://smartdown.solid.community/profile/card#me` will be used.

The following playable will `dependOn` this `person` variable so that if a user changes it, the playable will *react* and fetch the new data.

For this playable, we'll get the `pim:storage` value for the person, and will use this to compute a path to the public folder for that user. See [LDFlex Playground](https://solid.github.io/ldflex-playground/#%5B'https%3A%2F%2Fsmartdown.solid.community%2Fprofile%2Fcard%23me'%5D%5B'pim%3Astorage'%5D) for an example of this query.

*Note: I obtained the list of predicates associated with the user via [this query](https://solid.github.io/ldflex-playground/#%5B'https%3A%2F%2Fsmartdown.solid.community%2Fprofile%2Fcard%23me'%5D.predicates)*

```javascript /playable/autoplay
//smartdown.import=https://cdn.jsdelivr.net/npm/solid-auth-client/dist-lib/solid-auth-client.bundle.js
//smartdown.import=https://cdn.jsdelivr.net/npm/@solid/query-ldflex/dist/solid-query-ldflex.bundle.js


this.dependOn = ['person'];
this.depend = async function() {
  let personId = env.person;

  const person = solid.data[personId];

  const storage = person['pim:storage'];
  const public = `${await storage}public/`;
  smartdown.setVariable('public', public);
  return;
};
```

[public](:!public)


### List the Contents of `public/`

We can use ldflex not just to example WebID-based profiles, but to examine any RDF resource that we have access to. We can use the `ldp:contains` predicate to find the contents of our public folder. See the [playground](https://solid.github.io/ldflex-playground/#%5B'https%3A%2F%2Fsmartdown.solid.community%2Fpublic%2F'%5D%5B'ldp%3Acontains'%5D) for this query.

The following playable reacts to changes in the `public` variable and lists the entities that are in an `ldp:contains` relation with the public folder (i.e., the contents).


```javascript /playable/autoplay
this.dependOn = ['public'];
this.depend = async function() {
  const public = env.public;

  if (public.endsWith('../')) {
    const redirect = public.replace(/\/[^/]+\/\.\.\/$/, '/');
    smartdown.setVariable('public', redirect);
    return;
  }

  const contentsMarkdown = [];

  if (!public.endsWith('/public/')) {
    contentsMarkdown.push(`${public} --- [Up](:=public="${public}../")`);
  }

  for await (const p of solid.data[public]['ldp:contains']) {
    const child = (await p.pathExpression)[0].subject.id;

    let controls;
    if (child.endsWith('.md')) {
      const localChild = child;
      // For local testing, adjust paths to use local
      // server...
      // const localChild = child.replace(/^https:\/\/smartdown.solid.community\//, 'https://127.0.0.1:8989/');

      controls = `[${localChild}](${localChild}) --- [Load](:@${localChild})`;
    }
    else if (child.endsWith('/')) {
      controls = `[${child}](${child}) --- [Enter](:=public="${child}")`;
    }
    else {
      controls = `[${child}](${child})`;
    }
    contentsMarkdown.push(`- ${controls}`);
  }

  smartdown.setVariable('contentsMarkdown', contentsMarkdown.join('\n'), 'markdown');
};
```

---

[](:!contentsMarkdown|markdown)

---

The source for this [Smartdown](https://smartdown.io) card is available at https://smartdown.solid.community/public/SolidLDFlexContainer.md and via [GitHub](https://github.com/smartdown/solid/blob/master/public/SolidLDFlexContainer.md).

---

[Back to Home](:@/public/Home.md)

