( function _VisualBase_s_()
{

'use strict';

/* !!! try to tokenize the file */

if( typeof module !== 'undefined' )
{

  if( !_global_.wBase || _global_.__GLOBAL_NAME__ !== 'real' )
  {
    let toolsPath = '../../../../node_modules/Tools';
    let _externalTools = 0;
    try
    {
      toolsPath = require.resolve( toolsPath );
    }
    catch( err )
    {
      _externalTools = 1;
      require( 'wTools' );
    }
    if( !_externalTools )
    require( toolsPath );
  }

  const _global = _global_;
  const _ = _global_.wTools;

  debugger;
  _.include( 'wTesting' );
  debugger;
  _.include( 'wPuppet' );
}

})();
