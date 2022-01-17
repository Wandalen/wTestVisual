( function _PageFunctionality_test_s_()
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

async function evaluate ( test ) 
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

evaluate.timeOut = 60000;

//

let Suite =
{
  name : 'Tools.TestVisual.PageFunctionality',

  silencing : 1,

  tests :
  {
    evaluate
  }
}

//

let Self = wTestSuite( Suite ).inherit( Parent );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
