( function _Mobile_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  require( './Abstract.test.s' );
}

const _ = _global_.wTools;
const Parent = wTests[ 'Tools.TestVisual.Abstract' ];
_.assert( !!Parent );

//

async function trivial ( test ) 
{
  let context = this;
  let a = context.assetFor( test );
  a.entryPath = 'trivial/Setup.html';

  return a.inBrowser( async ( page ) => 
  {
    let got = await page.evaluate( () => true );
    test.identical( got, true );
  });
}

//

let Suite = 
{
  name : 'Tools.TestVisual.Mobile',

  silencing : 1,

  tests : 
  {
    trivial
  }
}

//

let Self = wTestSuite( Suite ).inherit( Parent );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
