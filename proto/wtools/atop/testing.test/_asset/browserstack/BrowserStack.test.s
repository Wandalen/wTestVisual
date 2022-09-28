( function _BrowserStack_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  require( 'Abstract.test.s' );
}

const _ = _global_.wTools;
const Parent = wTests[ 'Tools.TestVisual.Abstract' ];
_.assert( !!Parent );

//

function throwSyncError( test )
{
  throw _.error.brief( 'Sync error' );
}

//

function throwAsyncError( test )
{
  let con = new _.Consequence();
  return con.error( _.error.brief( 'Async error' ) );
}

//

function browserThrowSyncError( test )
{
  const context = this;
  const a = context.assetFor( test );
  a.entryPath = 'trivial/Setup.html';

  return a.inBrowser( async ( page ) =>
  {
    throw _.error.brief( 'Sync error' );
  });
}

browserThrowSyncError.timeOut = 180000;

//

function browserThrowAsyncError( test )
{
  const context = this;
  const a = context.assetFor( test );
  a.entryPath = 'trivial/Setup.html';

  return a.inBrowser( async ( page ) =>
  {
    let con = new _.Consequence();
    return con.error( _.error.brief( 'Async error' ) );
  });
}

browserThrowAsyncError.timeOut = 180000;

//

function browserTimeout( test )
{
  const context = this;
  const a = context.assetFor( test );
  a.entryPath = 'trivial/Setup.html';

  return a.inBrowser( async ( page ) =>
  {
    return new _.Consequence();
  });
}

browserTimeout.timeOut = 60000;

//

let Suite =
{
  name : 'Browserstack',

  silencing : 1,

  tests :
  {
    throwSyncError,
    throwAsyncError,

    browserThrowSyncError,
    browserThrowAsyncError,

    browserTimeout,
  }
}

//

let Self = wTestSuite( Suite ).inherit( Parent );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
