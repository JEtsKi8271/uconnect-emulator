package peripheral
{
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLinkAPI.TextToSpeechEvent;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class ReadBackManager extends EventDispatcher
   {
      
      private var map:Object = new Object();
      
      private var mDomain:String;
      
      private var mButtonName:String;
      
      private var mCurrentReadPhrase:String;
      
      public function ReadBackManager()
      {
         var listener:Object = null;
         super();
         this.map["rse_button"] = {
            "mCounter":0,
            "secondPress":false,
            "mTimer":new Timer(5000),
            "mMultipleClickTimer":new Timer(200),
            "mVRAborted":false,
            "callBack":Function,
            "readBackCallBack":Function
         };
         this.map["media_button"] = {
            "mCounter":0,
            "secondPress":false,
            "mTimer":new Timer(5000),
            "mMultipleClickTimer":new Timer(200),
            "mVRAborted":false,
            "callBack":Function,
            "readBackCallBack":Function
         };
         this.map["RearMedia"] = {
            "mCounter":0,
            "secondPress":false,
            "mTimer":new Timer(5000),
            "mMultipleClickTimer":new Timer(200),
            "mVRAborted":false,
            "callBack":Function,
            "readBackCallBack":Function
         };
         this.map["seekforward_button"] = {
            "mCounter":0,
            "secondPress":false,
            "mTimer":new Timer(5000),
            "mMultipleClickTimer":new Timer(200),
            "mVRAborted":false,
            "callBack":Function,
            "readBackCallBack":Function
         };
         this.map["seekbackward_button"] = {
            "mCounter":0,
            "secondPress":false,
            "mTimer":new Timer(5000),
            "mMultipleClickTimer":new Timer(200),
            "mVRAborted":false,
            "callBack":Function,
            "readBackCallBack":Function
         };
         this.map["stop_button"] = {
            "mCounter":0,
            "secondPress":false,
            "mTimer":new Timer(5000),
            "mMultipleClickTimer":new Timer(200),
            "mVRAborted":false,
            "callBack":Function,
            "readBackCallBack":Function
         };
         this.map["play_button"] = {
            "mCounter":0,
            "secondPress":false,
            "mTimer":new Timer(5000),
            "mMultipleClickTimer":new Timer(200),
            "mVRAborted":false,
            "callBack":Function,
            "readBackCallBack":Function
         };
         this.map["pause_button"] = {
            "mCounter":0,
            "secondPress":false,
            "mTimer":new Timer(5000),
            "mMultipleClickTimer":new Timer(200),
            "mVRAborted":false,
            "callBack":Function,
            "readBackCallBack":Function
         };
         this.map["disc_button"] = {
            "mCounter":0,
            "secondPress":false,
            "mTimer":new Timer(5000),
            "mMultipleClickTimer":new Timer(200),
            "mVRAborted":false,
            "callBack":Function,
            "readBackCallBack":Function
         };
         this.map["fullscreen_button"] = {
            "mCounter":0,
            "secondPress":false,
            "mTimer":new Timer(5000),
            "mMultipleClickTimer":new Timer(200),
            "mVRAborted":false,
            "callBack":Function,
            "readBackCallBack":Function
         };
         this.map["usb_button"] = {
            "mCounter":0,
            "secondPress":false,
            "mTimer":new Timer(5000),
            "mMultipleClickTimer":new Timer(200),
            "mVRAborted":false,
            "callBack":Function,
            "readBackCallBack":Function
         };
         for each(listener in this.map)
         {
            listener.mTimer.addEventListener(TimerEvent.TIMER,this.onTimer);
            listener.mMultipleClickTimer.addEventListener(TimerEvent.TIMER,this.onMultipleClickTimer);
         }
         Peripheral.textToSpeach.addEventListener(TextToSpeechEvent.PLAY_STATE,this.onTextToSpeechEvent,false,0,true);
      }
      
      public function registerCallBack(buttonName:String, funcPtr:Function, readBackFuncPtr:Function) : void
      {
         if(Boolean(this.mButtonName) && buttonName != this.mButtonName)
         {
            this.map[this.mButtonName].mTimer.reset();
            this.map[this.mButtonName].mMultipleClickTimer.reset();
            this.map[this.mButtonName].secondPress = false;
            this.map[this.mButtonName].mCounter = 0;
         }
         this.mButtonName = buttonName;
         this.map[this.mButtonName].callBack = funcPtr;
         this.map[this.mButtonName].readBackCallBack = readBackFuncPtr;
      }
      
      public function updateObjVars(buttonName:String, objVars:Object) : void
      {
         var key:String = null;
         for(key in this.map)
         {
            if(buttonName == key)
            {
               this.map[buttonName].objVars = objVars;
            }
         }
      }
      
      public function videoReadBack() : void
      {
         var key:String = null;
         for(key in this.map)
         {
            if(this.mButtonName != key)
            {
               this.map[key].mCounter = 0;
               this.map[key].secondPress = false;
            }
         }
         ++this.map[this.mButtonName].mCounter;
         this.map[this.mButtonName].mMultipleClickTimer.reset();
         this.map[this.mButtonName].mMultipleClickTimer.start();
      }
      
      private function onTimer(e:TimerEvent) : void
      {
         this.map[this.mButtonName].secondPress = false;
         this.map[this.mButtonName].mCounter = 0;
         this.map[this.mButtonName].mTimer.reset();
      }
      
      private function onMultipleClickTimer(e:TimerEvent) : void
      {
         if(this.map[this.mButtonName].mCounter >= 2)
         {
            this.map[this.mButtonName].mTimer.reset();
            this.map[this.mButtonName].secondPress = true;
            this.map[this.mButtonName].mCounter = 0;
         }
         this.map[this.mButtonName].mMultipleClickTimer.reset();
         this.readBackLogic();
      }
      
      private function onTextToSpeechEvent(evt:TextToSpeechEvent) : void
      {
         if(evt.mData != null && evt.mData.hasOwnProperty("domain"))
         {
            this.mDomain = evt.mData.domain;
         }
         if(this.mButtonName != null)
         {
            if("playEnd" == Peripheral.textToSpeach.playState && Boolean(this.map[this.mButtonName].secondPress))
            {
               this.map[this.mButtonName].mTimer.reset();
               this.map[this.mButtonName].mTimer.start();
            }
            if("notPlaying" == Peripheral.textToSpeach.playState && Boolean(this.map[this.mButtonName].mVRAborted))
            {
               this.map[this.mButtonName].mVRAborted = false;
               this.readBackLogic();
            }
         }
      }
      
      private function readBackLogic() : void
      {
         var _str:String = null;
         if(Peripheral.textToSpeach.isTTSPlaying == false)
         {
            if(this.mButtonName == "rse_button" || this.mButtonName == "RearMedia")
            {
               _str = Peripheral.vehConfig.vehicleLine;
            }
            else if(this.mButtonName == "media_button")
            {
               _str = Framework.structure.currentBranch;
            }
            else
            {
               _str = this.mButtonName;
            }
            this.mCurrentReadPhrase = this.map[this.mButtonName].readBackCallBack(_str,this.map[this.mButtonName].secondPress);
            Peripheral.textToSpeach.readout(Peripheral.textToSpeach.READOUT_TYPE_ACCFR,this.mCurrentReadPhrase);
            Peripheral.rse.muteExternalModule("true");
            if(this.map[this.mButtonName].secondPress == false)
            {
               this.map[this.mButtonName].secondPress = true;
            }
            else if(Boolean(this.map[this.mButtonName].mTimer.running) || !this.map[this.mButtonName].mVRAborted)
            {
               this.map[this.mButtonName].mTimer.reset();
               this.map[this.mButtonName].mTimer.start();
               this.map[this.mButtonName].callBack(this.map[this.mButtonName].objVars);
            }
         }
         else if("ACCFR" == this.mDomain)
         {
            Peripheral.textToSpeach.abort(Peripheral.textToSpeach.READOUT_TYPE_ACCFR);
            this.map[this.mButtonName].mVRAborted = true;
         }
      }
   }
}

