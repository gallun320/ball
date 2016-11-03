import snipe.cache.UniServer;

class UniServerBall extends UniServer
{
  function new()
    {
      super();
    }


// main function
  static var u: UniServerBall;
  static function main()
    {
      u = new UniServerBall();
      u.print("UniServerBall " +
        snipe.lib.MacroBuild.getBuildBranch() + "-" +
        snipe.lib.MacroBuild.getBuildDate());
      u.print("Snipe Core " +
        snipe.lib.MacroBuild.getCoreBranch('../..') + "-" +
        snipe.lib.MacroBuild.getCoreDate('../..'));
      u.cacheClass = CacheServerBall;
      u.slaveInfos = [
        {
          type: 'game',
          client: BallClient,
          server: ServerBall,
        },
        ];
      u.init();
      u.start();
    }
}
