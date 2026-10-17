package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class BeaconDSRCHMIEvent extends Event
   {
      
      public static const MENU_DATA:String = "EventMenuData";
      
      public static const MENU_BUTTON:String = "EventMenuButton";
      
      public static const INTER_BUTTON:String = "EventInterButton";
      
      public static const SWITCH_INTERRUPT_CHARACTER_INFO:String = "EventSwitchInterruptCharacterInfo";
      
      public static const SWITCH_INTERRUPT_FIGURE_INFO:String = "EventSwitchInterruptFigureInfo";
      
      public static const SWITCH_VICS_VOICE_GUIDANCE:String = "EventSwitchVICSVoiceGuidance";
      
      public static const SWITCH_DSRSTTS_ANNOUNCEMENT:String = "EventSwitchDSRSTTSAnnouncement";
      
      public static const SWITCH_DSRS_UPLINK:String = "EventSwitchDSRSUplink";
      
      public static const SWITCH_DISPLAY_TIME:String = "EventSwitchDisplayTime";
      
      public static const START_MENU:String = "EventStartMenu";
      
      public static const DRAW_MENU_TOP_PAGE_TEXT:String = "EventDrawMenuTopPageText";
      
      public static const DRAW_MENU_TOP_PAGE_DIAG:String = "EventDrawMenuTopPageDiag";
      
      public static const DRAW_MENU_TEXT_MSG:String = "EventDrawMenuTextMsg";
      
      public static const DRAW_MENU_DIAG_MSG:String = "EventDrawMenuDiagMsg";
      
      public static const DRAW_MENU_PREV_PAGE:String = "EventDrawMenuPrevPage";
      
      public static const DRAW_MENU_NEXT_PAGE:String = "EventDrawMenuNextPage";
      
      public static const START_MENU_TTS:String = "EventStartMenuTts";
      
      public static const STOP_MENU_TTS:String = "EventStopMenuTts";
      
      public static const FINISH_MENU:String = "EventFinishMenu";
      
      public static const EVENT_START_INTERRUPT:String = "EventEventStartInterrupt";
      
      public static const EVENT_END_INTERRUPT:String = "EventEventEndInterrupt";
      
      public static const DRAW_INTER_TOP_PAGE:String = "EventDrawInterTopPage";
      
      public static const DRAW_INTER_PREV_PAGE:String = "EventDrawInterPrevPage";
      
      public static const DRAW_INTER_NEXT_PAGE:String = "EventDrawInterNextPage";
      
      public static const FINISH_INTERRUPT:String = "EventFinishInterrupt";
      
      public static const PUB_TEXT_RECEIVED_TIME:String = "EventPubTextReceivedTime";
      
      public static const PUB_DIAG_RECEIVED_TIME:String = "EventPubDiagReceivedTime";
      
      public static const EXP_TEXT_RECIEVED_TIME:String = "EventExpTextReceivedTime";
      
      public static const EXP_DIAG_RECIEVED_TIME:String = "EventExpDiagReceivedTime";
      
      public static const EXP_TEXT_TOKEN_CLEAR_FLAG:String = "EventExpTextTokenClearFlag";
      
      public static const EXP_DIAG_TOKEN_CLEAR_FLAG:String = "EventExpDiagTokenClearFlag";
      
      public static const EVENT_INTERRUPT_ACTIVE:String = "EventInterruptPopupActive";
      
      public var mData:Object = null;
      
      public function BeaconDSRCHMIEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

