package com.harman.navigation.authentication
{
   import com.harman.navigation.Controller.Persistence.PersistenceEvent;
   import com.harman.navigation.Controller.Persistence.PersistenceKeys;
   import com.harman.navigation.Navigation;
   import com.harman.navigation.NavigationEvent;
   import com.harman.navigation.global.NavigationPackage;
   import com.nfuzion.framework.global.Framework;
   
   public class authenticationManager
   {
      
      private var mParent:Navigation;
      
      private var mDeviceID:String = "";
      
      private var mSKUString:String = "";
      
      private var mActivationCode:String = "";
      
      private var mActivationCodePersist:String = "";
      
      private var mInterval:uint = 0;
      
      private var mAuthenticationSuccess:Boolean = false;
      
      private var mAttemptToMakeMMCWritable:Number = 0;
      
      private var mAttemptToTestWritability:Number = 0;
      
      private var mAuthenticationProcessStep:String = "";
      
      private const MAKING_WRITABLE:String = "MAKING_WRITABLE";
      
      private const TESTING_WRITABILITY:String = "TESTING_WRITABILITY";
      
      public function authenticationManager(parent:Navigation)
      {
         super();
         this.mParent = parent;
      }
      
      public function init() : void
      {
         this.mParent.sendSubscribe("\"UPD_ActivationCheck\"");
      }
      
      public function getAuthenticationDeviceID() : void
      {
         this.mParent.getProperty("UPD_ActivationCheck");
      }
      
      public function get authenticationDeviceID() : String
      {
         return this.mDeviceID;
      }
      
      public function setAuthenticationCode(code:String) : void
      {
         Framework.Trace("setAuthenticationCode: code= " + code);
         this.mActivationCode = code;
         this.mAuthenticationProcessStep = this.MAKING_WRITABLE;
         NavigationPackage.peripheral.navigation.navigation.addEventListener(NavigationEvent.TRAIL_SERVICE_EXECUTE,this.onTrailServiceExecute,false,0,true);
         ++this.mAttemptToMakeMMCWritable;
         this.mParent.sendServiceCommand(Navigation.dbusNavigationTrailInfoIdentifier,"\"execute\":{\"cmd\":\"mount -uw /fs/mmc0\"}");
      }
      
      private function onTrailServiceExecute(e:NavigationEvent) : void
      {
         Framework.Trace("onTrailServiceExecute: NavigationPackage.peripheral.navigation.navigation.getExecuteSuccessful()=" + NavigationPackage.peripheral.navigation.navigation.getExecuteSuccessful());
         Framework.Trace("onTrailServiceExecute: mAuthenticationProcessStep= " + this.mAuthenticationProcessStep);
         if(this.mAuthenticationProcessStep == this.MAKING_WRITABLE)
         {
            if(NavigationPackage.peripheral.navigation.navigation.getExecuteSuccessful())
            {
               this.mAuthenticationProcessStep = this.TESTING_WRITABILITY;
               ++this.mAttemptToTestWritability;
               this.mParent.sendServiceCommand(Navigation.dbusNavigationTrailInfoIdentifier,"\"execute\":{\"cmd\":\"touch /fs/mmc0/nav/NNG/license/test_file\"}");
            }
            else
            {
               Framework.Trace("onTrailServiceExecute: execution of enable writability failed: attempt #" + this.mAttemptToMakeMMCWritable);
               if(this.mAttemptToMakeMMCWritable < 5)
               {
                  ++this.mAttemptToMakeMMCWritable;
                  this.mParent.sendServiceCommand(Navigation.dbusNavigationTrailInfoIdentifier,"\"execute\":{\"cmd\":\"mount -uw /fs/mmc0\"}");
               }
               else
               {
                  Framework.Trace("onTrailServiceExecute: unable to make mmc0 writable, report activation failed");
                  this.mAuthenticationSuccess = false;
                  this.mAuthenticationProcessStep = "";
                  this.mParent.sendEvent(NavigationEvent.NAV_ACTIVATION_RESPONSE);
                  this.mAttemptToMakeMMCWritable = 0;
               }
            }
         }
         else if(this.mAuthenticationProcessStep == this.TESTING_WRITABILITY)
         {
            if(NavigationPackage.peripheral.navigation.navigation.getExecuteSuccessful())
            {
               this.mAuthenticationProcessStep = "";
               NavigationPackage.peripheral.navigation.navigation.removeEventListener(NavigationEvent.TRAIL_SERVICE_EXECUTE,this.onTrailServiceExecute,false);
               this.mParent.sendCommand("\"UPD_SetActivationCode\":{\"skuEIS\":\"" + this.mSKUString + "<ACD>" + this.mActivationCode + "<*>\"}");
            }
            else
            {
               Framework.Trace("onTrailServiceExecute: execution of test writability failed: attempt #" + this.mAttemptToTestWritability);
               if(this.mAttemptToTestWritability < 5)
               {
                  ++this.mAttemptToTestWritability;
                  this.mParent.sendServiceCommand(Navigation.dbusNavigationTrailInfoIdentifier,"\"execute\":{\"cmd\":\"touch /fs/mmc0/nav/NNG/license/test_file\"}");
               }
               else
               {
                  Framework.Trace("onTrailServiceExecute: unable to ensure writability, report activation failed");
                  this.mAuthenticationSuccess = false;
                  this.mAuthenticationProcessStep = "";
                  this.mParent.sendEvent(NavigationEvent.NAV_ACTIVATION_RESPONSE);
                  this.mAttemptToTestWritability = 0;
               }
            }
         }
         else
         {
            Framework.Trace("onTrailServiceExecute: we didn\'t ask for anything to be executed");
            NavigationPackage.peripheral.navigation.navigation.removeEventListener(NavigationEvent.TRAIL_SERVICE_EXECUTE,this.onTrailServiceExecute,false);
         }
      }
      
      public function get authenticationResponse() : Boolean
      {
         return this.mAuthenticationSuccess;
      }
      
      public function setDeviceID(skuEIS:Array) : void
      {
         var tmpString:String = null;
         var eisType:String = null;
         var eisValue:String = null;
         var endSection:String = new String("<*>");
         loop0:
         for(var i:int = 0; i < skuEIS.length; )
         {
            this.mSKUString = String(skuEIS[i]);
            tmpString = String(skuEIS[i]);
            while(true)
            {
               if(!(tmpString.length > 0 && tmpString.indexOf(endSection) > -1))
               {
                  i++;
                  continue loop0;
               }
               eisType = tmpString.substring(0,tmpString.indexOf(">") + 1);
               eisValue = tmpString.substring(tmpString.indexOf(">") + 1,tmpString.indexOf(endSection));
               if(eisType == "<RCD>")
               {
                  break;
               }
               tmpString = tmpString.slice(tmpString.indexOf(endSection) + 3,tmpString.length + 1);
            }
            this.mDeviceID = eisValue;
            Framework.Trace("Nav.AuthenticationManager.NAV_DEVICE_ID( " + this.mDeviceID + " )");
            this.mParent.sendEvent(NavigationEvent.NAV_DEVICE_ID);
            return;
         }
      }
      
      public function onActivationCheck(resp:Object) : void
      {
         Framework.Trace("Nav.AuthenticationManager.onActivationCheck( " + resp.toString() + " ) UNHANDLED! ");
      }
      
      public function onSetAuthenticationCodeResponse(resp:Object) : void
      {
         var obj:Object = null;
         Framework.Trace("onSetAuthenticationCodeResponse()");
         if(resp.hasOwnProperty("UPD_SetActivationCode"))
         {
            if(resp.UPD_SetActivationCode.hasOwnProperty("status"))
            {
               if(String(resp.UPD_SetActivationCode.status).indexOf("error") != -1)
               {
                  this.mAuthenticationSuccess = false;
                  Framework.Trace("Nav.AuthenticationManager.onSetAuthenticationCodeResponse( " + this.mAuthenticationSuccess + " )");
                  this.mParent.sendEvent(NavigationEvent.NAV_ACTIVATION_RESPONSE);
               }
            }
            if(resp.UPD_SetActivationCode.hasOwnProperty("resultCode"))
            {
               if(resp.UPD_SetActivationCode.resultCode == 1)
               {
                  this.mAuthenticationSuccess = true;
                  if(NavigationPackage.peripheral.navigation.navPersistence != null)
                  {
                     Framework.Trace("Nav.AuthenticationManager.Persistence EXISTS");
                     obj = new Object();
                     obj["VP3_AC"] = this.mActivationCode;
                     NavigationPackage.peripheral.navigation.navPersistence.saveData(PersistenceKeys.VP3_ACTIVATION_CODE,obj);
                  }
               }
               else
               {
                  this.mAuthenticationSuccess = false;
               }
               Framework.Trace("Nav.AuthenticationManager.onSetAuthenticationCodeResponse( " + this.mAuthenticationSuccess + " )");
               this.mParent.sendEvent(NavigationEvent.NAV_ACTIVATION_RESPONSE);
            }
         }
      }
      
      public function requestPreviousVP3ActivationCode() : void
      {
         NavigationPackage.peripheral.navigation.navPersistence.addEventListener(PersistenceEvent.PERS_DATA_LOADED,this.onPersistence,false,0,true);
         NavigationPackage.peripheral.navigation.navPersistence.loadData(PersistenceKeys.VP3_ACTIVATION_CODE);
      }
      
      public function get previousVP3ActivationCode() : String
      {
         return this.mActivationCodePersist;
      }
      
      private function onPersistence(e:PersistenceEvent) : void
      {
         var res:Object = null;
         var i:String = null;
         var tmp:String = NavigationPackage.peripheral.navigation.navPersistence.dataLoaded;
         if(NavigationPackage.peripheral.navigation.navPersistence.dataLoaded == PersistenceKeys.VP3_ACTIVATION_CODE)
         {
            res = NavigationPackage.peripheral.navigation.navPersistence.getDataLoaded(PersistenceKeys.VP3_ACTIVATION_CODE,true);
            if(res != null)
            {
               for(i in res)
               {
                  if(i == "VP3_AC")
                  {
                     this.mActivationCodePersist = String(res[i]);
                  }
               }
            }
            this.mParent.sendEvent(NavigationEvent.NAV_PREVIOUS_ACTIVATION_CODE);
            NavigationPackage.peripheral.navigation.navPersistence.removeEventListener(PersistenceEvent.PERS_DATA_LOADED,this.onPersistence);
         }
      }
   }
}

