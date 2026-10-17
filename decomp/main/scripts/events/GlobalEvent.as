package events
{
   import flash.events.Event;
   
   public class GlobalEvent extends Event
   {
      
      public static const CHECKBOX:String = "Common.CheckBox";
      
      public static const OPTION:String = "Common.Option";
      
      public static const ITEM:String = "Common.Item";
      
      public static const ITEMDISABLED:String = "Common.ItemDisabled";
      
      public static const CATEGORY:String = "Common.Category";
      
      public static const COMMAND:String = "Common.Command";
      
      public static const TRASH:String = "Common.Trash";
      
      public static const INCREMENT:String = "Common.Increment";
      
      public static const OPTIONS_POPUP_CLOSED:String = "OptionsPopup.Closed";
      
      public static const OPTIONS_POPUP_BUTTON:String = "OptionsPopup.Button";
      
      public static const SPELLER_POPUP_CLOSED:String = "SpellerPopup.Closed";
      
      public static const SPELLER_POPUP_OK:String = "SpellerPopup.Ok";
      
      public static const INFO_POPUP_CLOSED:String = "InfoPopup.Closed";
      
      public static const INFO_POPUP_CANCEL:String = "InfoPopup.Cancel";
      
      public static const INFO_POPUP_OK:String = "InfoPopup.Ok";
      
      public static const ONEITEM_POPUP_CLOSED:String = "OneItemPopup.Closed";
      
      public static const ONEITEM_POPUP_CONFIRMATION:String = "OneItemPopup.Confirmation";
      
      public static const TWOITEM_POPUP_CLOSED:String = "TwoItemPopup.Closed";
      
      public static const TWOITEM_POPUP_LEFT_CLICK:String = "TwoItemPopup.LeftClick";
      
      public static const TWOITEM_POPUP_RIGHT_CLICK:String = "TwoItemPopup.RightClick";
      
      public static const THREEITEM_POPUP_CLOSED:String = "ThreeItemPopup.Closed";
      
      public static const THREEITEM_POPUP_LEFT_CLICK:String = "ThreeItemPopup.LeftClick";
      
      public static const THREEITEM_POPUP_CENTER_CLICK:String = "ThreeItemPopup.CenterClick";
      
      public static const THREEITEM_POPUP_RIGHT_CLICK:String = "ThreeItemPopup.RightClick";
      
      public static const FOURITEM_POPUP_CLOSED:String = "FourItemPopup.Closed";
      
      public static const FOURITEM_POPUP_BUTTON:String = "FourItemPopup.Button";
      
      public static const SPEED_LOCKOUT_POPUP_USERCLOSED:String = "SpeedLockoutPopup.UserClosed";
      
      public static const APP_SPELLER_POPUP_CLOSED:String = "AppSpellerPopupClosed";
      
      public static const CONTROLS_POPUP_CLOSED:String = "ControlsPopupClosed";
      
      public static const SCROLLING_POPUP_CLOSED:String = "ScrollingPopupClosed";
      
      public var data:*;
      
      public function GlobalEvent(type:String, data:* = null, bubbles:Boolean = true, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.data = data;
      }
      
      override public function clone() : Event
      {
         return new GlobalEvent(type,this.data,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("GlobalEvent","type","data","bubbles","cancelable");
      }
   }
}

