( function _InvalidDevice_test_s_()
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

function trivial( test )
{
  const context = this;
  const a = context.assetFor( test );
  a.entryPath = 'trivial/Setup.html';

  return a.inBrowser( async ( page ) =>
  {
    test.true( true );
  });
}

trivial.timeOut = 180000;

//

let Suite =
{
  name : 'InvalidDevice',

  silencing : 1,

  context :
  {
    remoteConfig :
    [ 'Samsung Galaxy' ],
  },

  tests :
  {
    trivial,
  },
}

//

let Self = wTestSuite( Suite ).inherit( Parent );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
