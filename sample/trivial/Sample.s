
if( typeof module !== 'undefined' )
require( 'wtestvisual' );

let _ = _global_.wTools;

//
let ready = _.test.visual.puppeteer.chromiumDownload();
ready.then( ( res ) =>
{
  if( res )
  console.log( `Downloaded revision ${res}` );
  else
  console.log( `Chromium is already downloaded` );

  return res;
})
