package screens.NA_EU.RES_640x480
{
   import ancillary.Ancillary;
   import ancillary.Breadcrumb;
   import ancillary.DynamicPopupNames;
   import ancillary.Extensions;
   import ancillary.Format;
   import ancillary.Screens;
   import com.harman.moduleLinkAPI.VehicleStatusEvent;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.framework.screenTemplates.GenericScreen;
   import com.nfuzion.moduleLinkAPI.*;
   import core.enums.FocusObject;
   import core.enums.FocusPriority;
   import core.enums.Layers;
   import core.enums.PopupType;
   import events.GlobalEvent;
   import events.HardControlEvent;
   import events.WidgetEvent;
   import flash.display.MovieClip;
   import flash.events.*;
   import locale.T;
   import peripheral.Peripheral;
   import skin.Skin;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class BluetoothSettingsScreen extends GenericScreen
   {
      
      private static const MAKE_FAVORITE:int = 0;
      
      private static const DELETE_DEVICE:int = 1;
      
      private static const ENABLE_DATA_CONNECTION:int = 2;
      
      private static const DISABLE_DATA_CONNECTION:int = 3;
      
      private static const SETUP_DATA_CONNECTION:int = 4;
      
      private var mDataDevice:BluetoothDevice;
      
      private var mMenuState:int = 0;
      
      private var mListVector:Vector.<BluetoothDevice>;
      
      private var mDeviceName:String = "";
      
      private var mA2dp:Boolean = false;
      
      private var mBluetoothType:String;
      
      private var mAppsOptionsPopup:int = -1;
      
      private var mCurrentPosition:int = 0;
      
      public function BluetoothSettingsScreen()
      {
         mView = new C_BluetoothSettingsScreenView();
         super();
      }
      
      override protected function initView() : void
      {
         super.initView();
         mView.bluetooth_list.attachScroller(mView.bluetooth_scroller);
         this.mCurrentPosition = 0;
         mView.bluetooth_list.setRowUpdater(this.initRow);
         mView.bluetooth_list.update();
         mView.bluetooth_list.setRowUpdater(this.updateRow);
         mView.bluetooth_list.setDataRequester(this.requestListData);
         mView.bluetooth_list.setSelectionChanger(this.changeSelection);
         mView.viewButtons_group.setRadioButtons(true);
         mView.viewButtons_group.setRequireSelection(true);
         mView.viewButtons_group.pairedDataDevices_button.visible = false;
      }
      
      override public function cleanup() : void
      {
         this.mDataDevice = null;
         this.mListVector = null;
         super.cleanup();
      }
      
      override protected function initScreen() : void
      {
         super.initScreen();
         mView.viewButtons_group.pairedDataDevices_button.setInteractive(false);
         mView.viewButtons_group.pairedDataDevices_button.setEnabled(false);
         if(screenVars != null)
         {
            switch(screenVars.source)
            {
               case "audio":
                  mView.viewButtons_group.setSelection("pairedAudioSources_button");
                  this.mA2dp = true;
                  break;
               case "phones":
                  mView.viewButtons_group.setSelection("pairedPhones_button");
                  this.mA2dp = false;
                  break;
               case "data":
                  mView.viewButtons_group.setSelection("pairedDataDevices_button");
                  break;
               default:
                  mView.viewButtons_group.setSelection("pairedPhones_button");
                  this.mA2dp = false;
            }
         }
         else if(this.mBluetoothType == "DUN_&_PAN")
         {
            mView.viewButtons_group.setSelection("pairedDataDevices_button");
         }
         else
         {
            mView.viewButtons_group.setSelection("pairedPhones_button");
            this.mA2dp = false;
         }
         mView.bluetooth_list.setCursor(0);
         this.setView(mView.viewButtons_group.getSelection());
         this.onSpeedLockOutEvent(null);
         Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,mView.bluetooth_list.onFocusCallBack));
         Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.REGULAR,[mView.addDevice_button,mView.changePin_button]));
         Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MINIMUM,[mView.viewButtons_group.pairedPhones_button,mView.viewButtons_group.pairedAudioSources_button,mView.viewButtons_group.pairedDataDevices]));
      }
      
      override public function screenOut() : void
      {
         Framework.popupManager.dequeue(DynamicPopupNames.PHONE_SETTINGS);
         super.screenOut();
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         attachListener(Peripheral.bluetooth,BluetoothEvent.START_DEVICE_UNPAIRING_OK,this.onDeviceUnpairStarted);
         attachListener(Peripheral.bluetooth,BluetoothEvent.DEVICE_CONNECT_OK,this.onDeviceChange);
         attachListener(Peripheral.bluetooth,BluetoothEvent.DEVICE_CONNECT_FAIL,this.onDeviceConnectFail);
         attachListener(Peripheral.bluetooth,BluetoothEvent.SERVICE_DISCONNECTED,this.onDeviceChange);
         attachListener(Peripheral.bluetooth,BluetoothEvent.DEVICE_UNPAIRED,this.onDeviceChange);
         attachListener(Peripheral.bluetooth,BluetoothEvent.DEVICE_UNPAIRED,this.enableListenersAfterUnpairing);
         attachListener(Peripheral.bluetooth,BluetoothEvent.DEVICE_PAIRED_OK,this.onDeviceChange);
         attachListener(Peripheral.bluetooth,BluetoothEvent.PAIRED_DEVICE_LIST,this.onDeviceChange);
         attachListener(Peripheral.bluetoothPhone,BluetoothEvent.SUPPORTED_FEATURES_LIST,this.onSupportedFeaturesList,false,0,true);
         attachListener(mView.back_button,MouseEvent.CLICK,back);
         attachListener(mView.close_button,MouseEvent.CLICK,close);
         attachListener(mView.addDevice_button,MouseEvent.CLICK,this.addDeviceEvent);
         attachListener(mView.changePin_button,MouseEvent.CLICK,this.changePinEvent);
         attachListener(mView.viewButtons_group,WidgetEvent.SELECT,this.onViewButton);
         attachListener(mView.bluetooth_list,WidgetEvent.SELECT,this.onListSelect);
         attachListener(Peripheral.hardControls,HardControlEvent.VERTICAL_SCROLL,mView.bluetooth_list.scrollEventHandler);
         attachListener(Peripheral.hardControls,HardControlEvent.SELECT,mView.bluetooth_list.selectEventHandler);
         attachListener(Framework.popupManager,GlobalEvent.OPTIONS_POPUP_CLOSED,this.onOptionsPopupClosed);
         attachListener(Framework.popupManager,GlobalEvent.OPTIONS_POPUP_BUTTON,this.onOptionsPopupButton);
         attachListener(Peripheral.voiceRecognition,VoiceRecognitionEvent.VR_GOTO,this.onVRShortcut);
         attachListener(Peripheral.vehicleStatus,VehicleStatusEvent.SPEED_LOCK_OUT,this.onSpeedLockOutEvent);
      }
      
      override protected function removeListeners() : void
      {
         detachListener(Peripheral.bluetooth,BluetoothEvent.START_DEVICE_UNPAIRING_OK,this.onDeviceUnpairStarted);
         detachListener(Peripheral.bluetooth,BluetoothEvent.DEVICE_CONNECT_OK,this.onDeviceChange);
         detachListener(Peripheral.bluetooth,BluetoothEvent.DEVICE_CONNECT_FAIL,this.onDeviceConnectFail);
         detachListener(Peripheral.bluetooth,BluetoothEvent.SERVICE_DISCONNECTED,this.onDeviceChange);
         detachListener(Peripheral.bluetooth,BluetoothEvent.DEVICE_UNPAIRED,this.onDeviceChange);
         detachListener(Peripheral.bluetooth,BluetoothEvent.DEVICE_UNPAIRED,this.enableListenersAfterUnpairing);
         detachListener(Peripheral.bluetooth,BluetoothEvent.DEVICE_PAIRED_OK,this.onDeviceChange);
         detachListener(Peripheral.bluetooth,BluetoothEvent.PAIRED_DEVICE_LIST,this.onDeviceChange);
         detachListener(Peripheral.bluetoothPhone,BluetoothEvent.SUPPORTED_FEATURES_LIST,this.onSupportedFeaturesList);
         detachListener(mView.back_button,MouseEvent.CLICK,back);
         detachListener(mView.close_button,MouseEvent.CLICK,close);
         detachListener(mView.addDevice_button,MouseEvent.CLICK,this.addDeviceEvent);
         detachListener(mView.changePin_button,MouseEvent.CLICK,this.changePinEvent);
         detachListener(mView.viewButtons_group,WidgetEvent.SELECT,this.onViewButton);
         detachListener(mView.bluetooth_list,WidgetEvent.SELECT,this.onListSelect);
         detachListener(Peripheral.hardControls,HardControlEvent.VERTICAL_SCROLL,mView.bluetooth_list.scrollEventHandler);
         detachListener(Peripheral.hardControls,HardControlEvent.SELECT,mView.bluetooth_list.selectEventHandler);
         detachListener(Framework.popupManager,GlobalEvent.OPTIONS_POPUP_CLOSED,this.onOptionsPopupClosed);
         detachListener(Framework.popupManager,GlobalEvent.OPTIONS_POPUP_BUTTON,this.onOptionsPopupButton);
         detachListener(Peripheral.voiceRecognition,VoiceRecognitionEvent.VR_GOTO,this.onVRShortcut);
         super.removeListeners();
      }
      
      override protected function changeLocale(e:Event = null) : void
      {
         super.changeLocale(e);
         mView.bluetooth_list.update();
         t(mView.viewButtons_group.pairedPhones_button.value_label,T.STRB_PAIRED_PHONES);
         t(mView.viewButtons_group.pairedAudioSources_button.value_label,T.STRB_PAIRED_AUDIO);
         t(mView.viewButtons_group.pairedDataDevices_button.value_label,T.STRB_PAIRED_DATA);
         t(mView.addDevice_button.value_label,T.STRB_ADD_DEVICE);
         t(mView.changePin_button.value_label,T.STRB_CHANGE_PIN);
         t(mView.notification.label,T.STRB_NOT_AVAILABLE_DURING_PROJECTION);
      }
      
      private function onViewButton(e:WidgetEvent) : void
      {
         Peripheral.bluetooth.reqPairedDeviceList();
         if(Framework.popupManager.active == DynamicPopupNames.PHONE_SETTINGS)
         {
            Framework.popupManager.dequeue(DynamicPopupNames.PHONE_SETTINGS);
         }
         this.setView(e.data.targetName);
         Framework.focusManager.setFocus(FocusPriority.MAXIMUM);
      }
      
      private function setView(view:String) : void
      {
         clearBreadcrumbs();
         pushBreadcrumb(new Breadcrumb(T.STRB_SETTINGS_BREADCRUMB,Breadcrumb.PAGE,Screens.SETTINGS_SCREEN));
         pushBreadcrumb(new Breadcrumb(T.STRB_PHONE_BREADCRUMB,Breadcrumb.PAGE,Screens.SETTINGS_PHONE_BLUETOOTH));
         switch(view)
         {
            case "pairedPhones_button":
               pushBreadcrumb(new Breadcrumb(T.STRB_PAIRED_PHONES_1,Breadcrumb.INERT));
               this.mA2dp = false;
               this.mBluetoothType = "HFP";
               mView.notification.visible = Peripheral.phoneProjection.sessionActive;
               break;
            case "pairedAudioSources_button":
               pushBreadcrumb(new Breadcrumb(T.STRB_PAIRED_AUDIO_SOURCES,Breadcrumb.INERT));
               this.mA2dp = true;
               this.mBluetoothType = "A2DP";
               mView.notification.visible = false;
               break;
            case "pairedDataDevices_button":
               this.mA2dp = false;
               this.mBluetoothType = "DUN_&_PAN";
         }
         var length:int = int(Peripheral.bluetooth.getPairedDeviceListWithService(this.mBluetoothType).length);
         t(mView.itemsInList_label,Format.itemsInList(length));
         mView.bluetooth_list.setLength(length);
         this.mCurrentPosition = mView.bluetooth_list.getPosition();
         if(this.mCurrentPosition >= length)
         {
            if(length > 0)
            {
               this.mCurrentPosition = length - 1;
            }
            else
            {
               this.mCurrentPosition = 0;
            }
         }
         mView.bluetooth_list.setPosition(this.mCurrentPosition);
         mView.bluetooth_list.requestData();
      }
      
      private function onDeviceUnpairStarted(e:BluetoothEvent) : void
      {
         detachListener(Peripheral.bluetooth,BluetoothEvent.SERVICE_DISCONNECTED,this.onDeviceChange);
         detachListener(Peripheral.bluetooth,BluetoothEvent.PAIRED_DEVICE_LIST,this.onDeviceChange);
      }
      
      private function enableListenersAfterUnpairing(e:BluetoothEvent) : void
      {
         attachListener(Peripheral.bluetooth,BluetoothEvent.SERVICE_DISCONNECTED,this.onDeviceChange);
         attachListener(Peripheral.bluetooth,BluetoothEvent.PAIRED_DEVICE_LIST,this.onDeviceChange);
      }
      
      private function initRow(row:MovieClip, rowNumber:int, data:BluetoothDevice, dataIndex:int) : void
      {
         row.device_button.number_label.visible = false;
         row.device_button.name_label.visible = false;
         row.device_button.status_label.visible = false;
         row.options_button.visible = false;
      }
      
      private function updateRow(row:MovieClip, rowNumber:int, data:BluetoothDevice, dataIndex:int) : void
      {
         if(data != null)
         {
            row.device_button.setEnabled(true);
            row.device_button.number_label.visible = true;
            row.device_button.number_label.text = dataIndex + 1 + ")";
            row.device_button.name_label.visible = true;
            row.options_button.visible = true;
            if(this.mBluetoothType == "HFP" && data.HfpConnected == true || this.mBluetoothType == "A2DP" && data.A2dpConnected == true || this.mBluetoothType == "DUN_&_PAN" && (data.DunConnected == true || data.PanConnected == true))
            {
               row.device_button.status_label.visible = true;
               mView.formatListItem(row,true);
               Format.colorize(row.device_button.status_label,compose(T.STRB_CONNECTED),Skin.style.currentTheme.titleText.color.hexValue);
            }
            else
            {
               mView.formatListItem(row);
               row.device_button.status_label.visible = false;
            }
            Format.truncateCharacters(row.device_button.name_label,data.DevName);
         }
         else
         {
            row.device_button.setEnabled(false);
            row.device_button.number_label.visible = false;
            row.device_button.name_label.visible = false;
            row.device_button.status_label.visible = false;
            row.options_button.visible = false;
         }
      }
      
      private function requestListData(start:int, end:int) : void
      {
         var list:Vector.<BluetoothDevice> = Peripheral.bluetooth.getPairedDeviceListWithService(this.mBluetoothType);
         var data:Vector.<BluetoothDevice> = new Vector.<BluetoothDevice>();
         for(var i:int = start; i <= end; i++)
         {
            data.push(list[i]);
         }
         mView.bluetooth_list.setData({
            "offset":start,
            "list":data
         });
      }
      
      private function checkForSameIpod(btdevicename:String) : Boolean
      {
         var i:int = 0;
         var mMedia:Vector.<MediaPlayerDevice> = Peripheral.mediaPlayer.devices;
         for(i = 0; i < mMedia.length; i++)
         {
            if(mMedia[i].type == MediaPlayerDevice.IPOD)
            {
               if(mMedia[i].name == btdevicename)
               {
                  Peripheral.audioMixerManager.setTouchScreenEnable(true);
                  Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_REJECTION);
                  Ancillary.definedDynamicPopups.popup(DynamicPopupNames.ONEITEM_PLAYER_BTSA_NOT_AVAILABLE);
                  return true;
               }
            }
         }
         return false;
      }
      
      private function changeSelection(row:MovieClip, selected:Boolean) : void
      {
         row.device_button.setSelected(selected);
      }
      
      private function isDeviceFav(mDevice:BluetoothDevice) : int
      {
         var isFav:Boolean = false;
         if(mDevice.PanAvailable == true && mDevice.PanPriority == 1)
         {
            isFav = true;
         }
         else if(mDevice.DunAvailable == true && mDevice.DunPriority == 1)
         {
            isFav = true;
         }
         if(mDevice.DataEnabled)
         {
            this.mAppsOptionsPopup = isFav ? int(DynamicPopupNames.OPTIONS_BLUETOOTH_PAIRED_DATA_DEVICE_ENABLED_FAV_GREYED) : int(DynamicPopupNames.OPTIONS_BLUETOOTH_PAIRED_DATA_DEVICE_ENABLED_FAV_ENABLED);
         }
         else
         {
            this.mAppsOptionsPopup = isFav ? int(DynamicPopupNames.OPTIONS_BLUETOOTH_PAIRED_DATA_DEVICE_DISABLED_FAV_GREYED) : int(DynamicPopupNames.OPTIONS_BLUETOOTH_PAIRED_DATA_DEVICE_DISABLED_FAV_ENABLED);
         }
         return this.mAppsOptionsPopup;
      }
      
      private function onListSelect(e:WidgetEvent) : void
      {
         var item:BluetoothDevice = null;
         this.mDeviceName = e.data.data.DevName;
         if(Framework.popupManager.active == DynamicPopupNames.PHONE_SETTINGS)
         {
            Framework.popupManager.dequeue(DynamicPopupNames.PHONE_SETTINGS);
         }
         if(e.data.targetName == "options_button")
         {
            if(this.mBluetoothType == "DUN_&_PAN")
            {
               this.mDataDevice = e.data.data;
               Ancillary.definedDynamicPopups.popup(this.isDeviceFav(this.mDataDevice));
            }
            else
            {
               Framework.popupManager.show(DynamicPopupNames.PHONE_SETTINGS,"phonesettingsoptionpopup",{
                  "device":e.data.data,
                  "deviceServiceType":(this.mA2dp == true ? "A2DP" : "HFP")
               });
            }
         }
         else
         {
            item = e.data.data;
            if(this.mA2dp == false)
            {
               Peripheral.bluetooth.reqStartHFPConnect(item);
            }
            else if(this.checkForSameIpod(item.DevName) == false)
            {
               Peripheral.bluetooth.reqStartA2DPConnect(item);
            }
         }
      }
      
      private function onDeviceChange(e:BluetoothEvent) : void
      {
         var mNewDeviceIndex:int = int(e.currentTarget.PairedDeviceList.length);
         if(mNewDeviceIndex != 0 && e.type == "DeviceConnectOK" && false == e.currentTarget.PairedDeviceList[mNewDeviceIndex - 1].HfpAvailable && true == e.currentTarget.PairedDeviceList[mNewDeviceIndex - 1].A2dpAvailable && DynamicPopupNames.PHONE_PAIRING == Framework.popupManager.active)
         {
            mView.viewButtons_group.setSelection("pairedAudioSources_button");
         }
         this.setView(mView.viewButtons_group.getSelection());
         var length:int = int(Peripheral.bluetooth.getPairedDeviceListWithService(this.mBluetoothType).length);
         mView.bluetooth_list.setLength(length);
         t(mView.itemsInList_label,Format.itemsInList(length));
         mView.bluetooth_list.setData(null);
         mView.bluetooth_list.requestData();
         mView.bluetooth_list.update();
      }
      
      private function onDeviceConnectFail(evt:BluetoothEvent) : void
      {
         if(evt.data != "pending")
         {
            Framework.popupManager.show(DynamicPopupNames.PHONE_PAIRING,"phonepairingpopup",{
               "type":PopupType.PRIMARY,
               "timeout":4000,
               "status":"device not available",
               "deviceName":this.mDeviceName
            });
         }
      }
      
      private function addDeviceEvent(e:Event) : void
      {
         var screenType:String = null;
         if(Peripheral.bluetooth.BT_Status != false)
         {
            if(true == Peripheral.vehicleStatus.speedLockOut)
            {
               Ancillary.definedDynamicPopups.show(DynamicPopupNames.SPEED_LOCKOUT);
            }
            else
            {
               screenType = "";
               if(mView.viewButtons_group.getSelection() == "pairedAudioSources_button")
               {
                  screenType = "audio";
               }
               Framework.popupManager.show(DynamicPopupNames.PHONE_PAIRING,"phonepairingpopup",{
                  "type":PopupType.PRIMARY,
                  "status":"pairing",
                  "screen":screenType
               });
            }
         }
      }
      
      private function changePinEvent(e:Event) : void
      {
         if(Peripheral.bluetooth.BT_Status == true)
         {
            Framework.popupManager.show(DynamicPopupNames.PHONE_PIN_CHANGE,"phonechangepinpopup",{"type":PopupType.OPTIONS});
         }
      }
      
      private function onOptionsPopupButton(e:GlobalEvent) : void
      {
         Framework.popupManager.dequeue(this.mAppsOptionsPopup);
         switch(e.data.id)
         {
            case 0:
               if(this.mDataDevice.PanAvailable)
               {
                  Peripheral.bluetooth.reqSetFavourite(this.mDataDevice,"PAN");
               }
               else if(this.mDataDevice.DunAvailable)
               {
                  Peripheral.bluetooth.reqSetFavourite(this.mDataDevice,"DUN");
               }
               break;
            case 1:
               Framework.popupManager.show(DynamicPopupNames.PHONE_PAIRING,"phonepairingpopup",{
                  "type":PopupType.PRIMARY,
                  "status":"delete confirmation",
                  "deviceName":this.mDataDevice.DevName,
                  "device":this.mDataDevice
               });
               break;
            case 2:
               if(this.mDataDevice.DataEnabled)
               {
                  this.mDataDevice.DataEnabled = !this.mDataDevice.DataEnabled;
               }
               else
               {
                  this.mDataDevice.DataEnabled = !this.mDataDevice.DataEnabled;
               }
               Ancillary.definedDynamicPopups.popup(this.isDeviceFav(this.mDataDevice));
               break;
            case 3:
               if(this.mDataDevice.PanAvailable)
               {
                  Framework.structure.goto(Screens.APPS_LIST,{
                     "ext":Extensions.PAN_SETUP_LIST,
                     "device":this.mDataDevice
                  });
               }
               else if(this.mDataDevice.DunAvailable)
               {
                  Framework.structure.goto(Screens.APPS_LIST,{
                     "ext":Extensions.DUN_SETUP_LIST,
                     "device":this.mDataDevice
                  });
               }
               break;
            case 4:
               break;
            default:
               Framework.Trace("Unknown Button Press!");
         }
      }
      
      private function onOptionsPopupClosed(e:GlobalEvent) : void
      {
         Framework.popupManager.dequeue(this.mAppsOptionsPopup);
      }
      
      private function onSupportedFeaturesList(evt:BluetoothEvent) : void
      {
         Framework.Trace("onSupportedFeaturesList() Received: " + evt.data);
         if(evt.data != null)
         {
            Framework.Trace("onSupportedFeaturesList features: " + evt.data.features);
         }
      }
      
      private function onVRShortcut(evt:VoiceRecognitionEvent) : void
      {
         Framework.Trace("vr shortcut recieved " + evt.toString() + Peripheral.voiceRecognition.lastGoto);
         switch(evt.mData.videoScreen)
         {
            case Peripheral.voiceRecognition.PHONE_PAIRED_AUDIO_SOURCES:
               Framework.structure.goto(Screens.SETTINGS_BLUETOOTH,{"source":"audio"});
               mView.viewButtons_group.setSelection("pairedAudioSources_button");
               this.mA2dp = true;
               break;
            case Peripheral.voiceRecognition.PHONE_PAIRED_PHONES:
               mView.viewButtons_group.setSelection("pairedPhones_button");
               this.mA2dp = false;
         }
      }
      
      private function onSpeedLockOutEvent(e:VehicleStatusEvent) : void
      {
         if(Peripheral.vehicleStatus.speedLockOut)
         {
            mView.addDevice_button.setEnabled(false);
         }
         else
         {
            mView.addDevice_button.setEnabled(true);
         }
      }
   }
}

