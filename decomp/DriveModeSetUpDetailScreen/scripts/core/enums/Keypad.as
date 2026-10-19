package core.enums
{
   public dynamic class Keypad
   {
      
      public var id:int = 0;
      
      public var alphabet:int = 0;
      
      public var label:String = "";
      
      public var characters:Array = null;
      
      public function Keypad(param1:int, param2:int, param3:String = "", param4:Array = null)
      {
         this.id = param1;
         this.alphabet = param2;
         this.label = param3;
         this.characters = param4;
         super();
      }
   }
}

