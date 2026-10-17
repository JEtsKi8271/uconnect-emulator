package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.SoftwareUpdateEvent;
   import com.nfuzion.moduleLink.ConnectionEvent;
   
   public class SoftwareUpdateDatabase
   {
      
      private static const mDbusIdentifier:String = "SoftwareInstaller";
      
      public static const c_NO_MEDIA:String = "noMedia";
      
      public static const c_IDENTIFYING:String = "identifying";
      
      public static const c_UPDATE_MEDIA_NOT_AVAILABLE:String = "updateMediaNotAvailable";
      
      public static const c_UPDATE_MEDIA_AVAILABLE:String = "updateMediaAvailable";
      
      public static const c_UPDATING:String = "updating";
      
      public static const c_UPDATE_DONE:String = "updateDone";
      
      public static const c_ACTIVATION_UNKNOWN:int = 0;
      
      public static const c_ACTIVATION_REQUESTING:int = 1;
      
      public static const c_ACTIVATION_ACCEPTED:int = 2;
      
      public static const c_ACTIVATION_DECLINED:int = 3;
      
      public static const c_ACTIVATION_NOT_ACTIVATED:int = 4;
      
      private var mTimer:uint = 0;
      
      private var mSWUpd:SoftwareUpdate;
      
      private var mUpdateStatus:Object = new Object();
      
      private var mRequestCode:String = "";
      
      private var mActivationCodeAcceptanceState:int = 0;
      
      public function SoftwareUpdateDatabase(swupd:SoftwareUpdate)
      {
         super();
         this.mSWUpd = swupd;
      }
      
      public function subscribeHandler() : void
      {
         this.subscribe("updateStatus");
      }
      
      public function sendDBUpdateStartUpdate() : void
      {
         this.sendCommand("\"update\":{}");
      }
      
      public function sendDBUpdateReset() : void
      {
         this.sendCommand("\"reset\":{}");
      }
      
      public function sendDBUpdateDeclineUpdate() : void
      {
         this.sendCommand("\"updateDeclined\":{}");
      }
      
      public function sendActivationCode(activationCode:String) : void
      {
         this.sendCommand("\"setActivationCode\":{" + "\"activationCode\":\"" + activationCode + "\"," + "\"requestCode\":\"" + this.mRequestCode + "\"}");
         this.mActivationCodeAcceptanceState = c_ACTIVATION_REQUESTING;
         this.mSWUpd.dispatchEvent(new SoftwareUpdateEvent(SoftwareUpdateEvent.NAV_DB_ACTIVATION_CODE_ACCEPT));
      }
      
      public function sendDBUpdateActivationCodeReset() : void
      {
         if(this.mActivationCodeAcceptanceState == c_ACTIVATION_DECLINED)
         {
            this.mActivationCodeAcceptanceState = c_ACTIVATION_NOT_ACTIVATED;
         }
         else
         {
            this.mActivationCodeAcceptanceState = c_ACTIVATION_UNKNOWN;
         }
         this.mSWUpd.dispatchEvent(new SoftwareUpdateEvent(SoftwareUpdateEvent.NAV_DB_ACTIVATION_CODE_ACCEPT));
      }
      
      public function get updateDBActivationCodeAcceptanceState() : int
      {
         return this.mActivationCodeAcceptanceState;
      }
      
      public function get updateState() : Object
      {
         if(this.mUpdateStatus != null && this.mUpdateStatus.hasOwnProperty("state"))
         {
            return this.mUpdateStatus;
         }
         return "";
      }
      
      public function messageHandler(e:ConnectionEvent) : void
      {
         var i:String = null;
         var resp:Object = e.data;
         for(i in resp)
         {
            switch(i)
            {
               case "updateStatus":
                  this.mUpdateStatus = resp.updateStatus;
                  this.checkForRequesterCode();
                  this.mSWUpd.dispatchEvent(new SoftwareUpdateEvent(SoftwareUpdateEvent.NAV_DB_UPDATE_STATE));
                  break;
               case "setActivationCode":
                  if(Boolean(resp.setActivationCode.hasOwnProperty("activationStatus")) && String(resp.setActivationCode.activationStatus) == "true")
                  {
                     this.mActivationCodeAcceptanceState = c_ACTIVATION_ACCEPTED;
                  }
                  else
                  {
                     this.mActivationCodeAcceptanceState = c_ACTIVATION_DECLINED;
                  }
                  this.mSWUpd.dispatchEvent(new SoftwareUpdateEvent(SoftwareUpdateEvent.NAV_DB_ACTIVATION_CODE_ACCEPT));
            }
         }
      }
      
      private function checkForRequesterCode() : void
      {
         if(this.mUpdateStatus.hasOwnProperty("state"))
         {
            if(this.mUpdateStatus["state"] == c_UPDATE_MEDIA_AVAILABLE)
            {
               if(this.mUpdateStatus.hasOwnProperty("activationRequestCode"))
               {
                  this.mActivationCodeAcceptanceState = c_ACTIVATION_NOT_ACTIVATED;
                  this.mRequestCode = String(this.mUpdateStatus["activationRequestCode"]);
               }
               else
               {
                  this.mActivationCodeAcceptanceState = c_ACTIVATION_ACCEPTED;
                  this.mSWUpd.dispatchEvent(new SoftwareUpdateEvent(SoftwareUpdateEvent.NAV_DB_ACTIVATION_CODE_ACCEPT));
               }
            }
         }
      }
      
      private function sendCommand(command:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": {" + command + "}}";
         this.mSWUpd.spanClient.send(message);
      }
      
      private function subscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + mDbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.mSWUpd.spanClient.send(message);
      }
      
      private function unsubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + mDbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.mSWUpd.spanClient.send(message);
      }
      
      private function onInterval() : void
      {
         switch(this.mUpdateStatus["state"])
         {
            case c_NO_MEDIA:
               this.mUpdateStatus["state"] = c_IDENTIFYING;
               this.mUpdateStatus["messageText"] = "Identifying database updates.";
               break;
            case c_IDENTIFYING:
               this.mUpdateStatus["state"] = c_UPDATE_MEDIA_NOT_AVAILABLE;
               break;
            case c_UPDATE_MEDIA_NOT_AVAILABLE:
               this.mUpdateStatus["state"] = c_UPDATE_MEDIA_AVAILABLE;
               this.mUpdateStatus["updateType"] = "navDB";
               this.mUpdateStatus["activationRequestCode"] = "X3XA-ZX5F-BZWE-RPZL-D0H9-Q9";
               this.mUpdateStatus["versionInfo"] = new Object();
               this.mUpdateStatus["versionInfo"]["newVersion"] = "iGO primo North America";
               this.mUpdateStatus["versionInfo"]["currentVersion"] = "NQNA2011Q4";
               break;
            case c_UPDATE_MEDIA_AVAILABLE:
               this.mUpdateStatus["state"] = c_UPDATING;
               this.mUpdateStatus["updatingStep"] = "The update progress is xx%.";
               break;
            case c_UPDATING:
               this.mUpdateStatus["state"] = c_UPDATE_DONE;
               break;
            case c_UPDATE_DONE:
               this.mUpdateStatus["state"] = c_NO_MEDIA;
               break;
            default:
               this.mUpdateStatus["state"] = c_NO_MEDIA;
         }
         this.mSWUpd.dispatchEvent(new SoftwareUpdateEvent(SoftwareUpdateEvent.NAV_DB_UPDATE_STATE));
      }
   }
}

