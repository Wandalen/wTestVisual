( function _BrowserStack_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../node_modules/Tools' );
  _.include( 'wTesting' );
  require( '../testing/entry/Visual.s' );
}

const _global = _global_;
const _ = _global_.wTools;
const __ = _globals_.testing.wTools;

//

function onSuiteBegin()
{
  let context = this;
  context.suiteTempPath = _.path.tempOpen( _.path.join( __dirname, '../..'  ), 'TestVisual' );
  context.assetsOriginalPath = _.path.join( __dirname, '_asset' );
  const testingPath = require.resolve( 'wTesting' );
  context.appJsPath = _.path.nativize( _.path.join( testingPath, '../../wtools/atop/testing/entry/Exec' ) );
}

//

function onSuiteEnd()
{
  let context = this;
  _.assert( _.strHas( context.suiteTempPath, 'TestVisual' ) );
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
      toolsPath : _.module.resolve( 'wTools' ),
    };
    o.locals = o.locals || locals;
    _.props.supplement( o.locals, locals );
    _.props.supplement( o.locals.context, locals.context );
    let r = oprogram.body.call( a, o );
    r.filePath = a.path.nativize( r.filePath );
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
      let read = a.fileProvider.fileRead( r.dst.absolute );
      let path = _.path.nativize( _.path.join( __dirname, 'Abstract.test.s' ) );
      if( process.platform === 'win32' )
      path = _.str.replace( path, '\\', '\\\\' );
      read = _.strReplace( read, `Abstract.test.s`, path );
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

//

function routineThrowSyncError( test )
{
  const context = this;
  const a = context.assetFor( test, 'browserstack' );
  a.reflect();

  if( _.process.insideTestContainer() || !context.remoteTesting )
  return test.true( true );

  /* - */

  const o =
  {
    execPath : `.context remoteTesting:1 .run ./ r:throwSyncError v:7`,
    outputPiping : 1,
  };
  a.appStartNonThrowing( o );

  o.pnd.on( 'message', ( response ) =>
  {
    test.case = 'unrechable check';
    test.identical( false, true );
  });

  a.ready.then( ( op ) =>
  {
    test.notIdentical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'Sync error' ), 1 );
    return null;
  });

  /* - */

  return a.ready;
}

routineThrowSyncError.timeOut = 60000;

//

function routineThrowAsyncError( test )
{
  const context = this;
  const a = context.assetFor( test, 'browserstack' );
  a.reflect();

  if( _.process.insideTestContainer() || !context.remoteTesting )
  return test.true( true );

  /* - */

  const o =
  {
    execPath : `.context remoteTesting:1 .run ./ r:throwAsyncError v:7`,
    outputPiping : 1,
  };
  a.appStartNonThrowing( o );

  o.pnd.on( 'message', ( response ) =>
  {
    test.case = 'unrechable check';
    test.identical( false, true );
  });

  a.ready.then( ( op ) =>
  {
    test.notIdentical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'Async error' ), 1 );
    return null;
  });

  /* - */

  return a.ready;
}

routineThrowAsyncError.timeOut = 60000;

//

function browserThrowSyncError( test )
{
  const context = this;
  const a = context.assetFor( test, 'browserstack' );
  a.reflect();

  if( _.process.insideTestContainer() || !context.remoteTesting )
  return test.true( true );

  /* - */

  const o =
  {
    execPath : `.context remoteTesting:1 .run ./ r:browserThrowSyncError v:7`,
    outputPiping : 1,
  };
  a.appStartNonThrowing( o );

  o.pnd.on( 'message', ( response ) =>
  {

    test.identical( response.build_name, 'browserThrowSyncError' );
    test.identical( response.status, 'failed' );
    test.identical( response.reason, 'throwing error' );
  });

  a.ready.then( ( op ) =>
  {
    test.notIdentical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'Sync error' ), 1 );
    return null;
  });

  /* - */

  return a.ready;
}

browserThrowSyncError.timeOut = 240000;

//

function browserThrowAsyncError( test )
{
  const context = this;
  const a = context.assetFor( test, 'browserstack' );
  a.reflect();

  if( _.process.insideTestContainer() || !context.remoteTesting )
  return test.true( true );

  /* - */

  const o =
  {
    execPath : `.context remoteTesting:1 .run ./ r:browserThrowAsyncError v:7`,
    outputPiping : 1,
  };
  a.appStartNonThrowing( o );

  o.pnd.on( 'message', ( response ) =>
  {

    test.identical( response.build_name, 'browserThrowAsyncError' );
    test.identical( response.status, 'failed' );
    test.identical( response.reason, 'throwing error' );
  });

  a.ready.then( ( op ) =>
  {
    test.notIdentical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'Async error' ), 1 );
    return null;
  });

  /* - */

  return a.ready;
}

browserThrowAsyncError.timeOut = 240000;

//

let Suite =
{
  name : 'Tools.TestVisual.Browserstack',

  silencing : 1,

  onSuiteBegin,
  onSuiteEnd,

  context :
  {
    assetFor,

    suiteTempPath : null,
    assetsOriginalPath : null,
    appJsPath : null,

    remoteTesting : true,
  },

  tests :
  {
    routineThrowSyncError,
    routineThrowAsyncError,

    browserThrowSyncError,
    browserThrowAsyncError,
  }
}

//

const Self = wTestSuite( Suite );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
