( function _Abstract_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../node_modules/Tools' );
  require( '../testing/entry/Visual.s' );
  _.include( 'wProcess' );
  _.include( 'wFiles' );
  _.include( 'wConsequence' );
  _.include( 'wTesting' );
}

const _global = _global_;
const _ = _global_.wTools;
const __ = _globals_.testing.wTools;

let Express = require( 'express' );

//

async function onSuiteBegin( suite ) 
{
  let self = this;
  let suiteDirPath = __.path.dir( suite.suiteFilePath );
  self.suiteTempPath = __.path.join( suiteDirPath, '.tmp' );

  await self.bsBegin();
  await self.serverStart();
}

//

async function onSuiteEnd() 
{
  let self = this;
  await self.bsEnd();
  await self.bsSessionClose();
  await self.serverStop();
}

//

async function onRoutineEnd( tro ) 
{
  let self = this;
  await self.bsStatusUpdate( tro );
  await self.bsSessionClose();
}

//

async function bsBegin () 
{
  let self = this;

  if( !self.browserStackEnabled )
  return false;

  self.bsLocal = await _.test.visual.browserstack.localBegin( self.browserStackAccessKey )
  return null;

}

//

function bsEnd () 
{
  let self = this;

  if( !self.browserStackEnabled )
  return false;
  return _.test.visual.browserstack.localEnd( self.bsLocal );
}

//

async function bsStatusUpdate( tro )
{
  let context = this;

  if( !context.remoteTesting ) return;
  if( !context.bsSession ) return

  return _.test.visual.browserstack.sessionStatusSet
  ({
    sid : context.bsSession,
    user : process.env.BROWSERSTACK_USER,
    key : process.env.BROWSERSTACK_KEY,
    tro
  })
}

//

async function bsSessionClose()
{
  let context = this;

  if( !context.browser ) return;
  if( !context.browser.isConnected() ) return;

  try
  {
    return context.browser.close();
  }
  catch( err )
  {
    __.errLogOnce( err );
  }
}

//

function serverStart () 
{
  let context = this;

  let ready = __.Consequence();

  context.app = new Express();
  context.app.use( '/assets', Express.static( __.path.nativize( __.path.join( __dirname, '_asset' ) ) ) );
  context.server = context.app.listen( 0, () =>
  {
    context.port = context.server.address().port;
    ready.take( null )
  });

  return ready;

}

//

function serverStop () 
{
  let context = this;
  let ready = __.Consequence();
  context.server.close( () => 
  {
    ready.take( null )
  });
  return ready;
}

//

function assetFor ( test, assetName ) 
{
  let context = this;
  let routinePath = __.path.join( context.suiteTempPath, test.name );

  let a = _.test.visual.assetFor
  ({
    test,
    assetName,
    routinePath,
    browserDimensions : [ 800, 600 ],
    browserStackEnabled : context.remoteTesting,
    browserStackUser : process.env.BROWSERSTACK_USER,
    browserStackAccessKey : process.env.BROWSERSTACK_KEY,
    browserStackIdleTimeoutInSec : 30,
    browserStackConfigs : context.remoteConfig,
  });

  a.onBrowserStackSessionChanged = onBrowserStackSessionChanged;
  a.onPageLoad = onPageLoad;
  a.onBeforeRoutine = onBeforeRoutine;

  return a;

  /* */

  function onBrowserStackSessionChanged( sid ) 
  {
    context.bsSession = sid;
  }

  async function onPageLoad() 
  {
    __.assert( __.strDefined( this.entryPath ) );
    let host = this.mobile ? 'bs-local.com' : 'localhost';
    this.serverPath = __.uri.join( `http://${host}:${context.port}` );
    await this.page.goto( __.uri.join( this.serverPath, this.entryPath ) );
  }

  async function onBeforeRoutine()
  {
    try 
    {
        // await this.page.waitForFunction( () => {

        //     return window.ready === true;

        // }, { timeout : 30000 });

    }
    catch ( err ) {

      //  throw __.err( `Waiting for 'window.ready' state failed:\n`, err );
    }
  }
}

//

let Suite = 
{
  name : 'Tools.TestVisual.Abstract',
  silencing: 1,

  abstract: 1,

  onSuiteBegin,
  onSuiteEnd,

  onRoutineEnd,

  context: 
  {
    port: null,
    app: null,
    server: null,

    suiteTempPath: null,
    assetsPath: null,

    remoteTesting : false,

    remoteConfig : 
    [
      'Samsung Galaxy S20'
    ],

    bsLocal : null,
    bsSession : null,

    browser : null,

    serverStart,
    serverStop,
    bsBegin,
    bsEnd,
    bsStatusUpdate,
    bsSessionClose,
    assetFor,
  }
}

//

wTestSuite( Suite );

})();
