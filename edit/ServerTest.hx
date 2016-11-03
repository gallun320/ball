// test - editor server

import snipe.edit.EditServer;

class ServerTest extends EditServer
{
  public function new()
    {
      super();
      moduleClasses = [ 
        ];
    }


  static var inst: ServerTest;
  static function main() 
    {
      inst = new ServerTest();
      inst.init();

      // called once by hand to handle first query after initialization
      inst.entry();
    }
}
