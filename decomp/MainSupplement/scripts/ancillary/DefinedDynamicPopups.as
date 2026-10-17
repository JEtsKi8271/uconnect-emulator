package ancillary
{
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLinkAPI.TunerRegion;
   import core.enums.PopupType;
   import events.GlobalEvent;
   import flash.events.MouseEvent;
   import locale.T;
   import peripheral.Peripheral;
   
   public class DefinedDynamicPopups
   {
      
      public function DefinedDynamicPopups()
      {
         super();
      }
      
      public function show(popupID:String) : void
      {
         switch(popupID)
         {
            case DynamicPopupNames.ADJUST_CLOCK_SETTINGS:
               Framework.popupManager.show(DynamicPopupNames.ERROR_ALERT,"errorpopupscreen",{
                  "id":DynamicPopupNames.ADJUST_CLOCK_SETTINGS,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_CLOCK_BREADCRUMB,
                  "body":T.STRB_ERROR_BODY_TIME,
                  "buttonHandler":this.onAdjustClockSettingsButtonClicks,
                  "closeButton":true,
                  "timeout":Style.DEFAULT_POPUP_TIMEOUT
               });
               break;
            case DynamicPopupNames.AUDIO_FAVORITES_ARE_FULL:
               Framework.popupManager.show(DynamicPopupNames.ERROR_ALERT,"errorpopupscreen",{
                  "id":DynamicPopupNames.AUDIO_FAVORITES_ARE_FULL,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_ERROR_TITLE_FAVORITES,
                  "body":T.STRB_ERROR_BODY_FAVORITES_FULL,
                  "buttonHandler":this.onAudioFavoritesFullButtonClicks,
                  "closeButton":true,
                  "timeout":Style.DEFAULT_POPUP_TIMEOUT
               });
               break;
            case DynamicPopupNames.DELETE_ALL_AUDIO_FAVORITES:
               Framework.popupManager.show(DynamicPopupNames.ERROR_ALERT,"errorpopupscreen",{
                  "id":DynamicPopupNames.DELETE_ALL_AUDIO_FAVORITES,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_ERROR_TITLE_FAVORITES,
                  "body":T.STRB_ERROR_BODY_DELETE_AUDIO_FAVORITES,
                  "buttonHandler":this.onDeleteAllAudioFavoritesButtonClicks,
                  "closeButton":true,
                  "timeout":Style.DEFAULT_POPUP_TIMEOUT
               });
               break;
            case DynamicPopupNames.DELETE_ALL_TEAM_FAVORITES:
               Framework.popupManager.show(DynamicPopupNames.ERROR_ALERT,"errorpopupscreen",{
                  "id":DynamicPopupNames.DELETE_ALL_TEAM_FAVORITES,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_ERROR_TITLE_FAVORITE_TEAMS,
                  "body":T.STRB_ERROR_BODY_DELETE_TEAM_FAVORITES,
                  "buttonHandler":this.onDeleteAllTeamFavoritesButtonClicks,
                  "closeButton":true,
                  "timeout":Style.DEFAULT_POPUP_TIMEOUT
               });
               break;
            case DynamicPopupNames.DOWNLOADING_MESSAGE:
               Framework.popupManager.show(DynamicPopupNames.ERROR_ALERT,"errorpopupscreen",{
                  "id":DynamicPopupNames.DOWNLOADING_MESSAGE,
                  "type":PopupType.PRIMARY,
                  "title":"",
                  "body":T.STRB_ERROR_BODY_PLEASE_WAIT,
                  "closeButton":false,
                  "timeout":false
               });
               break;
            case DynamicPopupNames.DOWNLOADING_FUEL:
               Framework.popupManager.show(DynamicPopupNames.ERROR_ALERT,"errorpopupscreen",{
                  "id":DynamicPopupNames.DOWNLOADING_MESSAGE,
                  "type":PopupType.PRIMARY,
                  "title":"",
                  "body":T.STRB_ERROR_BODY_ACQUIRING_DATA,
                  "closeButton":false,
                  "timeout":false
               });
               break;
            case DynamicPopupNames.FAVORITE_TEAMS_LIST_FULL:
               Framework.popupManager.show(DynamicPopupNames.ERROR_ALERT,"errorpopupscreen",{
                  "id":DynamicPopupNames.FAVORITE_TEAMS_LIST_FULL,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_ERROR_TITLE_FAVORITE_TEAMS,
                  "body":T.STRB_ERROR_BODY_TEAMS_LIST_FULL,
                  "buttonHandler":this.onFavoriteTeamsListFullButtonClicks,
                  "closeButton":true,
                  "timeout":Style.DEFAULT_POPUP_TIMEOUT
               });
               break;
            case DynamicPopupNames.SATELLITE_AUDIO_ANTENNA_OPEN_OR_SHORT_CIRCUIT_CONDITION:
               Framework.popupManager.show(DynamicPopupNames.ERROR_ALERT,"errorpopupscreen",{
                  "id":DynamicPopupNames.SATELLITE_AUDIO_ANTENNA_OPEN_OR_SHORT_CIRCUIT_CONDITION,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_ERROR_TITLE_SIRIUS,
                  "body":T.STRB_ERROR_BODY_NO_SIGNAL,
                  "closeButton":false,
                  "timeout":false
               });
               break;
            case DynamicPopupNames.SIRIUS_AUDIO_SKIPPED_CHANNEL:
               Framework.popupManager.show(DynamicPopupNames.SMALL,"smallpopupscreen",{
                  "id":popupID,
                  "type":PopupType.PRIMARY,
                  "title":"",
                  "body":T.STRB_ERROR_BODY_SKIPPED_CHANNEL,
                  "closeButton":false,
                  "timeout":Style.SKIPPED_CHANNEL_POPUP_TIMEOUT
               });
               break;
            case DynamicPopupNames.SIRIUS_AUDIO_CHANNEL_NOT_SUBSCRIBED:
               Framework.popupManager.show(DynamicPopupNames.SMALL,"smallpopupscreen",{
                  "id":popupID,
                  "type":PopupType.PRIMARY,
                  "title":"",
                  "body":T.STRB_ERROR_BODY_NOT_SUBSCRIBED,
                  "closeButton":false,
                  "timeout":Style.SKIPPED_CHANNEL_POPUP_TIMEOUT
               });
               break;
            case DynamicPopupNames.SUBSCRIPTION_UPDATE:
               Framework.popupManager.show(DynamicPopupNames.ERROR_ALERT,"errorpopupscreen",{
                  "id":DynamicPopupNames.SUBSCRIPTION_UPDATE,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_ERROR_TITLE_SIRIUS,
                  "body":T.STRB_ERROR_BODY_SUBSCRIPTION_UPDATING,
                  "closeButton":false,
                  "timeout":false
               });
               break;
            case DynamicPopupNames.TRAFFIC_AND_WEATHER_JUMP_UNDEFINED:
               Framework.popupManager.show(DynamicPopupNames.ERROR_ALERT,"errorpopupscreen",{
                  "id":DynamicPopupNames.TRAFFIC_AND_WEATHER_JUMP_UNDEFINED,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_ERROR_TITLE_TRAFFIC_AND_WEATHER,
                  "body":T.STRB_ERROR_BODY_TRAFFIC_AND_WEATHER,
                  "buttonHandler":this.onTrafficAndWeatherJumpUndefinedButtonClicks,
                  "closeButton":true,
                  "timeout":Style.DEFAULT_POPUP_TIMEOUT
               });
               break;
            case DynamicPopupNames.MAXIMUM_TIME_FOR_RADIO_PAUSE:
               Framework.popupManager.show(DynamicPopupNames.ERROR_ALERT,"errorpopupscreen",{
                  "id":DynamicPopupNames.MAXIMUM_TIME_FOR_RADIO_PAUSE,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_ERROR_TITLE_SAT_REPLAY,
                  "body":T.STRB_ERROR_BODY_SAT_REPLAY,
                  "buttonHandler":this.onMaximumTimeForRadioPauseButtonClicks,
                  "closeButton":true,
                  "timeout":false
               });
               break;
            case DynamicPopupNames.TRAVELLINK_ADD_TO_FAVORITES:
               Framework.popupManager.show(DynamicPopupNames.ERROR_ALERT,"errorpopupscreen",{
                  "id":DynamicPopupNames.TRAVELLINK_ADD_TO_FAVORITES,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_ERROR_TITLE_ADD,
                  "body":T.STRB_ERROR_BODY_TITLE_ADD,
                  "buttonHandler":this.onAddToFavoritesButtonClicks,
                  "closeButton":true,
                  "timeout":Style.DEFAULT_POPUP_TIMEOUT
               });
               break;
            case DynamicPopupNames.SPEED_LOCKOUT:
               Framework.popupManager.show(DynamicPopupNames.ERROR_ALERT,"errorpopupscreen",{
                  "id":DynamicPopupNames.SPEED_LOCKOUT,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_ERROR_TITLE_SPEED_LOCKOUT,
                  "body":T.STRB_ERROR_BODY_SPEED_LOCKOUT,
                  "buttonHandler":this.onSpeedLockoutButtonClicks,
                  "closeButton":false,
                  "timeout":Style.SPEED_LOCKOUT_POPUP_TIMEOUT
               });
               break;
            case DynamicPopupNames.TRAVELLINK_WEATHER_PLEASE_WAIT:
               Framework.popupManager.show(DynamicPopupNames.ERROR_ALERT,"errorpopupscreen",{
                  "id":DynamicPopupNames.TRAVELLINK_WEATHER_PLEASE_WAIT,
                  "type":PopupType.PRIMARY,
                  "title":"",
                  "body":T.STRB_ERROR_BODY_PLEASE_WAIT,
                  "closeButton":false,
                  "timeout":Style.TL_WEATHER_POPUP_TIMEOUT
               });
               break;
            case DynamicPopupNames.SMS_MSG_NOT_SUPPORTED:
               Framework.popupManager.show(DynamicPopupNames.ERROR_ALERT,"errorpopupscreen",{
                  "id":DynamicPopupNames.SMS_MSG_NOT_SUPPORTED,
                  "type":PopupType.PRIMARY,
                  "title":"",
                  "body":T.STRB_ERROR_BODY_PHONE_NOT_SUPPORTED,
                  "buttonHandler":this.onSmsNotSupported,
                  "closeButton":false,
                  "timeout":Style.DEFAULT_POPUP_TIMEOUT
               });
               break;
            case DynamicPopupNames.AUDIO_MUTED:
               if(Framework.resolution == "800x480")
               {
                  Framework.popupManager.show(DynamicPopupNames.ERROR_ALERT,"errorpopupscreen",{
                     "type":PopupType.PRIMARY,
                     "id":DynamicPopupNames.AUDIO_MUTED,
                     "title":"",
                     "body":T.STRB_ERROR_BODY_MUSIC_MUTED,
                     "closeButton":false,
                     "timeout":Style.AUDIO_MUTED_POPUP_TIMEOUT
                  });
               }
               else
               {
                  Framework.popupManager.show(DynamicPopupNames.MUTE,Screens.POPUP_MUTE,{
                     "type":PopupType.PRIMARY,
                     "id":DynamicPopupNames.AUDIO_MUTED,
                     "timeout":Style.AUDIO_MUTED_POPUP_TIMEOUT
                  });
               }
               break;
            case DynamicPopupNames.TAGGING_SONG_TAGGED:
               Framework.popupManager.show(DynamicPopupNames.ERROR_ALERT,"errorpopupscreen",{
                  "id":DynamicPopupNames.TAGGING_SONG_TAGGED,
                  "title":T.STRB_ERROR_TITLE_SONG_TAGGED,
                  "body":T.STRB_ERROR_BODY_SONG_TAGGED,
                  "closeButton":false,
                  "timeout":Style.DEFAULT_POPUP_TIMEOUT
               });
               break;
            case DynamicPopupNames.TAGGING_QUEUE_FULL:
               Framework.popupManager.show(DynamicPopupNames.ERROR_ALERT,"errorpopupscreen",{
                  "id":DynamicPopupNames.TAGGING_QUEUE_FULL,
                  "title":"",
                  "body":T.STRB_ERROR_BODY_CONNECT_IPOD,
                  "closeButton":false,
                  "timeout":Style.DEFAULT_POPUP_TIMEOUT
               });
               break;
            case DynamicPopupNames.TAGGING_QUEUE_FULL_IPOD_INCOMPATIBLE:
               Framework.popupManager.show(DynamicPopupNames.ERROR_ALERT,"errorpopupscreen",{
                  "id":DynamicPopupNames.TAGGING_QUEUE_FULL_IPOD_INCOMPATIBLE,
                  "title":"",
                  "body":T.STRB_ERROR_BODY_CONNECT_IPOD_COMPATIBLE,
                  "closeButton":false,
                  "timeout":Style.DEFAULT_POPUP_TIMEOUT
               });
               break;
            case DynamicPopupNames.TAGGING_TRANSFER:
               Framework.popupManager.show(DynamicPopupNames.ERROR_ALERT,"errorpopupscreen",{
                  "id":DynamicPopupNames.TAGGING_TRANSFER,
                  "title":"",
                  "body":T.STRB_ERROR_BODY_TRANSFERRING_TAGS,
                  "closeButton":false,
                  "timeout":Style.DEFAULT_POPUP_TIMEOUT
               });
               break;
            case DynamicPopupNames.TAGGING_TRANSFER_ERROR:
               Framework.popupManager.show(DynamicPopupNames.ERROR_ALERT,"errorpopupscreen",{
                  "id":DynamicPopupNames.TAGGING_TRANSFER_ERROR,
                  "title":"",
                  "body":T.STRB_ERROR_BODY_TRANSFER_ERROR,
                  "closeButton":false,
                  "timeout":Style.DEFAULT_POPUP_TIMEOUT
               });
               break;
            case DynamicPopupNames.TAGGING_IPOD_FULL:
               Framework.popupManager.show(DynamicPopupNames.ERROR_ALERT,"errorpopupscreen",{
                  "id":DynamicPopupNames.TAGGING_IPOD_FULL,
                  "title":"",
                  "body":T.STRB_ERROR_BODY_MEMORY_FULL,
                  "closeButton":false,
                  "timeout":Style.DEFAULT_POPUP_TIMEOUT
               });
               break;
            case DynamicPopupNames.TAGGING_SONG_TAGGED_IPOD_FULL:
               Framework.popupManager.show(DynamicPopupNames.ERROR_ALERT,"errorpopupscreen",{
                  "id":DynamicPopupNames.TAGGING_SONG_TAGGED_IPOD_FULL,
                  "title":"",
                  "body":T.STRB_ERROR_BODY_TAGGED_BUT_FULL,
                  "closeButton":false,
                  "timeout":Style.DEFAULT_POPUP_TIMEOUT
               });
               break;
            case DynamicPopupNames.TAGGING_SONG_TAGGED_IPOD_INCOMPATIBLE:
               Framework.popupManager.show(DynamicPopupNames.ERROR_ALERT,"errorpopupscreen",{
                  "id":DynamicPopupNames.TAGGING_SONG_TAGGED_IPOD_INCOMPATIBLE,
                  "title":"",
                  "body":T.STRB_ERROR_BODY_SONG_TAGGED_CONNECT,
                  "closeButton":false,
                  "timeout":Style.DEFAULT_POPUP_TIMEOUT
               });
               break;
            case DynamicPopupNames.TAGGING_IPOD_INCOMPATIBLE:
               Framework.popupManager.show(DynamicPopupNames.ERROR_ALERT,"errorpopupscreen",{
                  "id":DynamicPopupNames.TAGGING_IPOD_INCOMPATIBLE,
                  "title":"",
                  "body":T.STRB_ERROR_BODY_NO_TAGGING_SUPPORT,
                  "closeButton":false,
                  "timeout":Style.DEFAULT_POPUP_TIMEOUT
               });
               break;
            case DynamicPopupNames.TAGGING_TWO_IPODS:
               Framework.popupManager.show(DynamicPopupNames.ERROR_ALERT,"errorpopupscreen",{
                  "id":DynamicPopupNames.TAGGING_TWO_IPODS,
                  "title":"",
                  "body":T.STRB_ERROR_BODY_TAG_TWO_IPODS,
                  "closeButton":false,
                  "timeout":Style.DEFAULT_POPUP_TIMEOUT
               });
               break;
            case DynamicPopupNames.DISPLAY_HOT_WARNING:
               Framework.popupManager.show(DynamicPopupNames.ERROR_ALERT,"errorpopupscreen",{
                  "id":DynamicPopupNames.DISPLAY_HOT_WARNING,
                  "title":T.STRB_ERROR_TITLE_WARNING,
                  "body":T.STRB_ERROR_BODY_DISPLAY_HOT,
                  "closeButton":false,
                  "timeout":Style.TEN_SECOND_POPUP_TIMEOUT
               });
               break;
            case DynamicPopupNames.FUNCTION_CURR_NOT_AVAIL:
               Framework.popupManager.show(DynamicPopupNames.ERROR_ALERT,"errorpopupscreen",{
                  "id":DynamicPopupNames.FUNCTION_CURR_NOT_AVAIL,
                  "type":PopupType.PRIMARY,
                  "title":" ",
                  "body":T.STRB_FUNCTION_CURRENTLY_NOT_AVAIL,
                  "buttonHandler":this.onFunctionNotSupported,
                  "closeButton":false,
                  "timeout":Style.DEFAULT_POPUP_TIMEOUT
               });
         }
      }
      
      private function onAudioFavoritesFullButtonClicks(evt:MouseEvent) : void
      {
         switch(evt.currentTarget.name)
         {
            case "editFavs_button":
               Framework.structure.goto(Screens.BROWSE_SAT,{"state":"removeFavorites"});
            case "cancel_button":
               Framework.popupManager.dequeue(DynamicPopupNames.ERROR_ALERT);
         }
      }
      
      private function onAdjustClockSettingsButtonClicks(evt:MouseEvent) : void
      {
         switch(evt.currentTarget.name)
         {
            case "yes_button":
               Peripheral.navigation.navDomainControl.exitNavDomain();
               Framework.structure.goto(Screens.SETTINGS_CLOCK,{"enableExit":false});
            case "no_button":
               Framework.popupManager.dequeue(DynamicPopupNames.ERROR_ALERT);
         }
      }
      
      private function onAddToFavoritesButtonClicks(evt:MouseEvent) : void
      {
         var objectToSend:Object = {"type":"Travel Link"};
         switch(evt.currentTarget.name)
         {
            case "yes_button":
               objectToSend.reply = "Yes";
               break;
            case "no_button":
               objectToSend.reply = "No";
         }
         Framework.messenger.send(objectToSend);
         Framework.popupManager.dequeue(DynamicPopupNames.ERROR_ALERT);
      }
      
      private function onDeleteAllAudioFavoritesButtonClicks(evt:MouseEvent) : void
      {
         switch(evt.currentTarget.name)
         {
            case "yes_button":
               Peripheral.satelliteRadio.deleteAllFavorites();
               Peripheral.satelliteRadio.requestFavorites();
            case "cancel_button":
               Framework.popupManager.dequeue(DynamicPopupNames.ERROR_ALERT);
         }
      }
      
      private function onDeleteAllTeamFavoritesButtonClicks(evt:MouseEvent) : void
      {
         switch(evt.currentTarget.name)
         {
            case "yes_button":
               Peripheral.satelliteRadio.removeAllTeams();
               Peripheral.satelliteRadio.requestFavoriteTeamsList();
            case "cancel_button":
               Framework.popupManager.dequeue(DynamicPopupNames.ERROR_ALERT);
         }
      }
      
      private function onDriveModeOneItemClicks(evt:MouseEvent) : void
      {
         switch(evt.currentTarget.name)
         {
            case "ok_button":
               Framework.popupManager.dequeue(DynamicPopupNames.DRIVEMODE_ONE_ITEM_POPUP);
               break;
            default:
               Framework.Trace("onDriveModeOneItemClicks: unknown button name");
         }
      }
      
      private function onFavoriteTeamsListFullButtonClicks(evt:MouseEvent) : void
      {
         switch(evt.currentTarget.name)
         {
            case "ok_button":
               Framework.popupManager.dequeue(DynamicPopupNames.ERROR_ALERT);
         }
      }
      
      private function onTrafficAndWeatherJumpUndefinedButtonClicks(evt:MouseEvent) : void
      {
         switch(evt.currentTarget.name)
         {
            case "yes_button":
               Framework.structure.goto(Screens.BROWSE_SAT,{"state":"jumpchannels"});
            case "no_button":
               Framework.popupManager.dequeue(DynamicPopupNames.ERROR_ALERT);
         }
      }
      
      private function onMaximumTimeForRadioPauseButtonClicks(evt:MouseEvent) : void
      {
         switch(evt.currentTarget.name)
         {
            case "ok_button":
               Framework.popupManager.dequeue(DynamicPopupNames.ERROR_ALERT);
         }
      }
      
      private function onSpeedLockoutButtonClicks(evt:MouseEvent) : void
      {
         Framework.Trace("@@@@@@@$$$$$$$$SpeedLockout closed due to button click. Cancel timeout");
         Framework.popupManager.setTimeout(0);
         switch(evt.currentTarget.name)
         {
            case "ok_button":
               Framework.popupManager.dequeue(DynamicPopupNames.ERROR_ALERT);
               Framework.popupManager.dispatch(GlobalEvent.SPEED_LOCKOUT_POPUP_USERCLOSED);
         }
      }
      
      private function onSmsNotSupported(evt:MouseEvent) : void
      {
         switch(evt.currentTarget.name)
         {
            case "ok_button":
               Framework.popupManager.dequeue(DynamicPopupNames.ERROR_ALERT);
         }
      }
      
      public function popup(identifier:int, variables:Object = null) : void
      {
         var message:String = null;
         switch(identifier)
         {
            case DynamicPopupNames.ONEITEM_WIFI_NEEDS_TO_BE_DISABLED:
               Framework.popupManager.show(identifier,"popup1item",{
                  "timeout":5000,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_WIFI_HOTSPOT,
                  "message":[T.STRB_WIFI_HOTSPOT_NEEDS_2B_DISABLED],
                  "caption1":T.STRB_OK,
                  "showClose":true
               });
               break;
            case DynamicPopupNames.ONEITEM_WIFI_IS_DISABLED:
               Framework.popupManager.show(identifier,"popup1item",{
                  "timeout":5000,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_WIFI_HOTSPOT,
                  "message":[T.STRB_WIFI_HOTSPOT_CURRENTLY_DISABLED],
                  "caption1":T.STRB_OK,
                  "showClose":true
               });
               break;
            case DynamicPopupNames.ONEITEM_ASSIST_WILL_LOAD_SHORTLY:
               Framework.popupManager.show(identifier,"popup1item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_SU_ERROR,
                  "message":["\n",T.STRB_SYSTEM_IS_WORKING,".."],
                  "caption1":T.STRB_OK,
                  "showClose":false
               });
               break;
            case DynamicPopupNames.ONEITEM_NAV_LIVE_SERVICES_ROUTE_OPTIMIZED:
               Framework.popupManager.show(identifier,"popup1item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_NAVIGATION,
                  "message":[T.STRB_CURRENT_ROUTE_IS_ALREADY],
                  "caption1":T.STRB_OK,
                  "showClose":false
               });
               break;
            case DynamicPopupNames.ONEITEM_NAV_LIVE_SERVICES_ERROR_MESSAGE:
               Framework.popupManager.show(identifier,"popup1item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_NAVIGATION,
                  "message":variables.message,
                  "caption1":T.STRB_OK,
                  "showClose":false
               });
               break;
            case DynamicPopupNames.ONEITEM_NAV_LIVE_SERVICES_NOT_AVAILABLE:
               Framework.popupManager.show(identifier,"popup1item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_NAVIGATION,
                  "message":[T.STRB_LIVE_SERVICES_ARE_NOT_ML],
                  "caption1":T.STRB_OK,
                  "showClose":false
               });
               break;
            case DynamicPopupNames.ONEITEM_WIFI_NETWORK_LIST_FULL:
               Framework.popupManager.show(identifier,"popup1item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_WIFI_NETWORK,
                  "message":[T.STRB_CANNOT_ADD_NETWORK,"\n\n",T.STRB_FAVORITE_NETWORKS_LIST_FULL,"\n",T.STRB_DELETE_UNUSED_NETWORKS],
                  "caption1":T.STRB_OK,
                  "showClose":false
               });
               break;
            case DynamicPopupNames.ONEITEM_WIFI_SUCCESSFULL:
               Framework.popupManager.show(identifier,"popup1item",{
                  "timeout":0,
                  "minimum":2000,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_WIFI_NETWORK,
                  "message":[T.STRB_WIFI_CONNECTION_SUCCESSFULL,"\n" + variables.SSID],
                  "caption1":T.STRB_OK,
                  "showClose":false
               });
               break;
            case DynamicPopupNames.ONEITEM_NAV_CAUTION_UNVERIFIED_MAP_DATA:
               Framework.popupManager.show(identifier,"popup1item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_NAVIGATION,
                  "message":[T.STRB_ENTERING_AREA_WITH_UNVERIFIED_MAP_DATA,"\n",T.STRB_PLEASE_DRIVE_CAREFULLY],
                  "caption1":T.STRB_OK,
                  "label":T.STRB_OK
               });
               break;
            case DynamicPopupNames.ONEITEM_NAV_CAUTION_IN_CASE_OF_EMERGENCY:
               Framework.popupManager.show(identifier,"popup1item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_NAVIGATION,
                  "message":["\n",T.STRB_IN_CASE_OF_EMERGENCY],
                  "caption1":T.STRB_OK,
                  "showClose":false
               });
               break;
            case DynamicPopupNames.ONEITEM_NAV_INFO_MESSAGE:
               Framework.popupManager.show(identifier,"popup1item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_NAVIGATION,
                  "message":["\n" + variables.info],
                  "caption1":T.STRB_OK,
                  "label":T.STRB_OK
               });
               break;
            case DynamicPopupNames.ONEITEM_NAV_TMC_REROUTE_EXPIRED:
               Framework.popupManager.show(identifier,"popup1item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_NAVIGATION,
                  "message":["\n",T.STRB_EVENT_EXPIRED],
                  "caption1":T.STRB_OK,
                  "label":T.STRB_OK
               });
               break;
            case DynamicPopupNames.ONEITEM_NAV_ETC_DSRC:
               Framework.popupManager.show(identifier,"popup1item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_DSRC_DEVICE_INFO,
                  "message":[variables.message],
                  "caption1":T.STRB_OK,
                  "label":T.STRB_OK,
                  "size":520,
                  "align":"left"
               });
               break;
            case DynamicPopupNames.ONEITEM_NAV_ETC_HISTORY:
               Framework.popupManager.show(identifier,"popup1item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_ETC,
                  "message":[variables.message],
                  "caption1":T.STRB_OK,
                  "label":T.STRB_OK,
                  "size":520,
                  "align":"left"
               });
               break;
            case DynamicPopupNames.ONEITEM_PLAYER_BTSA_NOT_AVAILABLE:
               Framework.popupManager.show(identifier,"popup1item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_BLUETOOTH,
                  "message":["\n",T.STRB_BTSA_AND_USB_DISALLOWED],
                  "caption1":T.STRB_OK,
                  "showClose":false
               });
               break;
            case DynamicPopupNames.ONEITEM_MEDIA_TRKSESSION_UNPLAYABLE:
               Framework.popupManager.show(identifier,"popup1item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_PLAYER_TRACK,
                  "message":["\n",T.STRB_ERROR_SELECTED_TRACK_NOT_PLAYABLE],
                  "caption1":T.STRB_OK,
                  "showClose":false
               });
               break;
            case DynamicPopupNames.SMS_SPEED_LOCKOUT:
               Framework.popupManager.show(identifier,"popup1item",{
                  "timeout":8000,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_ERROR_TITLE_SPEED_LOCKOUT,
                  "message":["\n",T.STRB_ERROR_SMS_SPEED_LOCKOUT],
                  "caption1":T.STRB_OK,
                  "showClose":false
               });
               break;
            case DynamicPopupNames.ONEITEM_NAV_CAUTION_NO_MATCH_ADDRESS:
               Framework.popupManager.show(identifier,"popup1item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_NAVIGATION,
                  "message":["\n",T.STRB_NO_MATCHING_ADDRESS],
                  "caption1":T.STRB_OK,
                  "showClose":false
               });
               break;
            case DynamicPopupNames.INFO_POI_SEARCH_AREA_CITY_INVALID:
               Framework.popupManager.show(identifier,"errorpopupscreen",{
                  "timeout":Style.DEFAULT_POPUP_TIMEOUT,
                  "type":PopupType.SECONDARY,
                  "title":T.STRB_NAVIGATION,
                  "body":["\n\n",T.STRB_NAVI_DESTINATION_INVALID]
               });
               break;
            case DynamicPopupNames.SMS_DICTATION_ABORTED:
               Framework.popupManager.show(identifier,"errorpopupscreen",{
                  "timeout":Style.DEFAULT_POPUP_TIMEOUT,
                  "type":PopupType.SECONDARY,
                  "title":"",
                  "body":["\n",T.STRB_ERROR_APPS_FEAT_NOT_AVAIL]
               });
               break;
            case DynamicPopupNames.TWOITEM_WIFI_DELETE_NETWORK:
               Framework.popupManager.show(identifier,"popup2item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_WIFI_NETWORK,
                  "message":[T.STRB_DELETE_WIFI_NETWORK,"\n\n" + variables.network],
                  "caption1":T.STRB_YES,
                  "caption2":T.STRB_CANCEL,
                  "showClose":false
               });
               break;
            case DynamicPopupNames.TWOITEM_WIFI_NOT_SUCCESSFUL:
               Framework.popupManager.show(identifier,"popup2item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_WIFI_NETWORK,
                  "message":[T.STRB_WIFI_CONNECTION_NOT_SUCCESSFULL,"\n\n",T.STRB_ASK_WOULD_YOU_LIKE_TO_TRY_AGAIN],
                  "caption1":T.STRB_YES,
                  "caption2":T.STRB_NO,
                  "showClose":false
               });
               break;
            case DynamicPopupNames.TWOITEM_WIFI_MAKE_FAVORITE:
               Framework.popupManager.show(identifier,"popup2item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_WIFI_NETWORK,
                  "message":[T.STRB_WIFI_CONNECTION_SUCCESSFULL,"\n" + variables.network + "\n\n",T.STRB_ASK_MAKE_THIS_NETWORK_YOUR_FAVORITE],
                  "caption1":T.STRB_YES,
                  "caption2":T.STRB_NO,
                  "showClose":false
               });
               break;
            case DynamicPopupNames.TWOITEM_NAV_ASK_TO_CLEAR_HOME:
               Framework.popupManager.show(identifier,"popup2item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_NAVIGATION,
                  "message":T.STRB_ASK_CLEAR_HOME_ADDRESS,
                  "caption1":T.STRB_YES,
                  "caption2":T.STRB_NO,
                  "showClose":false
               });
               break;
            case DynamicPopupNames.TWOITEM_NAV_ASK_DELETE_ALL_DESTINATIONS:
               Framework.popupManager.show(identifier,"popup2item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_NAVIGATION,
                  "message":(variables != null && variables.hasOwnProperty("message") ? variables.message : T.STRB_ASK_DELETE_ALL_DESTINATIONS),
                  "caption1":T.STRB_YES,
                  "caption2":T.STRB_NO,
                  "showClose":false
               });
               break;
            case DynamicPopupNames.TWOITEM_NAV_ASK_START_COPY_OF_DATABASE_INFO_TO_USB:
               Framework.popupManager.show(identifier,"popup2item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_NAVIGATION,
                  "message":T.STRB_ASK_START_COPY_NAVIGATION_DATABASE_INFORMATION,
                  "caption1":T.STRB_YES,
                  "caption2":T.STRB_NO,
                  "showClose":false
               });
               break;
            case DynamicPopupNames.TWOITEM_NAV_ASK_DELETE_ALL_TRIPS:
               Framework.popupManager.show(identifier,"popup2item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_NAVIGATION,
                  "message":(variables != null && variables.hasOwnProperty("message") ? variables.message : T.STRB_ASK_DELETE_ALL_TRIPS),
                  "caption1":T.STRB_YES,
                  "caption2":T.STRB_NO,
                  "showClose":false
               });
               break;
            case DynamicPopupNames.TWOITEM_NAV_ASK_REMOVE_ALL_DESTINATIONS:
               Framework.popupManager.show(identifier,"popup2item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_NAVIGATION,
                  "message":(variables != null && variables.hasOwnProperty("message") ? variables.message : T.STRB_ASK_REMOVE_ALL_DESTINATIONS),
                  "caption1":T.STRB_YES,
                  "caption2":T.STRB_NO,
                  "showClose":false
               });
               break;
            case DynamicPopupNames.TWOITEM_NAV_ASK_ENTER_HOME_ADDRESS_NOW:
               Framework.popupManager.show(identifier,"popup2item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_NAVIGATION,
                  "message":[T.STRB_NO_HOME_ADDRESS_ENTERED,"\n",T.STRB_ASK_DO_YOU_WANT_TO_ENTER_IT_NOW],
                  "caption1":T.STRB_YES,
                  "caption2":T.STRB_NO,
                  "showClose":false
               });
               break;
            case DynamicPopupNames.TWOITEM_NAV_ASK_ENTER_WORK_ADDRESS_NOW:
               Framework.popupManager.show(identifier,"popup2item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_NAVIGATION,
                  "message":[T.STRB_NO_WORK_ADDRESS,"\n",T.STRB_ASK_DO_YOU_WANT_TO_ENTER_IT_NOW],
                  "caption1":T.STRB_YES,
                  "caption2":T.STRB_NO,
                  "showClose":false
               });
               break;
            case DynamicPopupNames.TWOITEM_NAV_LIVE_SERVICES_IS_TURNED_OFF:
               Framework.popupManager.show(identifier,"popup2item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_NAVIGATION,
                  "message":[T.STRB_LIVE_SERVICES_TURNED_OFF,"\n",T.STRB_DO_YOU_WANT_TO_TURN_ON],
                  "caption1":T.STRB_YES,
                  "caption2":T.STRB_NO,
                  "showClose":false
               });
               break;
            case DynamicPopupNames.TWOITEM_NAV_ASK_DELETE_ALL_TRAILS:
               Framework.popupManager.show(identifier,"popup2item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_NAVIGATION,
                  "message":T.STRB_ASK_DELETE_ALL_TRAILS,
                  "caption1":T.STRB_YES,
                  "caption2":T.STRB_NO,
                  "showClose":true
               });
               break;
            case DynamicPopupNames.TWOITEM_NAV_ASK_STOP_GUIDANCE:
               Framework.popupManager.show(identifier,"popup2item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_NAVIGATION,
                  "message":T.STRB_ASK_STOP_GUIDANCE,
                  "caption1":T.STRB_YES,
                  "caption2":T.STRB_NO,
                  "showClose":true
               });
               break;
            case DynamicPopupNames.TWOITEM_NAV_FEATURE_WARNING_MESSAGE:
               Framework.popupManager.show(identifier,"popup2item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_NAVIGATION,
                  "message":["\n" + variables.info],
                  "caption1":T.STRB_IGNORE,
                  "caption2":T.STRB_SU_DISABLE,
                  "showClose":false
               });
               break;
            case DynamicPopupNames.TWOITEM_MEDIA_INSERT_CONFIRM:
               Framework.popupManager.show(identifier,"popup2item",{
                  "timeout":5000,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_AUDIO,
                  "message":[T.STRB_ASK_PLAY_CONTENT_FROM,variables.source],
                  "caption1":T.STRB_YES,
                  "caption2":T.STRB_NO,
                  "showClose":true
               });
               break;
            case DynamicPopupNames.TWOITEM_REQUEST_ASSIST:
               Framework.popupManager.show(identifier,"popup2item",{
                  "timeout":5000,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_ASSIST_CALL,
                  "message":T.STRB_ASSIST_CALL_NOT_AVAIL_ML,
                  "caption1":T.STRB_YES,
                  "caption2":T.STRB_NO,
                  "showClose":true
               });
               break;
            case DynamicPopupNames.TWOITEM_NAV_VICS_REROUTE:
               message = Peripheral.localeEngine.getText(T.STRB_NEW_ROUTE);
               message = message.replace("//","\n");
               Framework.popupManager.show(identifier,"popup2item",{
                  "timeout":10000,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_NAVIGATION,
                  "message":["\n",message],
                  "caption1":T.STRB_YES,
                  "caption2":T.STRB_NO,
                  "showClose":true
               });
               break;
            case DynamicPopupNames.TWOITEM_NAV_FAVORITE_DELETE:
               Framework.popupManager.show(identifier,"popup2item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_NAVIGATION,
                  "message":(variables != null && variables.hasOwnProperty("message") ? variables.message : T.STRB_ASK_DELETE_THIS_DESTINATION),
                  "caption1":T.STRB_YES,
                  "caption2":T.STRB_NO,
                  "showClose":true,
                  "size":520
               });
               break;
            case DynamicPopupNames.TWOITEM_DMB_ASK_DELETE_STATIONLIST:
               Framework.popupManager.show(identifier,"popup2item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_DMB_CHANNEL_LIST,
                  "message":T.STRB_DMB_ERASE_LIST,
                  "caption1":T.STRB_YES,
                  "caption2":T.STRB_NO,
                  "showClose":true
               });
               break;
            case DynamicPopupNames.TWOITEM_SW_UPDATE_USB_DETECTED:
               Framework.popupManager.show(identifier,"popup2item",{
                  "timeout":0,
                  "type":PopupType.SECONDARY,
                  "title":T.STRB_VALIDATING_SW_TITLE,
                  "message":T.STRB_VALIDATING_SW_MESSAGE,
                  "caption1":T.STRB_OK,
                  "caption2":T.STRB_CANCEL,
                  "showClose":false
               });
               break;
            case DynamicPopupNames.THREEITEM_NAV_ASK_DELETE_THIS_DESTINATION:
               Framework.popupManager.show(identifier,"popup3item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_NAVIGATION,
                  "message":(variables != null && variables.hasOwnProperty("message") ? variables.message : T.STRB_ASK_DELETE_THIS_DESTINATION),
                  "caption1":T.STRB_YES,
                  "caption2":T.STRB_ALL,
                  "caption3":T.STRB_NO,
                  "showClose":true
               });
               break;
            case DynamicPopupNames.THREEITEM_NAV_ASK_DELETE_THIS_TRAIL:
               Framework.popupManager.show(identifier,"popup3item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_NAVIGATION,
                  "message":T.STRB_ASK_DELETE_THIS_TRAIL,
                  "caption1":T.STRB_YES,
                  "caption2":T.STRB_ALL,
                  "caption3":T.STRB_NO,
                  "showClose":true
               });
               break;
            case DynamicPopupNames.THREEITEM_NAV_ASK_DELETE_THIS_TRIP:
               Framework.popupManager.show(identifier,"popup3item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_NAVIGATION,
                  "message":T.STRB_ASK_DELETE_THIS_TRIP,
                  "caption1":T.STRB_YES,
                  "caption2":T.STRB_ALL,
                  "caption3":T.STRB_NO,
                  "showClose":true
               });
               break;
            case DynamicPopupNames.THREEITEM_NAV_ASK_REMOVE_THIS_DESTINATION:
               Framework.popupManager.show(identifier,"popup3item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_NAVIGATION,
                  "message":T.STRB_ASK_REMOVE_THIS_DESTINATION,
                  "caption1":T.STRB_YES,
                  "caption2":T.STRB_ALL,
                  "caption3":T.STRB_NO,
                  "showClose":true
               });
               break;
            case DynamicPopupNames.THREEITEM_NAV_TMC_REROUTE:
               Framework.popupManager.show(identifier,"popup3item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_NAVIGATION,
                  "message":["\n",T.STRB_TRAFFIC_INCIDENT_ON_ROUTE,"\n",T.STRB_ASK_USE_ALTERNATIVE_ROUTE],
                  "caption1":T.STRB_YES,
                  "caption2":T.STRB_PREVIEW,
                  "caption3":T.STRB_NO,
                  "showClose":true
               });
               break;
            case DynamicPopupNames.THREEITEM_NAV_ASK_DELETE_THIS_FAVORITE:
               Framework.popupManager.show(identifier,"popup3item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_NAVIGATION,
                  "message":T.STRB_DELETE_FAVORITE,
                  "caption1":T.STRB_YES,
                  "caption2":T.STRB_ALL,
                  "caption3":T.STRB_NO,
                  "showClose":true
               });
               break;
            case DynamicPopupNames.OPTIONS_ADD_TO_FAVORITES:
               Framework.popupManager.show(identifier,"popupoptions",{
                  "timeout":0,
                  "type":PopupType.OPTIONS,
                  "title":(Framework.resolution == Framework.RES_800_480 ? T.STRB_OPTIONS_330 : T.STRB_OPTIONS),
                  "ids":[0,0,0,0,0],
                  "labels":[T.STRB_REMOVE_FROM_FAVS],
                  "highlight":[false,false,false,false,false],
                  "enabled":[true,true,true,true,true]
               });
               break;
            case DynamicPopupNames.OPTIONS_ADD_TO_FAVORITES:
               Framework.popupManager.show(identifier,"popupoptions",{
                  "timeout":0,
                  "type":PopupType.OPTIONS,
                  "title":(Framework.resolution == Framework.RES_800_480 ? T.STRB_OPTIONS_330 : T.STRB_OPTIONS),
                  "ids":[1,0,0,0,0],
                  "labels":[T.STRB_ADD_TO_FAVORITES],
                  "highlight":[false,false,false,false,false],
                  "enabled":[true,true,true,true,true]
               });
               break;
            case DynamicPopupNames.OPTIONS_WIFI_NETWORK:
               Framework.popupManager.show(identifier,"popupoptions",{
                  "timeout":0,
                  "type":PopupType.OPTIONS,
                  "title":(Framework.resolution == Framework.RES_800_480 ? T.STRB_OPTIONS_330 : T.STRB_OPTIONS),
                  "labels":[T.STRB_MAKE_FAVORITE,T.STRB_VIEW_EDIT_PASSPHRASE,T.STRB_DELETE_NETWORK],
                  "highlight":[false,false,false,false,false],
                  "enabled":[true,true,true,true,true]
               });
               break;
            case DynamicPopupNames.OPTIONS_BLUETOOTH_PAIRED_DATA_DEVICE_ENABLED_FAV_GREYED:
               Framework.popupManager.show(identifier,"popupoptions",{
                  "timeout":0,
                  "type":PopupType.OPTIONS,
                  "title":(Framework.resolution == Framework.RES_800_480 ? T.STRB_OPTIONS_330 : T.STRB_OPTIONS),
                  "labels":[T.STRB_MAKE_FAVORITE,T.STRB_DELETE_DEVICE,T.STRB_DISABLE_DATA_CONNECTION,T.STRB_SETUP_DATA_CONNECTION],
                  "highlight":[false,false,false,false,false],
                  "enabled":[false,true,true,true,true]
               });
               break;
            case DynamicPopupNames.OPTIONS_BLUETOOTH_PAIRED_DATA_DEVICE_ENABLED_FAV_ENABLED:
               Framework.popupManager.show(identifier,"popupoptions",{
                  "timeout":0,
                  "type":PopupType.OPTIONS,
                  "title":(Framework.resolution == Framework.RES_800_480 ? T.STRB_OPTIONS_330 : T.STRB_OPTIONS),
                  "labels":[T.STRB_MAKE_FAVORITE,T.STRB_DELETE_DEVICE,T.STRB_DISABLE_DATA_CONNECTION,T.STRB_SETUP_DATA_CONNECTION],
                  "highlight":[false,false,false,false,false],
                  "enabled":[true,true,true,true,true]
               });
               break;
            case DynamicPopupNames.OPTIONS_BLUETOOTH_PAIRED_DATA_DEVICE_DISABLED_FAV_ENABLED:
               Framework.popupManager.show(identifier,"popupoptions",{
                  "timeout":0,
                  "type":PopupType.OPTIONS,
                  "title":(Framework.resolution == Framework.RES_800_480 ? T.STRB_OPTIONS_330 : T.STRB_OPTIONS),
                  "labels":[T.STRB_MAKE_FAVORITE,T.STRB_DELETE_DEVICE,T.STRB_ENABLE_DATA_CONNECTION,T.STRB_SETUP_DATA_CONNECTION],
                  "highlight":[false,false,false,false,false],
                  "enabled":[true,true,true,true,true]
               });
               break;
            case DynamicPopupNames.OPTIONS_BLUETOOTH_PAIRED_DATA_DEVICE_DISABLED_FAV_GREYED:
               Framework.popupManager.show(identifier,"popupoptions",{
                  "timeout":0,
                  "type":PopupType.OPTIONS,
                  "title":(Framework.resolution == Framework.RES_800_480 ? T.STRB_OPTIONS_330 : T.STRB_OPTIONS),
                  "labels":[T.STRB_MAKE_FAVORITE,T.STRB_DELETE_DEVICE,T.STRB_ENABLE_DATA_CONNECTION,T.STRB_SETUP_DATA_CONNECTION],
                  "highlight":[false,false,false,false,false],
                  "enabled":[false,true,true,true,true]
               });
               break;
            case DynamicPopupNames.OPTIONS_TMC_ROUTE_MODE:
               Framework.popupManager.show(identifier,"popupoptions",{
                  "timeout":0,
                  "type":PopupType.OPTIONS,
                  "title":(Framework.resolution == Framework.RES_800_480 ? T.STRB_OPTIONS_330 : T.STRB_OPTIONS),
                  "labels":[T.STRB_OPT_AUTOMATIC,T.STRB_OPT_BY_DELAY_TIME,T.STRB_OPT_MANUAL,T.STRB_OPT_OFF],
                  "highlight":variables.highlight,
                  "enabled":[true,true,true,true,true]
               });
               break;
            case DynamicPopupNames.OPTIONS_ROUTE:
               Framework.popupManager.show(identifier,"popupoptions",{
                  "timeout":0,
                  "type":PopupType.OPTIONS,
                  "title":(Framework.resolution == Framework.RES_800_480 ? T.STRB_OPTIONS_330 : T.STRB_OPTIONS),
                  "labels":variables.labels,
                  "highlight":variables.highlight,
                  "enabled":variables.enabled
               });
               break;
            case DynamicPopupNames.INFO_APPS_STARTING:
               Framework.popupManager.show(identifier,"popupsearching",{
                  "timeout":40000,
                  "minimum":1000,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_MENU_APPS,
                  "message":T.STRB_DISCLAIMER_LOADING,
                  "caption1":"",
                  "caption2":"",
                  "showClose":false,
                  "showOk":false,
                  "showCancel":false,
                  "showSearching":true
               });
               break;
            case DynamicPopupNames.INFO_VIA_MOBILE_UPDATING:
               Framework.popupManager.show(identifier,"popupsearching",{
                  "timeout":40000,
                  "minimum":1000,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_MENU_APPS,
                  "message":[T.STRB_UPDATING_APPS_PLEASE_WAIT_ARG,variables.name],
                  "caption1":"",
                  "caption2":"",
                  "showClose":false,
                  "showOk":false,
                  "showCancel":false,
                  "showSearching":true
               });
               break;
            case DynamicPopupNames.INFO_VIA_MOBILE_LOADING:
               Framework.popupManager.show(identifier,"popupsearching",{
                  "timeout":40000,
                  "minimum":1000,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_MENU_APPS,
                  "message":[T.STRB_LOADING_APPS_PLEASE_WAIT_ARG,variables.name],
                  "caption1":"",
                  "caption2":"",
                  "showClose":false,
                  "showOk":false,
                  "showCancel":false,
                  "showSearching":true
               });
               break;
            case DynamicPopupNames.INFO_APPS_LOADING:
               Framework.popupManager.show(identifier,"popupsearching",{
                  "timeout":0,
                  "minimum":1000,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_MENU_APPS,
                  "message":[T.STRB_APPLICATION_INITIALIZING,"\n\n" + variables.name],
                  "caption1":"",
                  "caption2":"",
                  "showClose":false,
                  "showOk":false,
                  "showCancel":false,
                  "showSearching":true
               });
               break;
            case DynamicPopupNames.INFO_APPS_STOPPING:
               Framework.popupManager.show(identifier,"popupsearching",{
                  "timeout":0,
                  "minimum":1000,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_MENU_APPS,
                  "message":[T.STRB_APPLICATION," ",T.STRB_STOPPING,"\n\n" + variables.name],
                  "caption1":"",
                  "caption2":"",
                  "showClose":false,
                  "showOk":false,
                  "showCancel":false,
                  "showSearching":true
               });
               break;
            case DynamicPopupNames.INFO_APPS_STOP_START:
               Framework.popupManager.show(identifier,"popupsearching",{
                  "timeout":0,
                  "minimum":1000,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_MENU_APPS,
                  "message":[T.STRB_APPS_STARTING_AND_STOPPING,variables.srcName + "\n\n",variables.destName],
                  "caption1":"",
                  "caption2":"",
                  "showClose":false,
                  "showOk":false,
                  "showCancel":false,
                  "showSearching":true
               });
               break;
            case DynamicPopupNames.INFO_WIFI_TRY_TO_CONNECT:
               Framework.popupManager.show(identifier,"popupsearching",{
                  "timeout":0,
                  "minimum":2000,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_WIFI_NETWORK,
                  "message":[T.STRB_WIFI_CONNECTION_IN_PROGRESS,"\n",T.STRB_PLEASE_WAIT],
                  "caption1":"",
                  "caption2":T.STRB_CANCEL,
                  "showClose":false,
                  "showOk":false,
                  "showCancel":true,
                  "showSearching":true
               });
               break;
            case DynamicPopupNames.INFO_WIFI_SEARCH_NETWORKS:
               Framework.popupManager.show(identifier,"popupsearching",{
                  "timeout":0,
                  "minimum":2000,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_WIFI_NETWORK,
                  "message":[T.STRB_SEARCHING_FOR_WIFI_NETWORKS,"\n",T.STRB_PLEASE_WAIT,"..."],
                  "caption1":T.STRB_OK,
                  "caption2":"",
                  "showClose":false,
                  "showOk":true,
                  "showCancel":false,
                  "showSearching":true
               });
               break;
            case DynamicPopupNames.INFO_WIFI_EMBEDDED_PHONE_UNABLE_TO_CONNECT:
               Framework.popupManager.show(identifier,"popupsearching",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_BUILT_IN_CONNECTION,
                  "message":[T.STRB_UNABLE_TO_CONNECT_TO_THE,T.STRB_BUILT_IN_CONNECTION,"."],
                  "caption1":T.STRB_OK,
                  "caption2":"",
                  "showClose":true,
                  "showOk":true,
                  "showCancel":false,
                  "showSearching":false
               });
               break;
            case DynamicPopupNames.INFO_WIFI_EMBEDDED_PHONE_REQUIRED_CONNECTION_IN_PROGRESS:
               Framework.popupManager.show(identifier,"popupsearching",{
                  "timeout":0,
                  "minimum":2000,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_BUILT_IN_CONNECTION,
                  "message":[T.STRB_WIFI_HOTSPOT_REQUIRES,"\n",T.STRB_CONNECTING_TO_BUILT_IN_CONNECTION,"..."],
                  "caption1":"",
                  "caption2":"",
                  "showClose":false,
                  "showOk":false,
                  "showCancel":false,
                  "showSearching":true
               });
               break;
            case DynamicPopupNames.INFO_WIFI_HOTSPOT_DISABLED_DUE_TO_CHANGE_IN_CONFIGURATION:
               Framework.popupManager.show(identifier,"popupsearching",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_WIFI_HOTSPOT,
                  "message":[T.STRB_HOTSPOT_CHANGE_IN_CONFIGURATION,T.STRB_HOTSPOT_ENABLE_MANUALLY],
                  "caption1":T.STRB_OK,
                  "caption2":"",
                  "showClose":true,
                  "showOk":true,
                  "showCancel":false,
                  "showSearching":false
               });
               break;
            case DynamicPopupNames.INFO_WIFI_HOTSPOT_WEP_PASSWORD_LENGTH:
               Framework.popupManager.show(identifier,"popupsearching",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_WIFI_HOTSPOT,
                  "message":T.STRB_WIFI_ENTER_PASSPHRASE,
                  "caption1":T.STRB_OK,
                  "caption2":"",
                  "showClose":true,
                  "showOk":true,
                  "showCancel":false,
                  "showSearching":false
               });
               break;
            case DynamicPopupNames.INFO_WIFI_SERVICE_NOT_AVAILABLE_YET:
               Framework.popupManager.show(identifier,"popupsearching",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_WIFI_NOT_AVAILABLE,
                  "message":T.STRB_WIFI_BEING_STARTED,
                  "caption1":T.STRB_OK,
                  "caption2":"",
                  "showClose":true,
                  "showOk":true,
                  "showCancel":false,
                  "showSearching":false
               });
               break;
            case DynamicPopupNames.INFO_NAV_RECALCULATING:
               Framework.popupManager.show(identifier,"popupsearching",{
                  "timeout":0,
                  "minimum":1500,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_NAVIGATION,
                  "message":T.STRB_RECALCULATING_ROUTE,
                  "caption1":"",
                  "caption2":"",
                  "showClose":false,
                  "showOk":false,
                  "showCancel":false,
                  "showSearching":true
               });
               break;
            case DynamicPopupNames.INFO_NAV_SEARCHING_FOR:
               Framework.popupManager.show(identifier,"popupsearching",{
                  "timeout":0,
                  "minimum":1000,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_NAVIGATION,
                  "message":[T.STRB_SEARCHING_FOR," \'" + Peripheral.navigation.navPoiInput.poiPreset + "\' "],
                  "caption1":"",
                  "caption2":"",
                  "showClose":false,
                  "showOk":false,
                  "showCancel":false,
                  "showSearching":true
               });
               break;
            case DynamicPopupNames.INFO_NAV_SEARCHING_POI:
               Framework.popupManager.show(identifier,"popupsearching",{
                  "timeout":0,
                  "minimum":1000,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_NAVIGATION,
                  "message":variables.message,
                  "caption1":"",
                  "caption2":"",
                  "showClose":true,
                  "showOk":false,
                  "showCancel":false,
                  "showSearching":true
               });
               break;
            case DynamicPopupNames.INFO_NAV_COPYING_DATABASE_INFO:
               Framework.popupManager.show(identifier,"popupsearching",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_NAVIGATION_DATABASE_UPDATE,
                  "message":T.STRB_COPYING_NAVIGATION_DATABASE_INFORMATION,
                  "caption1":"",
                  "caption2":T.STRB_CANCEL,
                  "showClose":true,
                  "showOk":false,
                  "showCancel":true,
                  "showSearching":true
               });
               break;
            case DynamicPopupNames.INFO_NAV_COPYING_DATABASE_FAILED:
               Framework.popupManager.show(identifier,"popupsearching",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_NAVIGATION_DATABASE_UPDATE,
                  "message":T.STRB_COPYING_NAVIGATION_DATABASE_INFORMATION_FAILED,
                  "caption1":T.STRB_OK,
                  "caption2":"",
                  "showClose":false,
                  "showOk":true,
                  "showCancel":false,
                  "showSearching":false
               });
               break;
            case DynamicPopupNames.INFO_NAV_COPYING_DATABASE_SUCCESS:
               Framework.popupManager.show(identifier,"popupsearching",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_NAVIGATION_DATABASE_UPDATE,
                  "message":T.STRB_COPYING_NAVIGATION_DATABASE_INFORMATION_SUCCESSFUL,
                  "caption1":T.STRB_OK,
                  "caption2":"",
                  "showClose":false,
                  "showOk":true,
                  "showCancel":false,
                  "showSearching":false
               });
               break;
            case DynamicPopupNames.INFO_BLUETOOTH_CONNECTION_TEST_IN_PROGRESS:
               Framework.popupManager.show(identifier,"popupsearching",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_BLUETOOTH_CONNECTION,
                  "message":[T.STRB_BLUETOOTH_TEST_IN_PROGRESS,"\n",T.STRB_PLEASE_WAIT,"..."],
                  "caption1":"",
                  "caption2":T.STRB_CANCEL,
                  "showClose":true,
                  "showOk":false,
                  "showCancel":true,
                  "showSearching":true
               });
               break;
            case DynamicPopupNames.INFO_BLUETOOTH_CONNECTION_TEST_FAILED:
               Framework.popupManager.show(identifier,"popupsearching",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_BLUETOOTH_CONNECTION,
                  "message":[T.STRB_BLUETOOTH_TEST_NOT_SUCCESSFUL,"\n" + variables.name],
                  "caption1":T.STRB_OK,
                  "caption2":"",
                  "showClose":true,
                  "showOk":true,
                  "showCancel":false,
                  "showSearching":false
               });
               break;
            case DynamicPopupNames.INFO_BLUETOOTH_CONNECTION_TEST_SUCCESS:
               Framework.popupManager.show(identifier,"popupsearching",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_BLUETOOTH_CONNECTION,
                  "message":[T.STRB_BLUETOOTH_TEST_SUCCESSFULL,"\n" + variables.name],
                  "caption1":T.STRB_OK,
                  "caption2":"",
                  "showClose":true,
                  "showOk":true,
                  "showCancel":false,
                  "showSearching":false
               });
               break;
            case DynamicPopupNames.INFO_VR_NOT_AVAILABLE_DURING_ECALL:
               Framework.popupManager.show(identifier,"errorpopupscreen",{
                  "timeout":Style.DEFAULT_POPUP_TIMEOUT,
                  "type":PopupType.SECONDARY,
                  "title":T.STRB_VR_NOT_AVAILABLE,
                  "body":["\n\n",T.STRB_ERROR_VR_NOT_DURING_911]
               });
               break;
            case DynamicPopupNames.INFO_VR_NOT_AVAILABLE_DURING_ASSIST_CALL:
               Framework.popupManager.show(identifier,"errorpopupscreen",{
                  "timeout":Style.DEFAULT_POPUP_TIMEOUT,
                  "type":PopupType.SECONDARY,
                  "title":T.STRB_VR_NOT_AVAILABLE,
                  "body":["\n\n",T.STRB_ACALL_VR_NOT_AVAIL_DURING_CALL]
               });
               break;
            case DynamicPopupNames.INFO_PHONE_NOT_AVAILABLE_DURING_ASSIST_CALL:
               Framework.popupManager.show(identifier,"popupsearching",{
                  "timeout":Style.EMBEDDED_PHONE_POPUP_RTN_TIMEOUT,
                  "type":PopupType.SECONDARY,
                  "title":T.STRB_PHONE_NOT_AVAILABLE,
                  "message":T.STRB_ACALL_PHONE_NOT_AVAIL_DURING_CALL,
                  "caption1":"",
                  "caption2":"",
                  "showClose":false,
                  "showOk":false,
                  "showCancel":false,
                  "showSearching":false
               });
               break;
            case DynamicPopupNames.INFO_XLET_ACTION_CANCELED:
               Framework.popupManager.show(identifier,"popupsearching",{
                  "timeout":Style.DEFAULT_POPUP_TIMEOUT,
                  "type":PopupType.SECONDARY,
                  "title":T.STRB_APP_OPERATION_CANCELED,
                  "message":variables.message,
                  "caption1":"",
                  "caption2":"",
                  "showClose":false,
                  "showOk":false,
                  "showCancel":false,
                  "showSearching":false
               });
               break;
            case DynamicPopupNames.SOFTWARE_UPDATE_NAV_DATABASE_CODE_FAIL:
               Framework.popupManager.show(identifier,"popupsearching",{
                  "timeout":Style.DEFAULT_POPUP_TIMEOUT,
                  "type":PopupType.SECONDARY,
                  "title":T.STRB_NAVIGATION_DATABASE_UPDATE,
                  "message":T.STRB_INCORRECT_ACTIVATION_CODE,
                  "caption1":"",
                  "caption2":"",
                  "showClose":false,
                  "showOk":false,
                  "showCancel":false,
                  "showSearching":false
               });
               break;
            case DynamicPopupNames.INFO_DMB_SEARCHING_CHANNELS:
               Framework.popupManager.show(identifier,"popupsearching",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_DMB_CHANNEL_LIST,
                  "message":T.STRB_DMB_CHANNEL_SCANNING,
                  "caption1":"",
                  "caption2":"",
                  "showClose":true,
                  "showOk":false,
                  "showCancel":false,
                  "showSearching":true
               });
               break;
            case DynamicPopupNames.INFO_DMB_CHANGING_CHANNELS:
               Framework.popupManager.show(identifier,"popupsearching",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_DMB_CHANNEL_LIST,
                  "message":T.STRB_DMB_CHANNEL_CHANGING,
                  "caption1":"",
                  "caption2":"",
                  "showClose":true,
                  "showOk":false,
                  "showCancel":false,
                  "showSearching":true
               });
               break;
            case DynamicPopupNames.REFRESH_STATIONLIST:
               Framework.popupManager.show(identifier,"popupsearching",{
                  "timeout":120000,
                  "type":PopupType.SECONDARY,
                  "title":T.STRB_STATION_LIST,
                  "message":T.STRB_SEARCHING_FOR_STATIONS,
                  "caption1":"",
                  "caption2":T.STRB_CANCEL,
                  "showClose":false,
                  "showOk":false,
                  "showCancel":true,
                  "showSearching":true
               });
               break;
            case DynamicPopupNames.DRIVER_SETTINGS_STORE:
               Framework.popupManager.show(identifier,"errorpopupscreen",{
                  "timeout":Style.DEFAULT_POPUP_TIMEOUT,
                  "type":PopupType.SECONDARY,
                  "title":T.STRB_DRIVER_SETTINGS,
                  "body":["\n\n",T.STRB_SAVING_DRIVER_SETTINGS,variables.driver]
               });
               break;
            case DynamicPopupNames.DRIVER_SETTINGS_RECALL:
               Framework.popupManager.show(identifier,"errorpopupscreen",{
                  "timeout":Style.DEFAULT_POPUP_TIMEOUT,
                  "type":PopupType.SECONDARY,
                  "title":T.STRB_DRIVER_SETTINGS,
                  "body":["\n\n",T.STRB_RESTORING_DRIVER_SETTINGS,variables.driver]
               });
               break;
            case DynamicPopupNames.SPELLER_WIFI_NETWORK_PASSPHRASE:
            case DynamicPopupNames.SPELLER_WIFI_NETWORK_NAME:
            case DynamicPopupNames.SPELLER_WIFI_HOTSPOT_PASSPHRASE:
            case DynamicPopupNames.SPELLER_WIFI_HOTSPOT_NAME:
               Framework.popupManager.show(identifier,"appsspellerpopup",{
                  "timeout":0,
                  "type":PopupType.SPELLER,
                  "screen":variables.screen
               });
               break;
            case DynamicPopupNames.TA_ANNOUNCEMENT:
               Framework.popupManager.show(identifier,"popup2item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":variables.title,
                  "message":variables.message,
                  "caption1":T.STRB_CANCEL,
                  "caption2":T.STRB_POPUP_BTN_DISABLE,
                  "showCancel":true
               });
               break;
            case DynamicPopupNames.PTY31_ANNOUNCEMENT:
               Framework.popupManager.show(identifier,"popup1item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_TA_ALARM,
                  "message":["\n",T.STRB_TA_PLAYING_EMERGENCY_ANNOUNCE],
                  "caption1":T.STRB_CANCEL,
                  "showCancel":true
               });
               break;
            case DynamicPopupNames.TWOITEM_PHONE_ASK_CLEAR_ALL_SETTINGS:
               Framework.popupManager.show(identifier,"popup2item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":"",
                  "message":"Clear all Settings ?",
                  "caption1":T.STRB_YES,
                  "caption2":T.STRB_NO,
                  "showClose":true
               });
               break;
            case DynamicPopupNames.INFO_PHONE_WAITING_ON_RESPONSE:
               Framework.popupManager.show(identifier,"popupsearching",{
                  "timeout":variables.timeout,
                  "type":PopupType.PRIMARY,
                  "title":variables.title,
                  "message":variables.message,
                  "caption1":"",
                  "caption2":"",
                  "showClose":false,
                  "showOk":false,
                  "showCancel":false,
                  "showSearching":true
               });
               break;
            case DynamicPopupNames.RTN_STARTED:
               Framework.popupManager.show(identifier,"popupsearching",{
                  "timeout":variables.timeout,
                  "type":PopupType.PRIMARY,
                  "title":variables.title,
                  "message":variables.message,
                  "caption1":"",
                  "caption2":"",
                  "showClose":false,
                  "showOk":false,
                  "showCancel":false,
                  "showSearching":true
               });
               break;
            case DynamicPopupNames.RTN_WAITING_ACTIVATION:
               Framework.popupManager.show(identifier,"popupsearching",{
                  "timeout":variables.timeout,
                  "type":PopupType.PRIMARY,
                  "title":variables.title,
                  "message":variables.message,
                  "caption1":"",
                  "caption2":"",
                  "showClose":false,
                  "showOk":false,
                  "showCancel":false,
                  "showSearching":true
               });
               break;
            case DynamicPopupNames.RTN_ACTIVATION_STARTED:
               Framework.popupManager.show(identifier,"popupsearching",{
                  "timeout":variables.timeout,
                  "type":PopupType.PRIMARY,
                  "title":variables.title,
                  "message":variables.message,
                  "caption1":"",
                  "caption2":"",
                  "showClose":false,
                  "showOk":false,
                  "showCancel":false,
                  "showSearching":true
               });
               break;
            case DynamicPopupNames.RTN_ACTIVATION_SUCCESS:
               Framework.popupManager.show(identifier,"popupsearching",{
                  "timeout":variables.timeout,
                  "type":PopupType.PRIMARY,
                  "title":variables.title,
                  "message":variables.message,
                  "caption1":"",
                  "caption2":"",
                  "showClose":true,
                  "showOk":false,
                  "showCancel":false,
                  "showSearching":false
               });
               break;
            case DynamicPopupNames.RTN_ACTIVATION_FAILED:
               Framework.popupManager.show(identifier,"popupsearching",{
                  "timeout":variables.timeout,
                  "type":PopupType.PRIMARY,
                  "title":variables.title,
                  "message":variables.message,
                  "caption1":"",
                  "caption2":"",
                  "showClose":true,
                  "showOk":false,
                  "showCancel":false,
                  "showSearching":false
               });
               break;
            case DynamicPopupNames.INFO_PHONE_MENU:
               Framework.popupManager.show(identifier,"popupsearching",{
                  "timeout":variables.timeout,
                  "type":PopupType.SECONDARY,
                  "title":variables.title,
                  "message":variables.message,
                  "caption1":"",
                  "caption2":"",
                  "showClose":true,
                  "showOk":false,
                  "showCancel":false,
                  "showSearching":false
               });
               break;
            case DynamicPopupNames.OPTIONS_PHONE_EDIT_VIEW:
               Framework.popupManager.show(identifier,"popupoptions",{
                  "timeout":0,
                  "type":PopupType.OPTIONS,
                  "title":(Framework.resolution == Framework.RES_800_480 ? T.STRB_OPTIONS_330 : T.STRB_OPTIONS),
                  "ids":[0,1,0,0,0],
                  "labels":["Edit","View"],
                  "highlight":[false,false,false,false,false],
                  "enabled":[true,true,false,false,false],
                  "checked":[true,true,false,false,false]
               });
               break;
            case DynamicPopupNames.SPELLER_PHONE_SCREEN:
               Framework.popupManager.show(identifier,"appsspellerpopup",{
                  "timeout":0,
                  "type":PopupType.SPELLER,
                  "screen":variables.screen,
                  "numeric":variables.numeric,
                  "availableCharacters":variables.availableCharacters
               });
               break;
            case DynamicPopupNames.PHONEBOOK_SMART_SPELLER:
               if(Global.region == TunerRegion.CHINA)
               {
                  Framework.popupManager.show(identifier,"spellerscreenchina",{
                     "timeout":0,
                     "type":PopupType.SPELLER,
                     "ext":variables.screen
                  });
                  break;
               }
               if(Global.region == TunerRegion.KOREA)
               {
                  Framework.popupManager.show(identifier,"spellerscreeenKR",{
                     "timeout":0,
                     "type":PopupType.SPELLER,
                     "ext":variables.screen
                  });
                  break;
               }
               if(Global.region == TunerRegion.JAPAN)
               {
                  Framework.popupManager.show(identifier,"spellerscreenJP",{
                     "timeout":0,
                     "type":PopupType.SPELLER,
                     "ext":variables.screen
                  });
                  break;
               }
               Framework.popupManager.show(identifier,"appsspellerpopup",{
                  "timeout":0,
                  "type":PopupType.SPELLER,
                  "screen":variables.screen
               });
               break;
            case DynamicPopupNames.MEDIA_SEARCH_SPELLER:
               if(Global.region == TunerRegion.CHINA)
               {
                  Framework.popupManager.show(identifier,"spellerscreenchina",{
                     "timeout":0,
                     "type":PopupType.SPELLER,
                     "ext":variables.screen
                  });
                  break;
               }
               if(Global.region == TunerRegion.KOREA)
               {
                  Framework.popupManager.show(identifier,"spellerscreeenKR",{
                     "timeout":0,
                     "type":PopupType.SPELLER,
                     "ext":variables.screen
                  });
                  break;
               }
               if(Global.region == TunerRegion.JAPAN)
               {
                  Framework.popupManager.show(identifier,"spellerscreenJP",{
                     "timeout":0,
                     "type":PopupType.SPELLER,
                     "ext":variables.screen
                  });
                  break;
               }
               Framework.popupManager.show(identifier,"appsspellerpopup",{
                  "timeout":0,
                  "type":PopupType.SPELLER,
                  "screen":variables.screen
               });
               break;
            case DynamicPopupNames.CONNMGR_IP_CONFLICT:
               Framework.popupManager.show(identifier,"popupsearching",{
                  "timeout":false,
                  "type":PopupType.SECONDARY,
                  "title":"",
                  "message":[T.STRB_IP_ADDRESS_CONFLICT,variables.iface],
                  "caption1":T.STRB_OK,
                  "caption2":"",
                  "showClose":false,
                  "showOk":true,
                  "showCancel":false,
                  "showSearching":false
               });
               break;
            case DynamicPopupNames.DRIVEMODE_FUNCTION_POPUP:
               Framework.popupManager.show(identifier,"drivemodefunctionpopup",{
                  "type":(variables.hasOwnProperty("type") ? variables.type : PopupType.SECONDARY),
                  "message":variables.message,
                  "backgroudType":variables.backgroudType
               });
               break;
            case DynamicPopupNames.DRIVEMODE_ONE_ITEM_POPUP:
               Framework.popupManager.show(identifier,"errorpopupscreen",{
                  "id":identifier,
                  "title":(variables.hasOwnProperty("title") ? variables.title : ""),
                  "body":variables.body,
                  "buttonHandler":this.onDriveModeOneItemClicks,
                  "closeButton":variables.closeButton,
                  "timeout":5000
               });
               break;
            case DynamicPopupNames.DRIVEMODE_SHIFT_ON:
               Framework.popupManager.show(identifier,"drivemodefunctionpopup",{
                  "message":variables.message,
                  "backgroudType":variables.backgroudType,
                  "closeButton":variables.closeButton,
                  "timeout":variables.timeout
               });
               break;
            case DynamicPopupNames.DRIVEMODE_POPUP_DISABLED_BTN_SELECTED:
               Framework.popupManager.show(identifier,"popup1item",{
                  "timeout":5000,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_DM_ERROR_LEVEL_UNAVAILABLE_TITLE,
                  "message":variables.message,
                  "caption1":T.STRB_OK
               });
               break;
            case DynamicPopupNames.ONEITEM_NAV_ROUTE_CALCULATION_FAILED:
               Framework.popupManager.show(identifier,"popup1item",{
                  "timeout":5000,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_NAVIGATION,
                  "message":[T.STRB_SU_ERROR,"\n","\n",T.STRB_NAVI_GUIDANCE_CANCEL_CONFIRM],
                  "caption1":T.STRB_OK,
                  "showOk":true,
                  "showClose":true
               });
               break;
            case DynamicPopupNames.DRIVEMODE_PP_NOT_READY:
               Framework.popupManager.show(identifier,"popup1item",{
                  "timeout":5000,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_PERFORMANCE_PAGES,
                  "message":[T.STRB_PERFORMANCE_PAGES_LOADING_ML],
                  "caption1":T.STRB_OK,
                  "showClose":true
               });
               break;
            case DynamicPopupNames.PERSONALIZATION_LOCKOUT:
               Framework.popupManager.show(identifier,"popup1item",{
                  "timeout":3000,
                  "title":"",
                  "message":T.STRB_VEHICLE_MUST_BE_IN_RUN,
                  "caption1":T.STRB_OK,
                  "showOk":true,
                  "showClose":true
               });
               break;
            case DynamicPopupNames.PROJECTION_DISPLAY_LOADING:
               Framework.popupManager.show(identifier,"errorpopupscreen",{
                  "type":PopupType.PRIMARY,
                  "body":["\n\n",T.STRB_PROJECTION_DEVICE_LOADING],
                  "closeButton":false
               });
               break;
            case DynamicPopupNames.PROJECTION_DEVICE_CONNECT_ERROR:
               Framework.popupManager.show(identifier,"errorpopupscreen",{
                  "id":identifier,
                  "type":PopupType.PRIMARY,
                  "body":["\n",T.STRB_PROJECTION_DEVICE_ERROR],
                  "buttonHandler":this.onProjectionDeviceConnectErrorClick,
                  "closeButton":true
               });
               break;
            case DynamicPopupNames.NAV_SEARCH_POPUP:
               Framework.popupManager.show(identifier,"NavSearchingPopup",{
                  "timeout":10000,
                  "type":PopupType.PRIMARY,
                  "message":T.STRB_RESULTS_GATHER,
                  "showSearching":true
               });
               break;
            case DynamicPopupNames.AVOIDANCE_POPUP:
               Framework.popupManager.show(identifier,"popup1item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_BORDER,
                  "message":T.STRB_ROUTE_MSG,
                  "caption1":T.STRB_OK,
                  "showClose":true
               });
               break;
            default:
               Framework.Trace("ERROR: Popup is not defined!");
         }
      }
      
      private function onFunctionNotSupported(evt:MouseEvent) : void
      {
         switch(evt.currentTarget.name)
         {
            case "ok_button":
               Framework.popupManager.dequeue(DynamicPopupNames.ERROR_ALERT);
         }
      }
      
      private function onProjectionDeviceConnectErrorClick(evt:MouseEvent) : void
      {
         Framework.popupManager.dequeue(DynamicPopupNames.PROJECTION_DEVICE_CONNECT_ERROR);
      }
   }
}

