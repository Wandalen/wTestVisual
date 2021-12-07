( function _IncludeTop_s_()
{

'use strict';

//

if( typeof module !== 'undefined' )
{
  const _ = require( 'Tools' );

  //

  require( './Base.s' );
  require( '../l1/Namespace.s' );

  require( '../l2/Puppeteer.s' );
  require( '../l2/BrowserStack.s' );

  require( '../l3/AssetFor.s' );

}

if( typeof module !== 'undefined' )
module[ 'exports' ] = _global_.wTools;

})();
