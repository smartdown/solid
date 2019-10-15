### Smartdown using Solid via LDFlex

> Smartdown is a Markdown-compatible language for authoring interactive documents. It resembles Jupyter, but has a version-compatible source format, and requires no server to remain interactive. Good for experimenting with, integrating and discussing other technology. Solid complements Smartdown nicely, by providing a *place* to store documents, and an *identity* to enable controlled access (read and write) to this data.

I wanted to try out [query-ldflex](https://github.com/solid/query-ldflex) and see whether it could be useful via Smartdown. So I've adapted the examples from query-ldflex to perform some queries against a specified profile, such as [Ruben Verborgh's](https://ruben.verborgh.org/profile/#me) well-annotated profile, or my own, far less prolific [DoctorBud](https://doctorbud.solid.community/profile/card#me) Solid Community profile.

For this first demonstration, I'm going to list the `friend` and `blogPost` entities that are linked to the target profile. I'm not sure if this is the optimal way to use query-ldflex; I seem to be using a lot more `await` operators than I think should be necessary.

I was unable to figure out how to get the Solid Data Browser to edit my friends list and my blog post list, so I used the Data Browser to edit the RDF source for my [profile](https://doctorbud.solid.community/profile/card), and added entries that constituted a small friends list and a small blog posts list. It seems to work fine.

Because my Solid profile is relatively new, I had to synthesize a *friends* list, so I adopted [Ruben Verborgh](https://ruben.verborgh.org/profile/#me), [Tim Berners-Lee](https://www.w3.org/People/Berners-Lee/card#i), and [Sarven Capadisli](https://csarven.ca/#i) out of convenience; perhaps one day I will actually meet them.

### Demo Demo!

I'm going to use a Smartdown variable called `person` that will be initialized to my profile URL (my WebID):
- https://doctorbud.solid.community/profile/card#me

The following playable will initialize `person` to my WebID and will `dependOn` this variable so that if the reader changes it, the playable will *react* and fetch the new data.

```javascript /playable/autoplay
//smartdown.import=https://cdn.jsdelivr.net/npm/solid-auth-client@2.3.0/dist-lib/solid-auth-client.bundle.js
//smartdown.import=https://cdn.jsdelivr.net/npm/@solid/query-ldflex@2.5.1/dist/solid-query-ldflex.bundle.js

smartdown.setVariable('person', 'https://doctorbud.solid.community/profile/card#me');
smartdown.setVariable('current', 'NotLoggedInToSolid');

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


this.dependOn = ['person'];
this.depend = async function() {
  let personId = env.person;
  smartdown.setVariables([
    {lhs: 'firstName', rhs: '', type: 'string'},
    {lhs: 'friends', rhs: undefined},
    {lhs: 'blogPosts', rhs: undefined},
  ]);


  if (personId === 'NotLoggedInToSolid') {
    return;
  }
  const person = solid.data[personId];
  const firstName = `${await person.vcard_fn}`;
  smartdown.setVariable('firstName', firstName);

  const friends = [];
  for await (const friend of person.friends) {
    friends.push(
    {
      uri: `${await friend}`,
      firstName: `${await friend.firstName}`,
      lastName: `${await friend.lastName}`,
    });
  }
  smartdown.setVariable('friends', friends, 'json');

  const blogPostsQuery = person.blog['schema:blogPost'];
  const blogPosts = [];
  for await (const blogPostQuery of blogPostsQuery) {
    blogPosts.push({
      uri: `${await blogPostQuery}`,
      label: `${await blogPostQuery.label}`,
    });
  }
  smartdown.setVariable('blogPosts', blogPosts, 'json');
};
```

##### The Data

[person](:?person|text)

[DoctorBud](:=person='https://doctorbud.solid.community/profile/card#me')
[Ruben Verborgh](:=person='https://ruben.verborgh.org/profile/#me')
[`current`](:=person=current)

---

[firstName](:!firstName)
[friends](:!friends)
[blogPosts](:!blogPosts)

---

[person](:?person|text)

[DoctorBud](:=person='https://doctorbud.solid.community/profile/card#me')
[Ruben Verborgh](:=person='https://ruben.verborgh.org/profile/#me')
[`current`](:=person=current)

##### A Useless Visualization

Now that we've captured a bunch of useful data into Smartdown variables, let's do a little visualization of that data. For this toy example, we'll just create a pie chart that displays the likely meaningless ratio between the number of friends and the number of blog posts.

Choosing a different user above should cause the data and piechart to be updated.

```plotly/autoplay/playable
const myDiv = this.div;
myDiv.innerHTML = `<h3>Waiting for friends and blogPosts data to be available</h3>`;
this.dependOn = ['blogPosts', 'friends'];
this.depend = function() {
  myDiv.innerHTML = '';
  const friends = env.friends;
  const blogPosts = env.blogPosts;

  var data = [{
    values: [friends.length, blogPosts.length],
    labels: ['Friends', 'Blog Posts'],
    type: 'pie'
  }];

  var layout = {
    margin: {
      t: 0, b: 0, l: 0, r: 0
    },
    height: 300,
    width: 400
  };

  Plotly.newPlot(myDiv, data, layout, {displayModeBar: false});
}

```

---

The source for this [Smartdown](https://smartdown.io) card is available at https://smartdown.solid.community/public/SolidLDFlex.md and via [GitHub](https://github.com/smartdown/solid/public/SolidLDFlex.md).

---

[Back to Home](:@/public/Home.md)

