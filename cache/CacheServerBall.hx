import snipe.cache.CacheServer;

class CacheServerBall extends CacheServer
{
  function new()
    {
      super();
    }


  public override function initModules()
    {
      loadModules([modules.BallCache]);
      cacheManager.loadModules([ data.BattleCacheData]);
    }


  static var s: CacheServerBall;
  static function main()
    {
      s = new CacheServerBall();
      s.initServer();
      s.start();
    }
}
