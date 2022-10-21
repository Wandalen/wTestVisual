( function _Puppeteer_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
_.test = _.test || Object.create( null );
_.test.visual = _.test.visual || Object.create( null );
_.test.visual.puppeteer = _.test.visual.puppeteer || Object.create( null );

let Puppeteer, PuppeteerRevisions;

//

function browserDownload( browser )
{
  browser = browser ? browser : 'chromium';
  _.assert( [ 'chromium', 'firefox' ].includes( browser ), 'Unknown browser : ', browser );
  let product = browser === 'chromium' ? 'chrome' : browser;
  if( !Puppeteer )
  {
    Puppeteer = require( 'puppeteer' );
    PuppeteerRevisions = require( 'puppeteer/lib/cjs/puppeteer/revisions.js' );
  }

  let browserFetcher = Puppeteer.createBrowserFetcher({ product });
  /* see the differences for forming versions in puppeteer/lib/cjs/puppeteer/revisions.js and puppeteer/lib/cjs/puppeteer/node/install.js */
  /* the main difference is in obtaining versions, it is routine getFirefoxNightlyVersion and hardcoded version in PuppeteerRevisions.PUPPETEER_REVISIONS */
  /* the version of chromium is also hardcoded in PuppeteerRevisions.PUPPETEER_REVISIONS */
  let targetRevision = product === 'firefox' ? '108.0a1' : PuppeteerRevisions.PUPPETEER_REVISIONS[ browser ];
  let ready = _.Consequence.From( browserFetcher.localRevisions() );

  ready.then( ( localRevisions ) =>
  {
    if( _.longHas( localRevisions, targetRevision ) )
    return null;
    return _.Consequence.From( browserFetcher.download( targetRevision ) ).then( () => targetRevision );
  });

  return ready;
}

//

let Extension =
{
  browserDownload,
}


Object.assign( _.test.visual.puppeteer, Extension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();
