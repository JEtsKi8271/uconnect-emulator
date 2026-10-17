package core.enums
{
   public dynamic class Keyboard
   {
      
      public var id:int = 0;
      
      public var alphabet:int = 0;
      
      public var name:String = "";
      
      public var label:String = "";
      
      public var extend:String = "";
      
      public var lower:Array = null;
      
      public var upper:Array = null;
      
      public function Keyboard(param1:int, param2:int, param3:String = "", param4:String = "", param5:String = "", param6:Array = null, param7:Array = null)
      {
         this.id = param1;
         this.alphabet = param2;
         this.name = param3;
         this.label = param4;
         this.extend = param5;
         this.lower = param6;
         this.upper = param7;
         super();
      }
   }
}

