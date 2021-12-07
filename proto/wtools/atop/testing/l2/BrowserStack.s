( function _Puppeteer_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
_.test = _.test || Object.create( null );
_.test.visual = _.test.visual || Object.create( null );
_.test.visual.browserstack = _.test.visual.browserstack || Object.create( null );

let BrowserStackLocal = require( 'browserstack-local' );
let Needle = require( 'needle' );

//

function localBegin( key )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strDefined( key ) );
  const ready = _.Consequence();
  let local = new BrowserStackLocal.Local();
  local.start( { key }, () => ready.take( local ) );
  return ready;
}

//

function localEnd( local )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( local instanceof BrowserStackLocal.Local );
  const ready = _.Consequence();
  local.stop( () => ready.take( null ) );
  return ready;
}

//

function sessionStatusSet( o )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.routine.options_( sessionStatusSet, o );
  _.assert( _.strDefined( o.sid ) );
  _.assert( _.strDefined( o.user ) && _.strDefined( o.key ) );

  if( o.onStatusForm === null )
  o.onStatusForm = onStatusFormDefault;
  if( o.onSessionStop === null )
  o.onSessionStop = onSessionStopDefault;
  if( o.onSessionStatus === null )
  o.onSessionStatus = onSessionStatusDefault;

  if( o.sessionStopUri === null )
  o.sessionStopUri = `https://automate.browserstack.com/api/v1/sessions/${o.sid}/stop`;
  if( o.sessionApiUri === null )
  o.sessionApiUri = `https://api.browserstack.com/automate/sessions/${o.sid}.json`

  _.assert( _.strDefined( o.sessionStopUri ) && _.strDefined( o.sessionApiUri ) );

  let data = o.onStatusForm( o );
  _.assert( _.strIs( data.status ) && _.strIs( data.reason ) );

  let opts = { json : true, username : o.user, password: o.key  };

  let stopReady = o.onSessionStop( o );
  let statusReady = o.onSessionStatus( o );

  return _.Consequence.And( stopReady, statusReady );

  //

  function onStatusFormDefault( o )
  {
    _.assert( _.object.is( o.tro ) );
    let status = o.tro.report.outcome ? 'passed' : 'failed';
    let reason = !o.tro.report.outcome ? o.tro.report.reason || 'test check failed' : '';
    return { status, reason }
  }

  function onSessionStopDefault( o )
  {
    let stopReady = _.Consequence();
    Needle.post( o.sessionStopUri, {}, opts, ( err, resp, ) =>
    {
      if( err )
      stopReady.error( __.err( `Failed to stop BrowserStack session ${o.sid}. \nErr:${err}, \nResponse:${resp}` ) )
      else
      stopReady.take( resp )
    })
    return stopReady;
  }

  function onSessionStatusDefault( o )
  {
    let putReady = _.Consequence();
    Needle.put( o.sessionApiUri, data, opts, ( err, resp ) =>
    {
      if( resp && resp.statusMessage === 'OK' )
      putReady.take( resp );
      else
      putReady.error( __.err( `Failed to set status of BrowserStack session ${o.sid}. \nErr:${err}, \nResponse:${resp}` ) )
    });
    return putReady;
  }
}

sessionStatusSet.defaults =
{
  sid : null,
  tro : null,
  user : null,
  key : null,
  sessionStopUri : null,
  sessionApiUri : null,
  onStatusForm : null,
  onSessionStop : null,
  onSessionStatus : null
}

//

let Extension =
{
  localBegin,
  localEnd,

  sessionStatusSet
}


Object.assign( _.test.visual.browserstack, Extension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();
