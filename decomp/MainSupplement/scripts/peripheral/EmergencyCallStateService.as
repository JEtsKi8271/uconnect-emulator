package peripheral
{
   import ancillary.DynamicPopupNames;
   import com.harman.moduleLinkAPI.CVPDemoEvent;
   import com.harman.moduleLinkAPI.ECallSvcEvent;
   import com.nfuzion.framework.global.Framework;
   import events.EmergencyCallStateEvent;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   
   public class EmergencyCallStateService extends EventDispatcher
   {
      
      private static var instance:EmergencyCallStateService;
      
      private var mEcallState:String = "CALL_STATE_IDLE";
      
      private var mEcallPhoneNum:String = "";
      
      private var mEcallElapsedTime:String = "";
      
      private var mBTCallActive:Boolean = false;
      
      private var mEmergencyHappened:Boolean = false;
      
      private var mEcallType:String = "";
      
      private var mOneSecondTimer:Timer = new Timer(1000);
      
      private var mTimeSec:int = 0;
      
      private var mSystemErrorHMIDismissed:Boolean = false;
      
      private var mRetryWithCancel:Boolean = false;
      
      public function EmergencyCallStateService()
      {
         super();
      }
      
      public static function getInstance() : EmergencyCallStateService
      {
         if(instance == null)
         {
            instance = new EmergencyCallStateService();
         }
         return instance;
      }
      
      public function init() : void
      {
         Peripheral.ecallsvc.addEventListener(ECallSvcEvent.ECALL_EVENT,this.onECallHappened,false,0,true);
         Peripheral.cvpdemo.addEventListener(CVPDemoEvent.EMB_PHONE_CALLSTATE,this.onEmbCallState,false,0,true);
         this.mOneSecondTimer.addEventListener(TimerEvent.TIMER,this.onOneSecondTimeOff,false,0,true);
      }
      
      public function getEmergencyCallState() : String
      {
         return this.mEcallState;
      }
      
      public function getEmergencyPhoneNumber() : String
      {
         return this.mEcallPhoneNum;
      }
      
      public function getEmergencyElapsedTime() : String
      {
         return this.mEcallElapsedTime;
      }
      
      public function wasBTPhoneCallActive() : Boolean
      {
         return this.mBTCallActive;
      }
      
      public function getInEmergency() : Boolean
      {
         return this.mEmergencyHappened;
      }
      
      public function getECallType() : String
      {
         return this.mEcallType;
      }
      
      public function dismissHMISystemError() : void
      {
         this.mSystemErrorHMIDismissed = true;
         this.dispatchEvent(new EmergencyCallStateEvent(EmergencyCallStateEvent.EMERGENCY_CALLSTATE));
      }
      
      public function getHMISystemErrorDismiss() : Boolean
      {
         return this.mSystemErrorHMIDismissed;
      }
      
      private function onECallHappened(e:ECallSvcEvent) : void
      {
         var preECallType:String = null;
         Framework.Trace("ecall happened = " + e.mData.ecall + ", ecall type = " + e.mData.type);
         if(e.mData.type == "ecall_button_repeat")
         {
            if(this.mRetryWithCancel == true)
            {
               Peripheral.ecallsvc.exitECall();
            }
            else
            {
               this.dispatchEvent(new EmergencyCallStateEvent(EmergencyCallStateEvent.EMERGENCY_SWITCHTO_ECALLSCREEN));
            }
            return;
         }
         if(e.mData.type == "systemError")
         {
            this.mSystemErrorHMIDismissed = false;
            this.mEcallType = e.mData.type;
         }
         else if(e.mData.ecall == true)
         {
            Framework.Trace("BlockActiveAppScreenSwitch = " + Peripheral.appStateManager.shouldBlockActiveAppScreenSwitch());
            if(this.mEmergencyHappened == false && (Peripheral.appStateManager.shouldBlockActiveAppScreenSwitch() == true || Framework.popupManager.check(DynamicPopupNames.INFO_APPS_LOADING) == true))
            {
               Framework.Trace("ecall happened while starting app. block switching to app screen. close all popups");
               Peripheral.appStateManager.setBlockActiveAppScreenSwitch(true);
            }
            preECallType = this.mEcallType;
            this.mEmergencyHappened = e.mData.ecall;
            this.mEcallType = e.mData.type;
            this.mBTCallActive = e.mData.BTCallActive;
            this.mEcallPhoneNum = e.mData.phoneNumber;
            if(e.mData.type == "failed")
            {
               this.mEcallState = EmergencyCallStateEvent.EMERGENCY_CALLSTATE_RETRY;
               if(preECallType != "failed" && this.mOneSecondTimer.running == false)
               {
                  this.mTimeSec = 300;
                  this.mOneSecondTimer.start();
                  Peripheral.ecallsvc.setECallRetryState(0);
                  this.mRetryWithCancel = false;
               }
               this.mEcallElapsedTime = this.getTimeStringFromSecond(this.mTimeSec);
               this.dispatchEvent(new EmergencyCallStateEvent(EmergencyCallStateEvent.EMERGENCY_CALLSTATE));
            }
            else if(e.mData.type == "emergency_callback")
            {
               if(this.mEcallState == EmergencyCallStateEvent.EMERGENCY_CALLSTATE_IDLE || this.mEcallState == EmergencyCallStateEvent.EMERGENCY_CALLSTATE_END)
               {
                  this.mEcallState = EmergencyCallStateEvent.EMERGENCY_CALLSTATE_ECALLBACK;
                  this.mEcallElapsedTime = "";
               }
            }
            else if(e.mData.type == "acn" || e.mData.type == "redial_during_end")
            {
               if(this.mEcallState == EmergencyCallStateEvent.EMERGENCY_CALLSTATE_IDLE || this.mEcallState == EmergencyCallStateEvent.EMERGENCY_CALLSTATE_END)
               {
                  this.mEcallState = EmergencyCallStateEvent.EMERGENCY_CALLSTATE_DIALING;
                  this.mEcallElapsedTime = "";
               }
            }
            else if(this.mEcallState == EmergencyCallStateEvent.EMERGENCY_CALLSTATE_IDLE || this.mEcallState == EmergencyCallStateEvent.EMERGENCY_CALLSTATE_END && this.mOneSecondTimer.running == true)
            {
               this.mEcallState = EmergencyCallStateEvent.EMERGENCY_CALLSTATE_STARTING;
               this.mEcallElapsedTime = "";
               this.mOneSecondTimer.reset();
            }
         }
         else
         {
            this.mRetryWithCancel = false;
            if(this.mEmergencyHappened != e.mData.ecall)
            {
               this.mOneSecondTimer.reset();
               this.mTimeSec = 10;
               this.mEcallState = EmergencyCallStateEvent.EMERGENCY_CALLSTATE_END;
               this.mOneSecondTimer.start();
            }
         }
         this.dispatchEvent(new EmergencyCallStateEvent(EmergencyCallStateEvent.EMERGENCY_CALLSTATE));
      }
      
      private function onEmbCallState(e:CVPDemoEvent) : void
      {
         var i:int = 0;
         if(this.mEcallState == EmergencyCallStateEvent.EMERGENCY_CALLSTATE_ACTIVE)
         {
            return;
         }
         if(this.mEmergencyHappened && getQualifiedClassName(e.mData.callStateInfo) == "Array" && e.mData.callStateInfo.length != null && Boolean(e.mData.callStateInfo.length))
         {
            i = 0;
            while(i < e.mData.callStateInfo.length)
            {
               if(e.mData.callStateInfo[i].callType != 0)
               {
                  if(this.mEcallState == EmergencyCallStateEvent.EMERGENCY_CALLSTATE_IDLE || this.mEcallState == EmergencyCallStateEvent.EMERGENCY_CALLSTATE_END)
                  {
                     this.mEcallElapsedTime = "";
                  }
                  switch(e.mData.callStateInfo[i].callState)
                  {
                     case EmergencyCallStateEvent.EMERGENCY_CALLSTATE_ACTIVE:
                        this.mTimeSec = 0;
                        this.mEcallElapsedTime = this.getTimeStringFromSecond(this.mTimeSec);
                        this.mOneSecondTimer.start();
                     case EmergencyCallStateEvent.EMERGENCY_CALLSTATE_IDLE:
                     case EmergencyCallStateEvent.EMERGENCY_CALLSTATE_DIALING:
                     case EmergencyCallStateEvent.EMERGENCY_CALLSTATE_RING:
                        this.mEcallState = e.mData.callStateInfo[i].callState;
                        this.dispatchEvent(new EmergencyCallStateEvent(EmergencyCallStateEvent.EMERGENCY_CALLSTATE));
                  }
                  break;
               }
               i++;
            }
         }
      }
      
      private function onOneSecondTimeOff(e:TimerEvent) : void
      {
         if(this.mEcallState == EmergencyCallStateEvent.EMERGENCY_CALLSTATE_ACTIVE)
         {
            ++this.mTimeSec;
            this.mEcallElapsedTime = this.getTimeStringFromSecond(this.mTimeSec);
         }
         else if(this.mEcallState == EmergencyCallStateEvent.EMERGENCY_CALLSTATE_RETRY)
         {
            --this.mTimeSec;
            if(this.mTimeSec > 0)
            {
               this.mEcallElapsedTime = this.getTimeStringFromSecond(this.mTimeSec);
            }
            else
            {
               Framework.Trace("retry 5 minutes countdown is up. Transfer to Retry with Cancel");
               this.mEcallElapsedTime = "";
               this.mOneSecondTimer.reset();
               Peripheral.ecallsvc.setECallRetryState(1);
               this.mRetryWithCancel = true;
            }
         }
         else if(this.mEcallState == EmergencyCallStateEvent.EMERGENCY_CALLSTATE_END)
         {
            --this.mTimeSec;
            if(this.mTimeSec > 0)
            {
               this.mEcallElapsedTime = this.getTimeStringFromSecond(this.mTimeSec);
            }
            else
            {
               this.mEmergencyHappened = false;
               Peripheral.ecallsvc.exitECall();
               this.mEcallElapsedTime = "";
               this.mEcallState = EmergencyCallStateEvent.EMERGENCY_CALLSTATE_IDLE;
               this.mOneSecondTimer.reset();
               Peripheral.appStateManager.setBlockActiveAppScreenSwitch(false);
            }
         }
         this.dispatchEvent(new EmergencyCallStateEvent(EmergencyCallStateEvent.EMERGENCY_CALLSTATE));
      }
      
      private function getTimeStringFromSecond(seconds:int) : String
      {
         var s:Number = seconds % 60;
         var m:Number = Math.floor(seconds % 3600 / 60);
         var h:Number = Math.floor(seconds / (60 * 60));
         var hourStr:String = h == 0 ? "" : this.doubleDigitFormat(h) + ":";
         var minuteStr:String = this.doubleDigitFormat(m) + ":";
         var secondsStr:String = this.doubleDigitFormat(s);
         return hourStr + minuteStr + secondsStr;
      }
      
      private function doubleDigitFormat(num:uint) : String
      {
         if(num < 10)
         {
            return "0" + num;
         }
         return String(num);
      }
   }
}

