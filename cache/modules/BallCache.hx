package modules;

import snipe.cache.ModuleCache;

import snipe.cache.SlaveClient;
import snipe.cache.CacheServer;
import snipe.lib.Params;
import snipe.cache.Block;


 class BallCache extends ModuleCache<CacheServer>  {

   public var id(get, null): Int;
   public var firstPlayerID(get, null): Int;
   public var secondPlayerID(get, null): Int;
   public var turnID(get, null): Int;
   public var _list: Dynamic;
   public var room: Block;
   public var usersList: Array<Int>;


   public function new(c: CacheServer) {
     super(c);
     name = "ball/cache";

    
   }

   public override function call(c: SlaveClient, type: String, params: Params): Dynamic {
     var response = null;
     var response = null;

     switch (type) {
       case 'ball/cache.battle.find':
         response = GetAvaliableRooms(c, params);
       /*case 'ball/cache.battle.addUsers':
         response = AddUsers(c, params);
      case 'ball/cache.battle.getAvailableUsers':
        response = GetAvailableUsers(c, params);*/
       case 'ball/cache.battle.create':
         response = CreateRoomCall(c, params);
        case 'ball/cache.battle.join':
          response = JoinRoomCall(c, params);
        case 'ball/cache.battle.deleteRoom':
          response = DeleteRoomCall(c, params);
        case 'ball/cache.battle.infoRoom':
          response = RoomInfoCall(c, params);
        case 'ball/cache.battle.finishRoom':
          response = FinishRoomCall(c, params);
        }
     return response;

   }

   public function FinishRoomCall(c: SlaveClient, params: Params): Dynamic {
    var roomId = params.get('roomId');
    var ret = FinishRoom(roomId);
    return ret;
  }

  public function RoomInfoCall(c: SlaveClient, params: Params): Dynamic {
    var roomId = params.get('roomId');
    var ret = RoomInfo(roomId);
    return ret;
  }
  public function RoomInfo(roomId: Int) {
    var ret = server.cacheManager.getUnlocked(0,'battle', roomId, -1);
    var room = ret.block;
    var obj = {
      firstId: room.get(null, 'firstid'),
      secondId: room.get(null, 'secondid'),
      turnId: room.get(null, 'turnid')
    }
    return obj;
  }
  public function CreateRoomCall(c: SlaveClient, params: Params): Dynamic {
     var firstId = params.get('selfId');

     var ret = createRoom(firstId);

     return ret;
  }

 public function JoinRoomCall(c: SlaveClient, params: Params): Dynamic {
    var secondId = params.get('selfId');
    var roomId = params.get('roomId');
    var ret = joinRoom(secondId, roomId);

    return ret;
  }

  public function DeleteRoomCall(c: SlaveClient, params: Params): Dynamic {
     var roomId = params.get('roomId');
     var ret = deleteRoom(roomId);

     return ret;
   }

   /*public function AddUsers(c: SlaveClient, params: Params): Dynamic {
     var user = params.get('userId');
     usersList.push(user);
   }*/

  function GetAvaliableRooms(c: SlaveClient, params: Params): Dynamic {
    var ret = server.query('SELECT id, firstid FROM battle WHERE avaliable = true AND finished <> true');
    var arr = [];
    if( ret.length > 0 ) {
      for(row in ret) {
        arr.push({id: row.id, first: row.firstid});
      }
      return {errorCode: 'ok', list: arr, count: ret.length};
    }
    return {errorCode: 'not', list: [], count: 0};
   }

   public function FinishRoom(roomId: Int): Dynamic {
     var ret = server.cacheManager.getUnlocked(0,'battle', roomId, -1);
     var room = ret.block;
     room.set(null, 'finished', true);
     server.cacheManager.updated(0, 'battle', roomId);

     return {errorCode: 'ok'};
   }
  public function createRoom(userId: Int): Dynamic {
      var id = server.nextID('Battle');

       server.cacheManager.create(0, 'battle', id);

      var ret = server.cacheManager.get(0, 'battle', id, -1);


      room = ret.block;

      var retFirst = setFirst(userId, room.id);

      if(retFirst.errorCode == 'ok')
        return { errorCode: 'ok', player: 1, room: room.id }
      else
        return {errorCode: retFirst.errorCode  };

   }

  public function joinRoom(userId: Int, roomId: Int): Dynamic {



    room.set(null, 'secondid', userId);
    room.set(null, 'avaliable', false);
    server.cacheManager.updated(0, 'battle', roomId);

        return { errorCode: 'ok', player: 2, room: roomId };

   }


   public function setFirst(userId: Int, roomId: Int): Dynamic {
     room.set(null, 'firstid', userId);
     room.set(null, 'turnid', userId);
     room.set(null, 'avaliable', true);
     server.cacheManager.updated(0, 'battle', roomId);
     return { errorCode: 'ok' };
   }

   public function deleteRoom(roomID: Int): Dynamic {
          server.log('room', 'deleted room ' + roomID);

          server.cacheManager.unlock(0, 'battle', roomID);

      server.query("DELETE FROM Battle WHERE ID = " + roomID);

      return {errorCode: 'ok'};
    }


   public function get_id(): Int {
     return room.id;
   }

   public function get_firstPlayerID(): Int {
     return room.getInt(null, 'firstid');
   }

   public function get_secondPlayerID(): Int {
     return room.getInt(null, 'secondid');
   }

   public function get_turnID():Int {
     return room.getInt(null, 'turnid');
   }



 }
