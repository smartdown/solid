/* global smartdown */
/* global window */
/* global document */
/* global smartdownBaseURL */
/* global smartdownDefaultHome */
/* global smartdownResourceURL */
/* global smartdownRawPrefix */
/* global smartdownOutputDivSelector */
/* global smartdownPostLoadMutator */
/* global smartdownMedia */
/* global XMLHttpRequest */
/* eslint no-var: 0 */

/**
 * A convenient way to initialize Smartdown with common defaults.
 *
 * Although smartdown.configure() can be used directly by certain applications,
 * for many of the common Smartdown examples, this starter.js file can be used
 * to invoke smartdown.configure() with credible default behavior, and the ability
 * to customize this behavior to a reasonable degree.
 *
 * @param {object} [basePrefix=undefined] - Configuration options
 *
 * @example
 * // Use the smartdown/starter.js convenience wrapper to initialize smartdown.
 * // See smartdown/src/SimpleSiteExample/ for usage within an index.html.
 * <script src="lib/starter.js">< /script>
 * <script>
 *   window.smartdownResourceURL = '';
 *   window.smartdownBaseURL = '/';
 *   window.smartdownStarter();
 * < /script>
 */

function smartdownStarter(basePrefix, relativeCardLoader, doneHandler) {
  var defaultHome = 'Home';
  var baseURL = 'https://https://smartdown.github.io/smartdown/';
  var resourceURL = baseURL + 'lib/resources/';
  var rawPrefix = window.location.origin + window.location.pathname;
  var outputDivSelector = '#smartdown-output';
  var postLoadMutator = null;
  var adjustHash = true;
  var media = {
    cloud: '/gallery/resources/cloud.jpg',
    badge: '/gallery/resources/badge.svg',
    hypercube: '/gallery/resources/Hypercube.svg',
    StalactiteStalagmite: '/gallery/resources/StalactiteStalagmite.svg',
    church: '/gallery/resources/church.svg',
    lighthouse: '/gallery/resources/lighthouse.svg',
    barn: '/gallery/resources/barn.svg',
    'medieval-gate': '/gallery/resources/medieval-gate.svg'
  };
  var multiparts = {};
  var inhibitHash = '';


  if (typeof smartdownBaseURL === 'string') {
    baseURL = smartdownBaseURL;
  }
  if (typeof smartdownResourceURL === 'string') {
    resourceURL = smartdownResourceURL;
  }
  if (typeof smartdownDefaultHome === 'string') {
    defaultHome = smartdownDefaultHome;
  }
  if (typeof smartdownRawPrefix === 'string') {
    rawPrefix = smartdownRawPrefix;
  }
  if (typeof smartdownOutputDivSelector === 'string') {
    outputDivSelector = smartdownOutputDivSelector;
  }
  if (typeof smartdownPostLoadMutator === 'function') {
    postLoadMutator = smartdownPostLoadMutator;
  }
  if (typeof smartdownAdjustHash === 'boolean') {
    adjustHash = smartdownAdjustHash;
  }

  if (typeof smartdownMedia === 'object') {
    media = Object.assign(media, smartdownMedia);
  }

  var lastLoadedRawPrefix = rawPrefix;

  var calcHandlers = smartdown.defaultCalcHandlers;
  var replace = rawPrefix;

  const linkRules = [
    {
      prefix: '/block/',
      replace: replace
    },
    {
      prefix: 'block/',
      replace: replace
    },
    {
      prefix: 'assets/',
      replace: replace + 'assets/'
    },
    {
      prefix: '/assets/',
      replace: replace + 'assets/'
    },
    {
      prefix: 'content/',
      replace: replace + 'content/'
    },
    {
      prefix: '/content/',
      replace: replace + 'content/'
    },
    {
      prefix: '/gallery/resources/',
      replace: resourceURL === '' ? '/gallery/resources/' : resourceURL
    },
    {
      prefix: '/gallery/DataElements.csv',
      replace: baseURL === '/smartdown/' ? '/smartdown/gallery/DataElements.csv' : '/gallery/DataElements.csv'
    },
    {
      prefix: '/resources/',
      replace: resourceURL === '' ? '/resources/' : resourceURL
    },
  ];

  // console.log(JSON.stringify(media, null, 2));
  // console.log(JSON.stringify(linkRules, null, 2));
  smartdown.initialize(media, baseURL, doneHandler, relativeCardLoader, calcHandlers, linkRules);
}
