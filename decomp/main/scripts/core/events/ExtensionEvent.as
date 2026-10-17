package core.events
{
   import flash.events.Event;
   
   public class ExtensionEvent extends Event
   {
      
      public static const EXTENSION:String = "extension";
      
      public var data:Object;
      
      public function ExtensionEvent(type:String, data:Object, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.data = data;
      }
      
      override public function clone() : Event
      {
         return new MessageEvent(type,this.data,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("MessageEvent","data","type","bubbles","cancelable");
      }
   }
}

