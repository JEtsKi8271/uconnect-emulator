package core.events
{
   import flash.events.Event;
   
   public class PopupManagerEvent extends Event
   {
      
      public static const SHOW:String = "popupmanager.show";
      
      public static const CLOSE:String = "popupmanager.close";
      
      public static const ACTIVE:String = "popupmanager.active";
      
      public static const REFRESH:String = "popupmanager.refresh";
      
      public static const TIMEOUT:String = "popupmanager.timeout";
      
      public static const EMPTY:String = "popupmanager.empty";
      
      public var address:String;
      
      public var vars:Object;
      
      public function PopupManagerEvent(type:String, branch:String = "", variables:Object = null, bubbles:Boolean = false, cancelable:Boolean = true)
      {
         super(type,bubbles,cancelable);
         this.address = branch;
         this.vars = variables;
      }
      
      override public function clone() : Event
      {
         return new PopupManagerEvent(type,this.address,this.vars,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("PopupManagerEvent","type","address","vars","bubbles","cancelable");
      }
   }
}

