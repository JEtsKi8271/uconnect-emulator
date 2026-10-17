package peripheral
{
   public class PopupRequest
   {
      
      public var uniqueId:int = 0;
      
      public var type:int = 5;
      
      public var timeout:int = 0;
      
      public var title:String = "";
      
      public var message:* = "";
      
      public var caption1:* = "";
      
      public var caption2:* = "";
      
      public var caption3:* = "";
      
      public var showAlways:Boolean = false;
      
      public var showClose:Boolean = false;
      
      public var showOk:Boolean = false;
      
      public var showCancel:Boolean = false;
      
      public var showSearching:Boolean = false;
      
      public var caption1Id:* = 0;
      
      public var caption2Id:* = 0;
      
      public var caption3Id:* = 0;
      
      public function PopupRequest()
      {
         super();
      }
   }
}

