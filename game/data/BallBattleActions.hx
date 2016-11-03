package data;

import snipe.slave.Server;
import snipe.slave.Module;
import snipe.lib.Params;

class BallBattleActions extends Module<BallClient, ServerBall> {

  public function new(srv: ServerBall)
    {
      super(srv);
      name = "actions";
      trace( '====================================' );
    }

}
