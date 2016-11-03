import snipe.slave.MetaServer;
import snipe.slave.ServerGame;

class ServerBall extends ServerGame
{
  function new(metav: MetaServer, idv: Int)
    {
      super(metav, idv);
    }


  override function initModulesGame()
    {
      loadModules([ modules.BallBattleModule ]);
      //addNoLoginRequests([  ]);

    }


  static var s: ServerBall;
  static function main()
    {
      var meta = new MetaServer('game', ServerBall, BallClient);
      meta.initServer();
      meta.start();
    }
}
