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

let Suite =
{
  name : 'Browserstack',

  silencing : 1,

  tests :
  {
    throwSyncError,
  }
}

//

let Self = wTestSuite( Suite ).inherit( Parent );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
