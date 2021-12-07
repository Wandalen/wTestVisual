( function _Int_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{

  const _ = require( '../../../node_modules/Tools' );

  if( typeof _realGlobal_ === 'undefined' || !_realGlobal_.wTester || !_realGlobal_.wTester._isReal_ )
  require( '../testing/entry/Visual.s' );

  _.include( 'wLogger' );
  _.include( 'wConsequence' );
  _.include( 'wProcedure' );
  _.include( 'wProcess' );
  _.include( 'wFiles' );

}

const _global = _global_;
const _ = _global_.wTools;

// --
// tools
// --

//

function onSuiteBegin()
{
}

//

function onSuiteEnd()
{
}

// --
// declare
// --

const Proto =
{

  name : 'Tools.TestVisual.Int',
  silencing : 1,
  routineTimeOut : 30000,
  enabled : 0,

  onSuiteBegin,
  onSuiteEnd,

  context :
  {
    t1 : 100,
    t2 : 1000,
  },

  tests :
  {
  },

}

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();

