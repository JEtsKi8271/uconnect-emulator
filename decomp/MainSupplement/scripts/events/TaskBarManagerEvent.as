package events
{
   import flash.events.Event;
   
   public class TaskBarManagerEvent extends Event
   {
      
      public static const READY:String = "TaskBarManager.Ready";
      
      public static const UPDATE:String = "TaskBarManager.Update";
      
      public static const PERSISTENCY:String = "TaskBarManager.Persistency";
      
      public static const DRAG_AND_DROP:String = "TaskBarManager.DragAndDrop";
      
      public var data:*;
      
      public function TaskBarManagerEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.data = data;
      }
      
      override public function clone() : Event
      {
         return new TaskBarManagerEvent(type,bubbles,this.data,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("TaskBarManagerEvent","type","data","bubbles","cancelable");
      }
   }
}

