
if( typeof module !== 'undefined' )
{
  const _ = require( 'wTools' );
  try
  {
    _.include( 'wTestVisual' );
  }
  catch( err )
  {
    _.error.attend( err );
    console.log( 'Module Testing does not included.' );
    return;
  }
}

let _ = _globals_.testing.wTools;

//

let ready = _.test.visual.puppeteer.chromiumDownload();
ready.then( ( res ) =>
{
  if( res )
  console.log( `Downloaded revision ${res}` );
  else
  console.log( `Chromium is already downloaded` );

  return res;
});
