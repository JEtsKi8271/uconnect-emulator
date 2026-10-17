package core.enums
{
   public dynamic class Alphabet
   {
      
      public var id:int = 0;
      
      public var label:String = "";
      
      public var keypad:int = 0;
      
      public var keyboard:int = 0;
      
      public var available:Boolean = true;
      
      public function Alphabet(param1:int, param2:String, param3:int, param4:int)
      {
         this.id = param1;
         this.label = param2;
         this.keypad = param3;
         this.keyboard = param4;
         super();
      }
   }
}

