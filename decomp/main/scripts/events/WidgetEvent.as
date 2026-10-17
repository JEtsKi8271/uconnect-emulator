package events
{
   import com.nfuzion.framework.global.Framework;
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public class WidgetEvent extends Event
   {
      
      public static const LONG_PRESS:String = "events.widgetEvent.longPress";
      
      public static const SELECT:String = "events.widgetEvent.selectRow";
      
      public static const POSITION:String = "events.widgetEvent.position";
      
      public static const HORIZONTAL_POSITION:String = "events.widgetEvent.horizontalPosition";
      
      public static const VERTICAL_POSITION:String = "events.widgetEvent.verticalPosition";
      
      public static const LENGTH:String = "events.widgetEvent.length";
      
      public static const PAGE_SIZE:String = "events.widgetEvent.pageSize";
      
      public static const CLICK:String = "events.widgetEvent.click";
      
      public static const AUTO_CLICK:String = "events.widgetEvent.autoClick";
      
      public static const VISIBILITY:String = "events.WidgetEvents.visibility";
      
      public static const GRAB:String = "events.WidgetsEvents.grab";
      
      public static const RELEASE:String = "events.WidgetsEvents.release";
      
      public static const PRESS:String = "events.WidgetsEvents.press";
      
      public static const SHORT:String = "events.WidgetsEvents.short";
      
      public static const MOVE:String = "events.WidgetsEvents.move";
      
      public var data:*;
      
      public function WidgetEvent(param1:String, param2:* = null, param3:Boolean = false, param4:Boolean = false, param5:Boolean = true)
      {
         super(param1,param3,param4);
         this.data = param2;
         if(Framework.enableInsight)
         {
            if(!param3 && param5 && this.data != null && this.data is DisplayObject && (this.data as DisplayObject).stage != null)
            {
               (this.data as DisplayObject).stage.dispatchEvent(new WidgetEvent(param1,param2,false,false,false));
            }
         }
      }
      
      override public function clone() : Event
      {
         return new WidgetEvent(type,this.data,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("WidgetEvent","type","data","bubbles","cancelable");
      }
   }
}

