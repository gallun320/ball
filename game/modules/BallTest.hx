// test module for test server

package modules;

import snipe.slave.Server;
import snipe.slave.Module;
import snipe.lib.Params;

class BallBattleModule extends Module<BallClient, ServerBall>
{

  public function new(srv: ServerBall)
    {
      super(srv);
      name = "test";
    }


  public override function call(c: BallClient, type: String, params: Params): Dynamic
    {
      var response = null;
      switch (type) {
        case "test.test":
          response = TestCall(c, params);
      }

      return response;
    }

    public function TestCall(c: BallClient, params: Params): Dynamic {
      trace( Sys. );
      return {};
    }

}
