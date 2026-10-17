package core.events
{
   import flash.events.Event;
   
   public class StructureEvent extends Event
   {
      
      public static const GOTO:String = "goto";
      
      public static const AFTER_GOTO:String = "after goto";
      
      public static const ACTIVATE_NAV:String = "activate nav";
      
      public static const LEAVING_NAV:String = "leaving nav";
      
      public static const SCREEN_LOAD_FAILURE:String = "screen load failure";
      
      public static const REFRESH_STRUCTURE:String = "refreshing structure";
      
      public var branch:String;
      
      public var vars:Object;
      
      public function StructureEvent(param1:String, param2:String, param3:Object = null, param4:Boolean = false, param5:Boolean = false)
      {
         super(param1,param4,param5);
         this.branch = param2;
         this.vars = param3;
      }
      
      override public function clone() : Event
      {
         return new StructureEvent(type,this.branch,this.vars,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("StructureEvent","type","branch","vars","bubbles","cancelable");
      }
   }
}

