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
      name = "battle";
      server.subscribeModule("core/user.logoutPost", this);
    }


  public override function call(c: BallClient, type: String, params: Params): Dynamic
    {
      var response = null;
      switch (type) {
        case "battle.find":
          response = FindCall(c, params);
        case "battle.task":
          response = TaskCall(c, params);
        case "battle.finish":
          response = FinishCall(c, params);
      }

      return response;
    }

    public function FindCall(c: BallClient, params: Params): Dynamic {
        var ret = FindBattle(c, c.id, params);
  		  return ret;
      }

      public function TaskCall(c: BallClient, params: Params): Dynamic {
        var ret = Task(c, c.id, params);
        return ret;
      }

      public function FinishCall(c: BallClient, params: Params): Dynamic {
        var roomId: Int = params.get('roomId');
        var user = RoomInfo(roomId);
        var secondId = user.secondId;
        var firstId = c.id;
        var ret = Finish(roomId, secondId, firstId);
        return ret;
      }

  public function FindBattle(c: BallClient, cid: Int, params: Params): Dynamic {
    var res = GetAvaliableRooms();
    var list: Array<Dynamic> = res.list;
    var count = res.count;
    if(res.errorCode == 'not') {
      var ret = CreateRoom(cid);

      return ret;
    } else {

      var r = Std.random(count);
      var i = 0;
      for(el in list)
          {

            if(i == r)
            {
              var res = JoinRoom(cid, el.id);
              if(res.errorCode == 'ok') {

                var data = Enemy(c, cid, el.first);
                if( data.errorCode == 'ok' ) {
                  return res;
                }
              }

            }
            i++;
          }


    }
    return { errorCode: "Not battle" };
  }

public function Enemy(c: BallClient,selfId: Int, enemId: Int): Dynamic {
      var selfName = server.query('SELECT name FROM users WHERE id=' + selfId);
      var enemName = server.query('SELECT name FROM users WHERE id=' + enemId);
      var sName = '';
      var eName = '';
      for(i in selfName) {
        sName = i.name;
      }
      for(i in enemName) {
        eName = i.name;
      }
      server.sendTo(enemId, {"enemy.num": 2,"enemy.id": enemId, name: eName, "enemy.name": sName, type: "battle.enemy", _type: "battle.enemy"});
      c.response('battle.enemy', {"enemy.num": 1, "enemy.id": selfId, name: sName, "enemy.name": eName, type: "battle.enemy"});
      return {errorCode: 'ok'};
  }

  public function Task(c: BallClient, cid: Int, params: Params) {
    var roomId = params.get('roomId');
    var user = RoomInfo(roomId);
    var enemId = 0;
    if(cid == user.firstId) {
      enemId = user.secondId;
    } else if(cid == user.secondId){
      enemId = user.firstId;
    }

    server.sendTo(enemId, params);

    return {errorCode: 'ok'}
  }

  public function Finish(roomId: Int, secondId: Int, firstId: Int): Dynamic {
    DeleteRoom(roomId);
    server.sendTo(secondId, {_type: "battle.end"});
    return {errorCode: 'ok'}
  }

  public function GetAvaliableRooms(): Dynamic {
        var ret = server.cacheRequest({
          _type: 'ball/cache.battle.find'
        });

        return ret;
    }

    public function CreateRoom(cid: Int) {
      var ret = server.cacheRequest({
        _type: 'ball/cache.battle.create',
        selfId: cid
      });

      return ret;
    }

    public function JoinRoom(cid: Int, roomId: Int) {
      var ret = server.cacheRequest({
         _type: 'ball/cache.battle.join',
         selfId: cid,
         roomId: roomId
        });
      return ret;
    }

    public function FinishRoom(roomId: Int) {
      var ret = server.cacheRequest({
          _type: 'ball/cache.battle.finishRoom',
          roomId: roomId
        });
      return ret;
    }

    public function DeleteRoom(roomId: Int) {
      var ret = server.cacheRequest({
         _type: 'ball/cache.battle.deleteRoom',
         roomId: roomId
        });
      return ret;
    }

    public function RoomInfo(roomId: Int) {
      var ret = server.cacheRequest({
         _type: 'ball/cache.battle.infoRoom',
         roomId: roomId
        });
      return ret;
    }

    public function testEvent( msg: Dynamic) {
      trace( msg );
    }

    override function logoutPost(c: BallClient ) {
      var ret = server.query('SELECT id FROM battle WHERE firstid=' + c.id + ' OR secondid=' + c.id + ' AND finished <> true');
      var roomId = 0;
      for( i in ret  ) {
        roomId = i.id;
      }
      var user = RoomInfo(roomId);
      var enemId = 0;
      if(c.id == user.firstId) {
        enemId = user.secondId;
      } else if(c.id == user.secondId){
        enemId = user.firstId;
      }
      DeleteRoom(roomId);
      server.sendTo(enemId, {_type: 'battle.end'});
    }

}
