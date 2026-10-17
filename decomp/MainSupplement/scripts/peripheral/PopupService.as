package peripheral
{
   import ancillary.Ancillary;
   import ancillary.DynamicPopupNames;
   import ancillary.Screens;
   import com.harman.moduleLink.AppManager;
   import com.harman.moduleLinkAPI.AdvisoryMessageTypes;
   import com.harman.moduleLinkAPI.DriverABEvent;
   import com.harman.moduleLinkAPI.HMIRequestEvent;
   import com.harman.moduleLinkAPI.IPAddressInfoEvent;
   import com.harman.navigation.DomainControl.NavDomainControllerEvent;
   import com.harman.navigation.NavigationEvent;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLinkAPI.PersonalConfigEvent;
   import core.enums.PopupType;
   import core.events.PopupManagerEvent;
   import events.GlobalEvent;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import locale.T;
   
   public class PopupService extends EventDispatcher
   {
      
      private var mUniqueId:int = 10000;
      
      private var mRequests:Dictionary = new Dictionary();
      
      private var mShowRunningCategory:Boolean = false;
      
      private var mGlobalPopupByMsgId:Boolean = false;
      
      public function PopupService()
      {
         super();
      }
      
      public function init() : void
      {
         Peripheral.navigation.navDomainControl.addEventListener(NavDomainControllerEvent.NAV_IS_OPERABLE,this.onNavOperable,false,0,true);
         Peripheral.hmiRequest.addEventListener(HMIRequestEvent.DISPLAY_BLOCK_POPUP,this.onBlockPopupRequest);
         Peripheral.hmiRequest.addEventListener(HMIRequestEvent.DISPLAY_BLOCK_POPUP_BY_MSGID,this.onBlockPopupRequest);
         Peripheral.hmiRequest.addEventListener(HMIRequestEvent.DISPLAY_GLOBAL_POPUP,this.onPopupRequest);
         Peripheral.hmiRequest.addEventListener(HMIRequestEvent.DISPLAY_GLOBAL_POPUP_BY_MSGID,this.onPopupRequestByMsgId);
         Framework.popupManager.addEventListener(PopupManagerEvent.TIMEOUT,this.timeout);
         Framework.popupManager.addEventListener(GlobalEvent.INFO_POPUP_CLOSED,this.onInfoPopupClosed,false,0,true);
         Framework.popupManager.addEventListener(GlobalEvent.INFO_POPUP_CANCEL,this.onInfoPopupCancel,false,0,true);
         Framework.popupManager.addEventListener(GlobalEvent.INFO_POPUP_OK,this.onInfoPopupOk,false,0,true);
         Framework.popupManager.addEventListener(GlobalEvent.ONEITEM_POPUP_CONFIRMATION,this.onOneItemPopupCancel,false,0,true);
         Framework.popupManager.addEventListener(GlobalEvent.TWOITEM_POPUP_CLOSED,this.onTwoItemPopupClosed,false,0,true);
         Framework.popupManager.addEventListener(GlobalEvent.TWOITEM_POPUP_LEFT_CLICK,this.onTwoItemLeftClick,false,0,true);
         Framework.popupManager.addEventListener(GlobalEvent.TWOITEM_POPUP_RIGHT_CLICK,this.onTwoItemRightClick,false,0,true);
         Framework.popupManager.addEventListener(GlobalEvent.THREEITEM_POPUP_CLOSED,this.onThreeItemPopupClosed,false,0,true);
         Framework.popupManager.addEventListener(GlobalEvent.THREEITEM_POPUP_LEFT_CLICK,this.onThreeItemLeftClick,false,0,true);
         Framework.popupManager.addEventListener(GlobalEvent.THREEITEM_POPUP_CENTER_CLICK,this.onThreeItemCenterClick,false,0,true);
         Framework.popupManager.addEventListener(GlobalEvent.THREEITEM_POPUP_RIGHT_CLICK,this.onThreeItemRightClick,false,0,true);
         Peripheral.ipaddressInfo.addEventListener(IPAddressInfoEvent.DISPLAY_HOT_WARNING,this.onDisplayHotWarning,false,0,true);
         Peripheral.driverAB.addEventListener(DriverABEvent.RECALL,this.onDriverABRecall,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.BRAKESERVICETEXTDISPLAY,this.onBrakeServiceText,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.BRAKESERVICESTATUS,this.onBrakeServiceStatus,false,0,true);
      }
      
      private function request(id:int, branch:String, vars:Object) : void
      {
         Framework.popupManager.show(id,branch,vars);
         Peripheral.hmiRequest.globalPopupReturnResult(this.mUniqueId,HMIRequestEvent.POPUP_DISPLAYED,this.mGlobalPopupByMsgId);
      }
      
      private function remove(id:int) : void
      {
         if(this.mRequests[id] != null)
         {
            this.mRequests[id] = null;
            delete this.mRequests[id];
            return;
         }
      }
      
      private function showRunningCategory() : void
      {
         if(this.mShowRunningCategory)
         {
            Peripheral.appManager.activeCategory = -3;
            Framework.structure.goto(Screens.MAIN_APPS);
            if(Framework.structure.currentBranch == Screens.MAIN_APPS)
            {
               Framework.popupManager.dispatchEvent(new GlobalEvent(GlobalEvent.CATEGORY,{"id":AppManager.RUNNING_APPS}));
            }
            this.mShowRunningCategory = false;
         }
      }
      
      private function onBlockPopupRequest(e:HMIRequestEvent) : void
      {
         Framework.popupManager.show(DynamicPopupNames.GLOBAL_FULLSCREEN,Screens.GLOBAL_FULLSCREEN,e.mData);
      }
      
      private function onPopupRequest(e:HMIRequestEvent) : void
      {
         var mPopup:Object = e.mData.displayGlobalPopup;
         this.processPopupRequest(mPopup,false);
      }
      
      private function onPopupRequestByMsgId(e:HMIRequestEvent) : void
      {
         var mPopupByMsgId:Object = e.mData.displayGlobalPopupByMsgId;
         this.processPopupRequest(mPopupByMsgId,true);
      }
      
      private function processPopupRequest(mPopup:Object, useMsgId:Boolean) : void
      {
         var mRequest:PopupRequest = null;
         this.mGlobalPopupByMsgId = useMsgId;
         mRequest = new PopupRequest();
         mRequest.uniqueId = ++this.mUniqueId;
         mRequest.timeout = mPopup["timeout"] < 0 ? 0 : int(mPopup["timeout"]);
         if(useMsgId)
         {
            mRequest.message = mPopup["msgId"] != null ? this.getSTRBMapping(mPopup["msgId"]) : "";
            if(mPopup["msgArgs"] != null && mPopup["msgArgs"] is Array)
            {
               mRequest.message = this.processArguments(mPopup["msgArgs"]);
            }
            mRequest.caption1 = mPopup["btn1CaptionId"] != null ? this.getSTRBMapping(mPopup["btn1CaptionId"]) : "";
            mRequest.caption2 = mPopup["btn2CaptionId"] != null ? this.getSTRBMapping(mPopup["btn2CaptionId"]) : "";
            mRequest.caption3 = mPopup["btn3CaptionId"] != null ? this.getSTRBMapping(mPopup["btn3CaptionId"]) : "";
            mRequest.caption1Id = mPopup["btn1CaptionId"] != null ? mPopup["btn1CaptionId"] : 0;
            mRequest.caption2Id = mPopup["btn2CaptionId"] != null ? mPopup["btn2CaptionId"] : 0;
            mRequest.caption3Id = mPopup["btn3CaptionId"] != null ? mPopup["btn3CaptionId"] : 0;
            mRequest.showOk = mRequest.caption1 != "";
            mRequest.showCancel = mRequest.caption2 != "";
         }
         else
         {
            mRequest.message = mPopup["msg"] != null ? mPopup["msg"] : "";
            mRequest.caption1 = mPopup["btn1Caption"] != null ? this.getSTRBMapping(mPopup["btn1Caption"]) : "";
            mRequest.caption2 = mPopup["btn2Caption"] != null ? this.getSTRBMapping(mPopup["btn2Caption"]) : "";
            mRequest.caption3 = mPopup["btn3Caption"] != null ? this.getSTRBMapping(mPopup["btn3Caption"]) : "";
            mRequest.showOk = mPopup["btn1Caption"] != "" && mPopup["btn1Caption"] != null;
            mRequest.showCancel = mPopup["btn2Caption"] != "" && mPopup["btn2Caption"] != null;
         }
         mRequest.showAlways = mPopup["showonDisplayoff"] != null;
         this.mShowRunningCategory = mPopup["showRunningCategory"] != null ? Boolean(mPopup["showRunningCategory"]) : false;
         mRequest.showClose = true;
         mRequest.showSearching = false;
         this.mRequests[this.mUniqueId] = mRequest;
         if(mRequest.caption1 != null && String(mRequest.caption1).length > 0 && mRequest.caption2 != null && String(mRequest.caption2).length > 0 && mRequest.caption3 != null && String(mRequest.caption3).length > 0)
         {
            this.request(mRequest.uniqueId,"popup3item",{
               "unique":mRequest.uniqueId,
               "type":mRequest.type,
               "timeout":mRequest.timeout,
               "title":mRequest.title,
               "message":mRequest.message,
               "caption1":mRequest.caption1,
               "caption2":mRequest.caption2,
               "caption3":mRequest.caption3,
               "showClose":mRequest.showClose
            });
         }
         else if(mRequest.caption1 != null && String(mRequest.caption1).length > 0 && mRequest.caption2 != null && String(mRequest.caption2).length > 0)
         {
            this.request(mRequest.uniqueId,"popup2item",{
               "unique":mRequest.uniqueId,
               "type":mRequest.type,
               "timeout":mRequest.timeout,
               "title":mRequest.title,
               "message":mRequest.message,
               "caption1":mRequest.caption1,
               "caption2":mRequest.caption2,
               "showClose":mRequest.showClose
            });
         }
         else
         {
            this.request(mRequest.uniqueId,"popupsearching",{
               "unique":mRequest.uniqueId,
               "type":mRequest.type,
               "timeout":mRequest.timeout,
               "title":mRequest.title,
               "message":mRequest.message,
               "caption1":mRequest.caption1,
               "caption2":mRequest.caption2,
               "showOk":mRequest.showOk,
               "showCancel":mRequest.showCancel,
               "showClose":mRequest.showClose,
               "showSearching":mRequest.showSearching
            });
         }
         Framework.Trace("<PopupService> onPopupRequest() \n<msg>\n" + mRequest.message + "\n</msg>");
      }
      
      private function active(e:PopupManagerEvent) : void
      {
         if(this.mRequests[Framework.popupManager.active] != null)
         {
            Peripheral.hmiRequest.globalPopupReturnResult(Framework.popupManager.active,HMIRequestEvent.POPUP_DISPLAYED,this.mGlobalPopupByMsgId);
         }
      }
      
      private function timeout(e:PopupManagerEvent) : void
      {
         if(this.mRequests[Framework.popupManager.active] != null)
         {
            Peripheral.hmiRequest.globalPopupClosed(Framework.popupManager.active,HMIRequestEvent.TIMEOUT,"","");
            this.remove(Framework.popupManager.active);
         }
      }
      
      private function onInfoPopupClosed(e:GlobalEvent) : void
      {
         if(this.mRequests[e.data.id] != null)
         {
            Peripheral.hmiRequest.globalPopupClosed(e.data.id,HMIRequestEvent.BTN_PRESSED,"CLOSE","");
            this.remove(e.data.id);
         }
      }
      
      private function onInfoPopupCancel(e:GlobalEvent) : void
      {
         if(this.mRequests[e.data.id] != null)
         {
            Peripheral.hmiRequest.globalPopupClosed(e.data.id,HMIRequestEvent.BTN_PRESSED,this.mRequests[e.data.id].caption1,this.mRequests[e.data.id].caption1Id);
            this.remove(e.data.id);
         }
      }
      
      private function onInfoPopupOk(e:GlobalEvent) : void
      {
         if(this.mRequests[e.data.id] != null)
         {
            Peripheral.hmiRequest.globalPopupClosed(e.data.id,HMIRequestEvent.BTN_PRESSED,this.mRequests[e.data.id].caption2,this.mRequests[e.data.id].caption2Id);
            this.remove(e.data.id);
            this.showRunningCategory();
         }
      }
      
      private function onOneItemPopupCancel(e:GlobalEvent) : void
      {
         var popupId:int = int(e.data.id);
         if(popupId == DynamicPopupNames.PTY31_ANNOUNCEMENT)
         {
            Peripheral.announcementMaster.requestAbortAnnouncement();
         }
      }
      
      private function onTwoItemPopupClosed(e:GlobalEvent) : void
      {
         if(this.mRequests[e.data.id] != null)
         {
            Peripheral.hmiRequest.globalPopupClosed(e.data.id,HMIRequestEvent.BTN_PRESSED,"CLOSE","");
            this.remove(e.data.id);
         }
      }
      
      private function onTwoItemLeftClick(e:GlobalEvent) : void
      {
         var popupId:int = 0;
         if(this.mRequests[e.data.id] != null)
         {
            Peripheral.hmiRequest.globalPopupClosed(e.data.id,HMIRequestEvent.BTN_PRESSED,this.mRequests[e.data.id].caption1,this.mRequests[e.data.id].caption1Id);
            this.remove(e.data.id);
         }
         else
         {
            popupId = int(e.data.id);
            if(popupId == DynamicPopupNames.TA_ANNOUNCEMENT)
            {
               Peripheral.announcementMaster.requestAbortAnnouncement();
            }
         }
      }
      
      private function onTwoItemRightClick(e:GlobalEvent) : void
      {
         var popupId:int = 0;
         if(this.mRequests[e.data.id] != null)
         {
            Peripheral.hmiRequest.globalPopupClosed(e.data.id,HMIRequestEvent.BTN_PRESSED,this.mRequests[e.data.id].caption2,this.mRequests[e.data.id].caption2Id);
            this.remove(e.data.id);
         }
         else
         {
            popupId = int(e.data.id);
            if(popupId == DynamicPopupNames.TA_ANNOUNCEMENT)
            {
               if(Peripheral.announcementMaster.advisoryMessage == AdvisoryMessageTypes.ROAD_TRAFFIC)
               {
                  Peripheral.announcementMaster.setTunerAnnouncementSwitch(false);
               }
               else
               {
                  Peripheral.announcementMaster.setDabCategory(Peripheral.announcementMaster.advisoryMessage,false);
               }
            }
         }
      }
      
      private function onThreeItemPopupClosed(e:GlobalEvent) : void
      {
         if(this.mRequests[e.data.id] != null)
         {
            Peripheral.hmiRequest.globalPopupClosed(e.data.id,HMIRequestEvent.BTN_PRESSED,"CLOSE","");
            this.remove(e.data.id);
         }
      }
      
      private function onThreeItemLeftClick(e:GlobalEvent) : void
      {
         if(this.mRequests[e.data.id] != null)
         {
            Peripheral.hmiRequest.globalPopupClosed(e.data.id,HMIRequestEvent.BTN_PRESSED,this.mRequests[e.data.id].caption1,this.mRequests[e.data.id].caption1Id);
            this.remove(e.data.id);
         }
      }
      
      private function onThreeItemRightClick(e:GlobalEvent) : void
      {
         if(this.mRequests[e.data.id] != null)
         {
            Peripheral.hmiRequest.globalPopupClosed(e.data.id,HMIRequestEvent.BTN_PRESSED,this.mRequests[e.data.id].caption3,this.mRequests[e.data.id].caption3Id);
            this.remove(e.data.id);
         }
      }
      
      private function onThreeItemCenterClick(e:GlobalEvent) : void
      {
         if(this.mRequests[e.data.id] != null)
         {
            Peripheral.hmiRequest.globalPopupClosed(e.data.id,HMIRequestEvent.BTN_PRESSED,this.mRequests[e.data.id].caption2,this.mRequests[e.data.id].caption2Id);
            this.remove(e.data.id);
         }
      }
      
      private function onWeatherAlert(e:NavigationEvent) : void
      {
         var obj:Object = Peripheral.navigation.navigation.gwAlertPopupInfo;
         if(obj.hasOwnProperty("type"))
         {
            Framework.popupManager.show(DynamicPopupNames.TL_WEATHER_ALERT,"weatheralertpopup",{
               "title":String(obj.type),
               "timeframe":"Ends at: " + String(obj.endTime.date) + " at " + String(obj.endTime.time)
            });
         }
      }
      
      private function onNavOperable(e:NavDomainControllerEvent) : void
      {
         if(Peripheral.navigation.navDomainControl.navIsOperable == true)
         {
            Peripheral.navigation.navDomainControl.removeEventListener(NavDomainControllerEvent.NAV_IS_OPERABLE,this.onNavOperable);
            Peripheral.navigation.navigation.addEventListener(NavigationEvent.GW_ALERT_POPUP,this.onWeatherAlert,false,0,true);
         }
      }
      
      private function onDisplayHotWarning(e:IPAddressInfoEvent) : void
      {
         if(Peripheral.ipaddressInfo.displayHotWarning == true)
         {
            Ancillary.definedDynamicPopups.show(DynamicPopupNames.DISPLAY_HOT_WARNING);
         }
      }
      
      private function onDriverABRecall(e:DriverABEvent) : void
      {
         Ancillary.definedDynamicPopups.popup(DynamicPopupNames.DRIVER_SETTINGS_RECALL,{"driver":Peripheral.driverAB.driver.toString()});
      }
      
      private function onBrakeServiceText(e:PersonalConfigEvent = null) : void
      {
         var autoDisplayTextMsgs:Array = new Array("13","15","20","21","25");
         if(!Framework.popupManager.check(DynamicPopupNames.BRAKESERVICE))
         {
            if(Peripheral.personalConfig.brakeServiceStatus == true && autoDisplayTextMsgs.indexOf(Peripheral.personalConfig.brakeServiceTextDisplay) != -1)
            {
               Framework.popupManager.show(DynamicPopupNames.BRAKESERVICE,"brakeservicepopup",{
                  "type":PopupType.IMPORTANT,
                  "status":""
               });
            }
         }
      }
      
      private function onBrakeServiceStatus(e:PersonalConfigEvent) : void
      {
         if(!Framework.popupManager.check(DynamicPopupNames.BRAKESERVICE))
         {
            if(Peripheral.personalConfig.brakeServiceStatus == false)
            {
               Framework.popupManager.show(DynamicPopupNames.BRAKESERVICE,"brakeservicepopup",{
                  "type":PopupType.IMPORTANT,
                  "status":"ModeOff"
               });
            }
            else
            {
               this.onBrakeServiceText();
            }
         }
      }
      
      private function processArguments(arg:*) : *
      {
         var transId:Array = [];
         if(arg is Array)
         {
            transId = arg;
         }
         else
         {
            transId.push(arg);
         }
         for(var i:int = 0; i < arg.length; i++)
         {
            transId[i] = this.getSTRBMapping(transId[i]);
         }
         return transId;
      }
      
      private function getSTRBMapping(_id:*) : *
      {
         var _STRB:* = T[_id];
         if(_STRB != null)
         {
            return _STRB;
         }
         return _id;
      }
   }
}

