( function _VisualTop_s_()
{

'use strict';

//

if( typeof module !== 'undefined' )
{
  const _ = require( 'Tools' );

  //

  require( './VisualBase.s' );

  require( '../l1/VisualNamespace.s' );

  require( '../l2/Puppeteer.s' );
  require( '../l2/BrowserStack.s' );

  require( '../l3/VisualAssetFor.s' );
}

if( typeof module !== 'undefined' )
module[ 'exports' ] = _global_.wTools;

})();
