package com.nfuzion.moduleLink
{
   import com.harman.moduleLinkAPI.Time;
   import com.nfuzion.moduleLinkAPI.ClockEvent;
   import com.nfuzion.moduleLinkAPI.IClock;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class Clock extends Module implements IClock
   {
      
      private static var instance:Clock;
      
      private const dBusClockDaylightSavings:String = "daylightSavings";
      
      private const dBusClockTimeZone:String = "timeZone";
      
      private const dbusIdentifier:String = "Clock";
      
      private var mDaylightSavings:Boolean;
      
      private var mDateTime:Date;
      
      private var mGpsTime:Boolean;
      
      private var mtimeZone:String;
      
      private var mTimeZoneOffset:Number;
      
      private var mDaylightOffset:Number;
      
      private var mManualOffset:Number;
      
      private var mTwelveHourMode:Boolean;
      
      private var mEnableClock:Boolean;
      
      private var client:Client;
      
      private var connection:Connection;
      
      private var mClockServiceAvailable:Boolean = false;
      
      private var mValidTime:Boolean = false;
      
      private var mTime:Time;
      
      public function Clock()
      {
         super();
         this.mTime = new Time();
         this.mDateTime = new Date();
         this.mTwelveHourMode = true;
         this.mEnableClock = true;
         this.mGpsTime = true;
         this.mManualOffset = 0;
         this.mTimeZoneOffset = 0;
         this.mDaylightOffset = 0;
         this.mtimeZone = "UTC";
         this.connection = Connection.share();
         this.client = this.connection.span;
         this.client.addEventListener(Event.CONNECT,this.connected);
         if(this.client.connected)
         {
            this.connected();
         }
         this.client.addEventListener(Event.CLOSE,this.disconnected);
         this.connection.addEventListener(ConnectionEvent.CLOCK,this.clockMessageHandler);
         this.connection.addEventListener(ConnectionEvent.CONFIGURED,this.loadConfiguration);
         if(this.connection.configured)
         {
            this.loadConfiguration();
         }
      }
      
      public static function getInstance() : Clock
      {
         if(instance == null)
         {
            instance = new Clock();
         }
         return instance;
      }
      
      override protected function subscribe(signalName:String) : void
      {
         switch(signalName)
         {
            case ClockEvent.TIME_UPDATE:
               this.sendSubscribe("time");
               break;
            case ClockEvent.TIME_ZONE:
               this.sendSubscribe("time");
         }
      }
      
      override protected function unsubscribe(signalName:String) : void
      {
         switch(signalName)
         {
            case ClockEvent.TIME_UPDATE:
               this.sendUnsubscribe("time");
               break;
            case ClockEvent.TIME_ZONE:
               this.sendUnsubscribe(this.dBusClockTimeZone);
               break;
            case ClockEvent.DAYLIGHT_SAVINGS:
               this.sendUnsubscribe(this.dBusClockDaylightSavings);
         }
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
      }
      
      override public function getAll() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier + "\", \"packet\": { \"getAllProperties\": {}}}");
      }
      
      public function getTime() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier + "\", \"packet\": { \"getTime\": {}}}");
      }
      
      public function setTime(timeToSet:Date) : void
      {
         var message:String = null;
         this.mDateTime = timeToSet;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier + "\", \"packet\": { \"setTime\": { \"year\":" + this.mTime.year.toString() + ", \"month\":" + this.mTime.month.toString() + ", \"day\":" + this.mTime.day.toString() + ", \"hour\":" + timeToSet.hours.toString() + ", \"minute\":" + timeToSet.minutes.toString() + " }}}";
         this.client.send(message);
      }
      
      public function adjustYear(year:Number) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier + "\", \"packet\": { \"adjustYear\": { \"year\":" + year.toString() + "}}}";
         this.client.send(message);
      }
      
      public function adjustMonth(month:Number) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier + "\", \"packet\": { \"adjustMonth\": { \"month\":" + month.toString() + " }}}";
         this.client.send(message);
      }
      
      public function adjustManualOffset(offset:Number) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier + "\", \"packet\": { \"adjustManualOffset\": { \"offset\":" + offset.toString() + " }}}";
         this.client.send(message);
      }
      
      public function get time() : Date
      {
         return this.mDateTime;
      }
      
      public function set _time(_newTime:Time) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier + "\", \"packet\": { \"setTime\": { \"year\":" + _newTime.year.toString() + ", \"month\":" + _newTime.month.toString() + ", \"day\":" + _newTime.day.toString() + ", \"hour\":" + _newTime.hour.toString() + ", \"minute\":" + _newTime.minute.toString() + " }}}";
         this.client.send(message);
      }
      
      public function get _time() : Time
      {
         return this.mTime;
      }
      
      public function get formattedHours() : String
      {
         var hourNumber:Number = new Number(this.time.hours);
         if(this.mTwelveHourMode)
         {
            if(0 == hourNumber)
            {
               hourNumber = 12;
            }
            else if(hourNumber > 12)
            {
               hourNumber -= 12;
            }
         }
         if(!this.mTwelveHourMode && hourNumber == 0)
         {
            return "00";
         }
         return hourNumber.toString();
      }
      
      public function get formattedMinutes() : String
      {
         var minuteNumber:Number = new Number(this.time.minutes);
         if(minuteNumber < 10)
         {
            return "0" + minuteNumber.toString();
         }
         return minuteNumber.toString();
      }
      
      public function get formattedTime() : String
      {
         return this.mValidTime ? this.formattedHours + ":" + this.minuteString(this.time.minutes.toString()) : "";
      }
      
      public function setDaylightSavings(dlsOn:Boolean) : void
      {
         var msg:String = null;
         this.mDaylightSavings = dlsOn;
         if(dlsOn)
         {
            msg = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier + "\", \"packet\": { \"setProperties\": { \"daylightSavings\":true}}}";
         }
         else
         {
            msg = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier + "\", \"packet\": { \"setProperties\": { \"daylightSavings\":false}}}";
         }
         this.client.send(msg);
      }
      
      public function get timeZone() : String
      {
         return this.mtimeZone;
      }
      
      public function get timeZoneOffset() : Number
      {
         return this.mTimeZoneOffset;
      }
      
      public function get daylightOffset() : Number
      {
         return this.mDaylightOffset;
      }
      
      public function get manualOffset() : Number
      {
         return this.mManualOffset;
      }
      
      public function setSyncWithGPSTime(gpsOn:Boolean) : void
      {
         var msg:String = null;
         if(gpsOn)
         {
            msg = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier + "\", \"packet\": { \"setProperties\": { \"gpsTime\":true}}}";
         }
         else
         {
            msg = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier + "\", \"packet\": { \"setProperties\": { \"gpsTime\":false}}}";
         }
         this.client.send(msg);
      }
      
      public function requestSyncWithGPSTime() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier + "\", \"packet\": { \"getProperties\": { \"props\": [\"gpsTime\"]}}}");
      }
      
      public function get GPSTime() : Boolean
      {
         return this.mGpsTime;
      }
      
      public function setTwelveHourTimeFormat(twelveOn:Boolean) : void
      {
         var msg:String = null;
         this.mTwelveHourMode = twelveOn;
         if(twelveOn)
         {
            msg = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier + "\", \"packet\": { \"setProperties\": { \"timeFormat24\":false}}}";
         }
         else
         {
            msg = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier + "\", \"packet\": { \"setProperties\": { \"timeFormat24\":true}}}";
         }
         this.client.send(msg);
      }
      
      public function requestTwelveHourTimeFormat() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier + "\", \"packet\": { \"getProperties\": { \"props\": [\"timeFormat24\"]}}}");
      }
      
      public function requestOffsetValues() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier + "\", \"packet\": { \"getOffsetValues\": {}}}");
      }
      
      public function get twelveHourTimeFormat() : Boolean
      {
         return this.mTwelveHourMode;
      }
      
      public function setTimeInStatusBarEnabled(showOn:Boolean) : void
      {
         var msg:String = null;
         this.mEnableClock = showOn;
         if(showOn)
         {
            msg = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier + "\", \"packet\": { \"setProperties\":{\"enableClock\":true}}}";
         }
         else
         {
            msg = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier + "\", \"packet\": { \"setProperties\":{\"enableClock\":false}}}";
         }
         this.client.send(msg);
      }
      
      public function requestTimeInStatusBarEnabled() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier + "\", \"packet\": { \"getProperties\": { \"props\": [\"enableClock\"]}}}");
      }
      
      public function get EnableClock() : Boolean
      {
         return this.mEnableClock;
      }
      
      private function minuteString(min:String) : String
      {
         if(1 == min.length)
         {
            min = "0" + min;
         }
         return min;
      }
      
      private function isClockType(jsonObject:Object) : Boolean
      {
         return jsonObject.Clock != null;
      }
      
      private function connected(e:Event = null) : void
      {
         if(this.connection.configured)
         {
            this.sendAvailableRequest();
            this.sendMultiSubscribe(["time","timeFormat24","gpsTime","enableClock","daylightSavings","timeOffset","timeZone","utcOffset","dsOffset","tzOffset"]);
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
      }
      
      private function disconnected(e:Event) : void
      {
         this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
      }
      
      private function loadConfiguration(e:Event = null) : void
      {
         if(this.client.connected)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
      }
      
      private function sendCommand(commandName:String, valueName:String, value:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": \"" + value + "\"}}}";
         this.client.send(message);
      }
      
      private function sendSubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + this.dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendMultiSubscribe(signalsArray:Array) : void
      {
         var message:String = null;
         var i:uint = 0;
         for(message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + this.dbusIdentifier + "\", \"Signals\": ["; i < signalsArray.length; )
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
      
      private function sendUnsubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + this.dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      public function clockMessageHandler(e:ConnectionEvent) : void
      {
         var tmp:Object = null;
         var year:int = 0;
         var month:int = 0;
         var day:int = 0;
         var hour:int = 0;
         var minute:int = 0;
         var second:int = 0;
         var clock:Object = e.data;
         if(clock.hasOwnProperty("dBusServiceAvailable"))
         {
            if(clock.dBusServiceAvailable == "true" && this.mClockServiceAvailable == false)
            {
               this.mClockServiceAvailable = true;
               this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier + "\", \"packet\": { \"getAllProperties\": {}}}");
               this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier + "\", \"packet\": { \"getTime\": {}}}");
            }
            else if(clock.dBusServiceAvailable == "false")
            {
               this.mClockServiceAvailable = false;
            }
         }
         if(clock.hasOwnProperty("time"))
         {
            tmp = clock.time;
         }
         if(clock.hasOwnProperty("getTime"))
         {
            tmp = clock.getTime;
         }
         if(tmp != null)
         {
            if(!(tmp.status && tmp.status.indexOf("error") >= 0))
            {
               try
               {
                  year = int(tmp.year);
                  month = int(tmp.month);
                  day = int(tmp.day);
                  hour = int(tmp.hour);
                  minute = int(tmp.minute);
                  second = int(tmp.sec);
                  this.mTime = new Time(year,month,day,hour,minute);
                  this.mDateTime.setHours(hour,minute,second);
                  this.mValidTime = true;
                  this.dispatchEvent(new ClockEvent(ClockEvent.TIME_UPDATE));
               }
               catch(e:Error)
               {
               }
            }
         }
         if(clock.hasOwnProperty("timeZone"))
         {
            this.mtimeZone = clock.timeZone.timeZone;
            this.dispatchEvent(new ClockEvent(ClockEvent.TIME_ZONE));
         }
         if(clock.hasOwnProperty(this.dBusClockDaylightSavings))
         {
            this.mDaylightSavings = clock.daylightSavings.daylightSavings;
            this.dispatchEvent(new ClockEvent(ClockEvent.DAYLIGHT_SAVINGS));
         }
         if(clock.hasOwnProperty("timeFormat24"))
         {
            this.mTwelveHourMode = !clock.timeFormat24.timeFormat24;
            this.dispatchEvent(new ClockEvent(ClockEvent.TWELVE_HOUR_MODE));
         }
         if(clock.hasOwnProperty("gpsTime"))
         {
            this.mGpsTime = clock.gpsTime.gpsTime;
            this.dispatchEvent(new ClockEvent(ClockEvent.GPS_TIME));
         }
         if(clock.hasOwnProperty("dsOffset"))
         {
            this.mDaylightOffset = clock.dsOffset.dsOffset;
            this.dispatchEvent(new ClockEvent(ClockEvent.DAYLIGHT_OFFSET));
         }
         if(clock.hasOwnProperty("tzOffset"))
         {
            this.mTimeZoneOffset = clock.tzOffset.tzOffset;
            this.dispatchEvent(new ClockEvent(ClockEvent.TIMEZONE_OFFSET));
         }
         if(clock.hasOwnProperty("utcOffset"))
         {
            this.mManualOffset = clock.utcOffset.utcOffset;
            this.dispatchEvent(new ClockEvent(ClockEvent.MANUAL_OFFSET));
         }
         if(clock.hasOwnProperty("getProperties"))
         {
            if(clock.getProperties.hasOwnProperty("gpsTime"))
            {
               this.mGpsTime = clock.getProperties.gpsTime;
               this.dispatchEvent(new ClockEvent(ClockEvent.GPS_TIME));
            }
            if(clock.getProperties.hasOwnProperty("timeFormat24"))
            {
               this.mTwelveHourMode = !clock.getProperties.timeFormat24;
               this.dispatchEvent(new ClockEvent(ClockEvent.TWELVE_HOUR_MODE));
            }
            if(clock.getProperties.hasOwnProperty("enableClock"))
            {
               this.mEnableClock = clock.getProperties.enableClock;
               this.dispatchEvent(new ClockEvent(ClockEvent.ENABLE_CLOCK));
            }
            if(clock.getProperties.hasOwnProperty("daylightSavings"))
            {
               this.mDaylightSavings = clock.getProperties.daylightSavings;
               this.dispatchEvent(new ClockEvent(ClockEvent.DAYLIGHT_SAVINGS));
            }
         }
         if(clock.hasOwnProperty("enableClock"))
         {
            this.mEnableClock = clock.enableClock.enableClock;
            this.dispatchEvent(new ClockEvent(ClockEvent.ENABLE_CLOCK));
         }
         if(clock.hasOwnProperty("getAllProperties"))
         {
            if(clock.getAllProperties.hasOwnProperty("gpsTime"))
            {
               this.mGpsTime = clock.getAllProperties.gpsTime;
               this.dispatchEvent(new ClockEvent(ClockEvent.GPS_TIME));
            }
            if(clock.getAllProperties.hasOwnProperty("timeFormat24"))
            {
               this.mTwelveHourMode = !clock.getAllProperties.timeFormat24;
               this.dispatchEvent(new ClockEvent(ClockEvent.TWELVE_HOUR_MODE));
            }
            if(clock.getAllProperties.hasOwnProperty("enableClock"))
            {
               this.mEnableClock = clock.getAllProperties.enableClock;
               this.dispatchEvent(new ClockEvent(ClockEvent.ENABLE_CLOCK));
            }
            if(clock.getAllProperties.hasOwnProperty("daylightSavings"))
            {
               this.mDaylightSavings = clock.getAllProperties.daylightSavings;
               this.dispatchEvent(new ClockEvent(ClockEvent.DAYLIGHT_SAVINGS));
            }
         }
         if(clock.hasOwnProperty("getOffsetValues"))
         {
            if(clock.getOffsetValues.hasOwnProperty("timeZoneOffset"))
            {
               this.mTimeZoneOffset = clock.getOffsetValues.timeZoneOffset;
               this.dispatchEvent(new ClockEvent(ClockEvent.TIMEZONE_OFFSET));
            }
            if(clock.getOffsetValues.hasOwnProperty("daylightOffset"))
            {
               this.mDaylightOffset = clock.getOffsetValues.daylightOffset;
               this.dispatchEvent(new ClockEvent(ClockEvent.DAYLIGHT_OFFSET));
            }
            if(clock.getOffsetValues.hasOwnProperty("manualOffset"))
            {
               this.mManualOffset = clock.getOffsetValues.manualOffset;
               this.dispatchEvent(new ClockEvent(ClockEvent.MANUAL_OFFSET));
            }
            if(clock.getOffsetValues.hasOwnProperty("timeZone"))
            {
               this.mtimeZone = clock.getOffsetValues.timeZone;
               this.dispatchEvent(new ClockEvent(ClockEvent.TIME_ZONE));
            }
         }
      }
      
      private function sendAvailableRequest() : void
      {
         var message:String = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"" + this.dbusIdentifier + "\"}";
         this.client.send(message);
      }
   }
}

