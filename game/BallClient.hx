// client info

import sys.net.Socket;

import snipe.slave.ServerGame;
import snipe.slave.Block;
import snipe.slave.ClientGame;

class BallClient extends ClientGame
{

  public function new(s: Socket, srv: ServerGame)
    {
      super(s, srv);

    }
}
