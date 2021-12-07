( function _VisualExt_test_s_( )
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../node_modules/Tools' );
  require( '../testing/entry/Visual.s' );
  _.include( 'wProcess' );
  _.include( 'wFiles' );
  _.include( 'wConsequence' );
}

const _global = _global_;
const _ = _global_.wTools;
const __ = _globals_.testing.wTools;

// --
// context
// --

function onSuiteBegin()
{
  let context = this;

  context.suiteTempPath = _.path.tempOpen( _.path.join( __dirname, '../..'  ), 'TestVisual' );
  context.assetsOriginalPath = _.path.join( __dirname, '_asset' );
  context.appJsPath = _.path.nativize( _.path.join( _.path.normalize( __dirname ), '../testing/entry/Exec' ) );

}

//

function onSuiteEnd()
{
  let context = this;
  _.assert( _.strHas( context.suiteTempPath, 'TestVisual' ) )
  _.path.tempClose( context.suiteTempPath );
}

//

function assetFor( test, asset )
{
  let context = this;
  let a = test.assetFor( asset );

  _.assert( _.routineIs( a.program.head ) );
  _.assert( _.routineIs( a.program.body ) );

  let oprogram = a.program;
  program_body.defaults = a.program.defaults;
  a.program = _.routine.uniteCloning_replaceByUnite( a.program.head, program_body );
  a.reflect = reflect;

  return a;

  /* */

  function program_body( o )
  {
    let locals =
    {
      context : { t0 : context.t0, t1 : context.t1, t2 : context.t2, t3 : context.t3 },
      toolsPath : _.module.resolve( 'wTools' ),
    };
    o.locals = o.locals || locals;
    _.props.supplement( o.locals, locals );
    _.props.supplement( o.locals.context, locals.context );
    let r = oprogram.body.call( a, o );
    r.filePath/*programPath*/ = a.path.nativize( r.filePath/*programPath*/ );
    return r;
  }

  function reflect()
  {
    let reflected = a.fileProvider.filesReflect
    ({
      reflectMap : { [ a.originalAssetPath ] : a.routinePath },
      onUp,
      outputFormat : 'record'
    });

    reflected.forEach( ( r ) =>
    {
      if( !_.longHasAny( [ 'js', 's', 'ts' ], r.dst.ext ) )
      return;
      // if( r.dst.ext !== 'js' && r.dst.ext !== 's' )
      // return;
      var read = a.fileProvider.fileRead( r.dst.absolute );
      read = _.strReplace( read, `'wTesting'`, `'${_.strEscape( context.appJsPath )}'` );
      read = _.strReplace( read, `'wTools'`, `'${_.strEscape( _.module.resolve( 'wTools' ) )}'` );
      a.fileProvider.fileWrite( r.dst.absolute, read );
    });
  }

  function onUp( r )
  {
    if( !_.strHas( r.dst.relative, '.atest.' ) )
    return;
    let relative = _.strReplace( r.dst.relative, '.atest.', '.test.' );
    r.dst.relative = relative;
    _.assert( _.strHas( r.dst.absolute, '.test.' ) );
  }

}

// --
// suite
// --

const Proto =
{

  name : 'Tools.TestVisual.Ext',
  silencing : 1,
  enabled : 0,

  onSuiteBegin,
  onSuiteEnd,
  routineTimeOut : 300000,

  context :
  {

    assetFor,

    suiteTempPath : null,
    assetsOriginalPath : null,
    appJsPath : null,

    t1 : 100,
    t2 : 1000,
    t3 : 10000,

  },

  tests :
  {
  }

}

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
