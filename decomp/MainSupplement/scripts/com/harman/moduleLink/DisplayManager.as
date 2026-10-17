package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.DisplayManagerEvent;
   import com.harman.moduleLinkAPI.DisplayManagerLayers;
   import com.harman.moduleLinkAPI.IDisplayManager;
   import com.nfuzion.moduleLink.Connection;
   import com.nfuzion.moduleLink.ConnectionEvent;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.utils.Dictionary;
   
   public class DisplayManager extends Module implements IDisplayManager
   {
      
      private static var instance:DisplayManager;
      
      private static const dBusSignalActivatedLayer:String = "activatedLayer";
      
      private static const dBusSignalDeactivatedLayer:String = "deactivatedLayer";
      
      private static const dBusSignalRearCameraStatus:String = "rearCameraStatus";
      
      private static const dbusIdentifier:String = "DisplayManager";
      
      private var connection:Connection;
      
      private var client:Client;
      
      private var mLayers:Dictionary = new Dictionary(true);
      
      private var mConnected:Boolean = false;
      
      private var mRearCameraStatus:Boolean = false;
      
      public function DisplayManager()
      {
         super();
         this.init();
      }
      
      public static function getInstance() : DisplayManager
      {
         if(instance == null)
         {
            instance = new DisplayManager();
         }
         return instance;
      }
      
      private function init() : void
      {
         this.connection = Connection.share();
         this.client = this.connection.span;
         this.connection.addEventListener(ConnectionEvent.DISPLAY_MANAGER,this.displayMessageHandler);
         this.getProperties();
         this.sendMultiSubscribe([dBusSignalRearCameraStatus,dBusSignalActivatedLayer,dBusSignalDeactivatedLayer]);
         this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
      }
      
      public function getLayerVisibility(_layer:String) : Boolean
      {
         return this.mLayers[_layer];
      }
      
      public function requestDisplay(_layer:String, _visible:Boolean) : void
      {
         var message:String = "{\"Type\":\"Command\", \"Dest\":\"DisplayManager\",\"packet\":{\"requestDisplay\":{\"requester\":\"" + _layer + "\",\"value\":\"" + (_visible ? "true" : "false") + "\"}}}";
         this.client.send(message);
      }
      
      public function get RearCameraStatus() : Boolean
      {
         return this.mRearCameraStatus;
      }
      
      public function getProperties() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"DisplayManager\",\"packet\": {\"getProperties\":{\"props\":[\"rearCameraStatus\"] } } }");
      }
      
      public function displayMessageHandler(e:ConnectionEvent) : void
      {
         var _layer:String = null;
         var _visible:Boolean = false;
         var resp:Object = e.data;
         if(resp.hasOwnProperty("getProperties"))
         {
            if(resp.getProperties.hasOwnProperty("rearCameraStatus"))
            {
               this.mRearCameraStatus = resp.getProperties.rearCameraStatus;
            }
         }
         else if(resp.hasOwnProperty(dBusSignalRearCameraStatus))
         {
            this.mRearCameraStatus = resp[dBusSignalRearCameraStatus][dBusSignalRearCameraStatus];
            dispatchEvent(new DisplayManagerEvent(DisplayManagerEvent.DISPLAY_REARCAMERA_STATUS,e.data));
         }
         else if(resp.hasOwnProperty(dBusSignalActivatedLayer))
         {
            if(resp[dBusSignalActivatedLayer][dBusSignalActivatedLayer] == "short_term_cam_full")
            {
               this.mLayers[DisplayManagerLayers.LAYER_CAMERA_FRONTSIDE] = true;
               dispatchEvent(new DisplayManagerEvent(DisplayManagerEvent.DISPLAY_LAYER_CHANGE,DisplayManagerLayers.LAYER_CAMERA_FRONTSIDE));
            }
            else
            {
               this.mLayers[resp[dBusSignalActivatedLayer][dBusSignalActivatedLayer]] = true;
               dispatchEvent(new DisplayManagerEvent(DisplayManagerEvent.DISPLAY_LAYER_CHANGE,resp[dBusSignalActivatedLayer][dBusSignalActivatedLayer]));
            }
         }
         else if(resp.hasOwnProperty(dBusSignalDeactivatedLayer))
         {
            if(resp[dBusSignalDeactivatedLayer][dBusSignalDeactivatedLayer] == "short_term_cam_full")
            {
               this.mLayers[DisplayManagerLayers.LAYER_CAMERA_FRONTSIDE] = false;
               dispatchEvent(new DisplayManagerEvent(DisplayManagerEvent.DISPLAY_LAYER_CHANGE,DisplayManagerLayers.LAYER_CAMERA_FRONTSIDE));
            }
            else
            {
               this.mLayers[resp[dBusSignalDeactivatedLayer][dBusSignalDeactivatedLayer]] = false;
               dispatchEvent(new DisplayManagerEvent(DisplayManagerEvent.DISPLAY_LAYER_CHANGE,resp[dBusSignalDeactivatedLayer][dBusSignalDeactivatedLayer]));
            }
         }
         else if(resp.hasOwnProperty("requestDisplay"))
         {
            if(Boolean(resp.requestDisplay.hasOwnProperty("layer")) && Boolean(resp.requestDisplay.hasOwnProperty("visible")))
            {
               if(resp.requestDisplay.hasOwnProperty("granted") == true)
               {
                  _layer = resp.requestDisplay.layer;
                  _visible = resp.requestDisplay.visible == "true";
                  if((_layer == DisplayManagerLayers.LAYER_DMBFULL || _layer == DisplayManagerLayers.LAYER_DMBSPLIT) && _visible)
                  {
                     this.mLayers[DisplayManagerLayers.LAYER_DMBSPLIT] = false;
                     this.mLayers[DisplayManagerLayers.LAYER_DMBFULL] = false;
                  }
                  if(this.mLayers[_layer] != _visible)
                  {
                     this.mLayers[_layer] = _visible;
                     dispatchEvent(new DisplayManagerEvent(DisplayManagerEvent.DISPLAY_VISIBILITY_CHANGE,e.data));
                  }
               }
            }
            if(resp.requestDisplay.hasOwnProperty("granted"))
            {
               dispatchEvent(new DisplayManagerEvent(DisplayManagerEvent.DISPLAY_REQUEST_RESPONSE,e.data));
            }
         }
      }
      
      protected function sendAvailableRequest() : void
      {
         var message:String = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"" + dbusIdentifier + "\"}";
         this.client.send(message);
      }
      
      override protected function subscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      protected function sendMultiSubscribe(signalsArray:Array) : void
      {
         var message:String = null;
         var i:uint = 0;
         for(message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signals\": ["; i < signalsArray.length; )
         {
            message = message + "\"" + signalsArray[i] + "\"";
            if(signalsArray[i + 1])
            {
               message += ",";
            }
            i++;
         }
         message += "]}";
         this.client.send(message);
      }
      
      override protected function unsubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
   }
}

