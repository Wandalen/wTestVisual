( function _Puppeteer_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
_.test = _.test || Object.create( null );
_.test.visual = _.test.visual || Object.create( null );

//

function assetFor( o )
{
  let test = o.test;

  _.assert( arguments.length === 2 );
  _.assert( _.routine.is( test.assetFor ), 'Test descriptor should have assetFor function implemented.' );

  let a = test.assetFor({ assetName : o.assetName, routinePath: o.routinePath });

  a.browserDimensions  = o.browserDimensions;
  a.browserstackEnabled = o.browserstackEnabled;
  a.browserstackUser = o.browserstackUser;
  a.browserstackKey = o.browserstackKey;
  a.browserStackIdleTimeoutInSec = o.browserStackIdleTimeoutInSec;
  a.browserstackConfigs = o.browserstackConfigs;

  a.inBrowser = inBrowser;
  a.abs = abs;
  a.memoryUsedGb = memoryUsedGb;
  
  a.onAct = onAct;
  a.onBrowserStackConfigsGenerate = onBrowserStackConfigsGenerate;
  a.onRunOnBrowserStack = onRunOnBrowserStack;
  a.onActOptionsForm = onActOptionsForm;
  a.onPageHandlerRegister = onPageHandlerRegister;
  a.onBrowserStackSessionChanged = onBrowserStackSessionChanged;
  a.onPageLoad = onPageLoad;

  //

  function onRunOnBrowserStack() 
  {
    const { desktop, mobile } = this.onBrowserStackConfigsGenerate();
    let ready = _.Consequence().take( null );

    desktop.forEach( ( c ) => 
    {
      const testGroup = `${c.os} ${c.os_version} ${c.browser} ${c.browser_version}`;
      const o = this.onActOptionsForm( 'Puppeteer', c );
      ready.tap( () => test.open( testGroup ) );
      ready.then( () => _.Consequence.From( this.onAct( o ) ) );
      ready.tap( () => test.close( testGroup ) );
    })

    mobile.forEach( ( c ) => {   

      const { deviceName } = c.capabilities[ 'bstack:options' ];
      const testGroup = `${deviceName}`;
      const o = this.onActOptionsForm( 'WebDriverIO', c, true );
      ready.tap( () => test.open( testGroup ) );
      ready.then( () => _.Consequence.From( this.onAct( o ) ) );
      ready.tap( () => test.close( testGroup ) );
    })

    return ready;
  }

  //

  function onBrowserStackConfigsGenerate() 
  {
    const desktop = [];
    const mobile = [];

    _.array.as( this.browserstackConfigs ).forEach( ( src ) => 
    {
      const splits = _.strSplitNonPreserving
      ({ 
        src, 
        delimeter : [ ',', '-' ] 
      });

      if( splits.length === 1 ) 
      {
        const [ deviceName ] = splits;
        const capabilities = 
        {
          'bstack:options' : 
          {
            "projectName" : "Mobile",
            "buildName" : _.path.name( _.path.dir( test.suite.suiteFilePath ) ),
            "sessionName" : test.name,
            "deviceName" : deviceName,
            "realMobile" : "true",
            "local" : true,
            "debug" : "true",
            "consoleLogs" : "verbose",
          }
        }
        const config = 
        {
          user : this.browserStackUser,
          key : this.browserstackKey,

          capabilities,
          
          logLevel : 'error',
          host: 'hub-cloud.browserstack.com',
        }
        mobile.push( config );
      }
      else 
      {
        const [ os, os_version, browser, browser_version ] = splits;
        const config = 
        { 
          project: os,
          build: _.path.name( _.path.dir( test.suite.suiteFilePath ) ),
          name: test.name,
          
          browser,
          browser_version,
          os,
          os_version,

          'browserstack.username': this.browserStackUser,
          'browserstack.accessKey': this.browserstackKey,
          'browserstack.idleTimeout' : this.browserStackIdleTimeoutInSec,
          'browserstack.local': 'true',
        }
        desktop.push( config );
      }
    });

    return { desktop, mobile };
  }

  //

  function onActOptionsForm( strategy, remoteConfig, mobile )
  {
    strategy = strategy || 'Puppeteer';
    mobile = mobile || false;
    remoteConfig = remoteConfig ? remoteConfig : null;
    let system = _global_.wTools.puppet.System({ strategy });
    system.form();
    let browser = remoteConfig ? 'browserstack' : null;
    let puppetOptions = 
    {
      dimensions: this.browserDimensions,
      system,
      remoteConfig,
      browser,
    }
    return { puppetOptions, mobile };
  }

  //

  function onBrowserStackSessionChanged( sid )
  {
  }

  //

  async function onPageLoad()
  {
    _.assert( 0, 'Implement me' );
  }

  //

  async function onAct( o ) 
  {
    o = o || this.onActOptionsForm();

    this.mobile = o.mobile;

    try 
    {
      this.browser = await _global_.wTools.puppet.windowOpen( o.puppetOptions );
      this.page = await this.browser.pageOpen();

      this.onPageHandlerRegister();

      if( this.browserStackEnabled ) 
      {
        const sessionDetails = await this.page.sessionDetailsGet();
        const sid = JSON.parse( sessionDetails )[ "hashed_id" ];
        this.onBrowserStackSessionChanged( sid );
      }

      await this.onPageLoad();

      await this.onBeforeRoutine();

      await this.act( this.page );

      await this.browser.close();

    }
    catch ( err ) 
    {
      _.errAttend( err );

      if( this.browser ) 
      {
        await this.browser.close();
      }

      throw _.err( err );
    }

    return null;
  }

  //

  function onPageHandlerRegister() 
  {
    if( this.tro.verbosity < 5 )
    return;

    this.page.on( 'console', async ( msg ) => 
    {
      const logger = console;
      let args = await Promise.all( msg.args().map( ( arg ) => arg.jsonValue() ) );
      logger.log( ... args );
    });

    this.page.on( 'requestfailed', ( request ) => 
    {
      console.log( _.errBrief( `Failed to load: ${request.url()} ${request.failure().errorText}` ) );
    });

    this.page.on( 'pageerror', ( err ) => 
    {
      _.errLogOnce( `Page error: ${err.toString()}` );
    });
  }

  //

  async function inBrowser ( routine ) 
  { 
    this.act = routine;
    if( this.browserStackEnabled ) return this.onRunOnBrowserStack();
    return this.onAct();
  }

  //

  function abs ( ...args )
  {
    const tro = this.tro;
    let routinePath = this.routinePath;

    if( tro.case )
    {
      const splitted = _.strSplitNonPreserving( tro.case, ' ' );
      splitted.unshift( routinePath );
      routinePath = splitted.join( '_' );
    }

    args.unshift( routinePath );

    return _.uri.join.apply( _.uri, args );
  }

  //

  async function memoryUsedGb ()
  {
    return this.page.evaluate( () =>
    {
      const global = window;
      let performance = global.performance;
      return performance.memory.totalJSHeapSize / Math.pow( 1024, 3 );
    });
  }

}

assetFor.defaults = 
{
  test : null,
  assetName : null,
  routinePath : null,

  browserDimensions : null,
  
  browserstackEnabled : null,
  browserstackUser : null,
  browserstackKey : null,
  browserStackIdleTimeoutInSec : null,
  browserstackConfigs : null,
}

//

let Extension =
{
  assetFor
}


Object.assign( _.test.visual, Extension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();
