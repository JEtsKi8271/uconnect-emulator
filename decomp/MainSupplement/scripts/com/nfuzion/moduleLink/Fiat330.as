package com.nfuzion.moduleLink
{
   import com.harman.types.Enum;
   import com.nfuzion.moduleLinkAPI.Fiat330Event;
   import com.nfuzion.moduleLinkAPI.I330Serv;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.moduleLinkAPI.RainSensorLevel;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class Fiat330 extends Module implements I330Serv
   {
      
      public static var instance:Fiat330;
      
      private const dbusIdentifier:String = "S330";
      
      private const dbusTempUnit:String = "TemperatureUnit";
      
      private const dbusDistanceUnit:String = "DistanceUnit";
      
      private const dbusConsumptionUnit:String = "ConsumptionUnit";
      
      private const dbusAFSEnable:String = "AFSEnable";
      
      private const dbusSpeedLockEnable:String = "SpeedLockDoorEnable";
      
      private const dbusRainSensorLevel:String = "RainSensorLevel";
      
      private const dbusTripBEnable:String = "Trip_B_Enable";
      
      private const dbusAutoSwitch:String = "AutoSwitch";
      
      private const dbusTravelingTimeAPlus_Hour:String = "TravelingTimeAPlus_Hour";
      
      private const dbusTravellingTimeAPlus_Minute:String = "TravellingTimeAPlus_Minute";
      
      private const dbusAverageSpeedAPlus:String = "AverageSpeedAPlus";
      
      private const dbusAverageFuelConsumptionAPlus:String = "AverageFuelConsumptionAPlus";
      
      private const dbusPartialOdometerAPlus:String = "PartialOdometerAPlus";
      
      private const dbusTravelingTimeBPlus_Hour:String = "TravelingTimeBPlus_Hour";
      
      private const dbusTravellingTimeBPlus_Minute:String = "TravellingTimeBPlus_Minute";
      
      private const dbusAverageSpeedBPlus:String = "AverageSpeedBPlus";
      
      private const dbusAverageFuelConsumptionBPlus:String = "AverageFuelConsumptionBPlus";
      
      private const dbusPartialOdometerBPlus:String = "PartialOdometerBPlus";
      
      private const dbusAutonomyDistance:String = "AutonomyDistance";
      
      private const dbusIstantaneusFuelConsumption1:String = "IstantaneusFuelConsumption1";
      
      private const dbusIstantaneusFuelConsumption2:String = "IstantaneusFuelConsumption2";
      
      private const dbusIstantaneusFuelConsumption3:String = "IstantaneusFuelConsumption3";
      
      private const TIME_HRS_SNA:int = 1023;
      
      private const TIME_MIN_SNA:int = 63;
      
      private const TIME_SEC_SNA:int = 63;
      
      private const AVE_SPEED_SNA:int = 255;
      
      private const AVE_FUEL_CONSUMP_SNA:int = 1023;
      
      private const PART_ODO_SNA:int = 1048575;
      
      private const AUTO_DIST_SNA:int = 2047;
      
      private const INST_FUEL_CONSUMP_SNA:int = 15;
      
      private var mTempUnit:String = "1";
      
      private var mDistanceUnit:String = "mi";
      
      private var mConsumptionUnit:String = "L/100km";
      
      private var mAFSEnable:Boolean = false;
      
      private var mSpeedLockEnable:String = "1";
      
      private var mRainSensorLevel:RainSensorLevel = RainSensorLevel.Level_1;
      
      private var mTripBEnable:String = "0";
      
      private var mAutoOn:String = "recall_last";
      
      private var mTravellingTimeA:String = "";
      
      private var mTravellingTimeHoursA:int = 0;
      
      private var mTravellingTimeMinutesA:int = 0;
      
      private var mAverageSpeedA:String = "";
      
      private var mAverageConsumptionA:Number = 0;
      
      private var mDistanceA:Number = 0;
      
      private var mTravellingTimeB:String = "";
      
      private var mTravellingTimeHoursB:int = 0;
      
      private var mTravellingTimeMinutesB:int = 0;
      
      private var mAverageSpeedB:String = "";
      
      private var mAverageConsumptionB:Number = 0;
      
      private var mDistanceB:Number = 0;
      
      private var mTotalDistance:String = "";
      
      private var mTotalConsumption:Number = 0;
      
      private var mConsumption1:int = 0;
      
      private var mConsumption2:int = 0;
      
      private var mConsumption3:Number = 0;
      
      private var client:Client;
      
      private var connection:Connection;
      
      public function Fiat330()
      {
         super();
         this.connection = Connection.share();
         this.client = this.connection.span;
         this.client.addEventListener(Event.CONNECT,this.connected);
         if(this.client.connected)
         {
            this.connected();
         }
         this.client.addEventListener(Event.CLOSE,this.disconnected);
         this.connection.addEventListener(ConnectionEvent.FIAT330,this.Fiat330MessageHandler);
         this.connection.addEventListener(ConnectionEvent.CONFIGURED,this.loadConfiguration);
         if(this.connection.configured)
         {
            this.loadConfiguration();
         }
      }
      
      public static function getInstance() : Fiat330
      {
         if(instance == null)
         {
            instance = new Fiat330();
         }
         return instance;
      }
      
      private function connected(e:Event = null) : void
      {
         this.sendAvailableRequest();
         if(this.connection.configured)
         {
            this.sendMultiSubscribe([this.dbusTempUnit,this.dbusDistanceUnit,this.dbusConsumptionUnit,this.dbusAFSEnable,this.dbusSpeedLockEnable,this.dbusRainSensorLevel,this.dbusTripBEnable,this.dbusAutoSwitch,this.dbusAverageFuelConsumptionAPlus,this.dbusAverageFuelConsumptionBPlus,this.dbusAverageSpeedAPlus,this.dbusAverageSpeedBPlus,this.dbusPartialOdometerAPlus,this.dbusPartialOdometerBPlus,this.dbusTravelingTimeAPlus_Hour,this.dbusTravellingTimeAPlus_Minute,this.dbusTravelingTimeBPlus_Hour,this.dbusTravellingTimeBPlus_Minute,this.dbusAutonomyDistance,this.dbusIstantaneusFuelConsumption1,this.dbusIstantaneusFuelConsumption2,this.dbusIstantaneusFuelConsumption3]);
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
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
      
      private function sendUnSubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + this.dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
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
      
      private function getValue(valueName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"" + valueName + "\"]}}}";
         this.client.send(message);
      }
      
      private function sendStringValue(commandName:String, valueName:String, value:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": \"" + value + "\"}}}";
         this.client.send(message);
      }
      
      private function sendNumericValue(commandName:String, valueName:String, value:int) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": \"" + value + "\"}}}";
         this.client.send(message);
      }
      
      private function getAllProperties() : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier + "\", \"packet\": { \"getAllProperties\": {}}}";
         this.client.send(message);
      }
      
      override public function getAll() : void
      {
         this.getAllProperties();
      }
      
      public function get_tempUnit() : void
      {
         this.getValue("TemperatureUnit");
      }
      
      public function get tempUnit() : String
      {
         return this.mTempUnit;
      }
      
      public function set_tempUnit(unit:String) : void
      {
         this.sendStringValue("setProperties","TemperatureUnit",unit);
      }
      
      public function get_distanceUnit() : void
      {
         this.getValue("DistanceUnit");
      }
      
      public function get distanceUnit() : String
      {
         return this.mDistanceUnit;
      }
      
      public function set_distanceUnit(unit:String) : void
      {
         this.sendStringValue("setProperties","DistanceUnit",unit);
      }
      
      public function get_consumptionUnit() : void
      {
         this.getValue("ConsumptionUnit");
      }
      
      public function get consumptionUnit() : String
      {
         return this.mConsumptionUnit;
      }
      
      public function set_consumptionUnit(unit:String) : void
      {
         this.sendStringValue("setProperties","ConsumptionUnit",unit);
      }
      
      public function get_afsEnable() : void
      {
         this.getValue(this.dbusAFSEnable);
      }
      
      public function get afsEnable() : Boolean
      {
         return this.mAFSEnable;
      }
      
      public function set_afsEnable(enable:Boolean) : void
      {
         this.sendStringValue("setProperties",this.dbusAFSEnable,enable ? "1" : "0");
      }
      
      public function get_speedlockEnable() : void
      {
         this.getValue("SpeedLockDoorEnable");
      }
      
      public function get speedlockEnable() : String
      {
         return this.mSpeedLockEnable;
      }
      
      public function set_speedlockEnable(unit:String) : void
      {
         this.sendStringValue("setProperties","SpeedLockDoorEnable",unit);
      }
      
      public function get_rainsensorLevel() : void
      {
         this.getValue(this.dbusRainSensorLevel);
      }
      
      public function get rainsensorLevel() : RainSensorLevel
      {
         return this.mRainSensorLevel;
      }
      
      public function set_rainsensorLevel(level:RainSensorLevel) : void
      {
         this.sendStringValue("setProperties",this.dbusRainSensorLevel,level.toString());
      }
      
      public function get tripbEnable() : String
      {
         return this.mTripBEnable;
      }
      
      public function set_tripbEnable(unit:String) : void
      {
         this.sendStringValue("setProperties","Trip_B_Enable",unit.toString());
      }
      
      public function get_autoSwitch() : void
      {
         this.getValue(this.dbusAutoSwitch);
      }
      
      public function get autoSwitch() : String
      {
         return this.mAutoOn;
      }
      
      public function set_autoSwitch(unit:String) : void
      {
         this.sendStringValue("setProperties",this.dbusAutoSwitch,unit);
      }
      
      public function get_totalDistance() : void
      {
         this.getValue(this.dbusAutonomyDistance);
      }
      
      public function get totalDistance() : String
      {
         if(this.mTotalDistance == this.AUTO_DIST_SNA.toString())
         {
            return "--";
         }
         return this.mTotalDistance;
      }
      
      public function get_totalConsumption() : void
      {
         this.getValue(this.dbusIstantaneusFuelConsumption1);
         this.getValue(this.dbusIstantaneusFuelConsumption2);
         this.getValue(this.dbusIstantaneusFuelConsumption3);
      }
      
      public function get totalConsumption() : String
      {
         if(this.mConsumption1 == this.INST_FUEL_CONSUMP_SNA && this.mConsumption2 == this.INST_FUEL_CONSUMP_SNA && this.mConsumption3 == this.INST_FUEL_CONSUMP_SNA)
         {
            return "--";
         }
         this.mTotalConsumption = this.mConsumption1 + this.mConsumption2 + this.mConsumption3;
         return this.mTotalConsumption.toString();
      }
      
      public function get_travellingTimeA() : void
      {
         this.getValue(this.dbusTravelingTimeAPlus_Hour);
         this.getValue(this.dbusTravellingTimeAPlus_Minute);
      }
      
      public function get travellingTimeA() : String
      {
         var _hours:String = null;
         var _mins:String = null;
         if(this.mTravellingTimeHoursA == this.TIME_HRS_SNA)
         {
            return "--:--";
         }
         _hours = this.mTravellingTimeHoursA.toString();
         _mins = this.mTravellingTimeMinutesA.toString();
         if(this.mTravellingTimeHoursA < 10)
         {
            _hours = "00" + _hours;
         }
         else if(this.mTravellingTimeHoursA < 100)
         {
            _hours = "0" + _hours;
         }
         if(this.mTravellingTimeMinutesA < 10)
         {
            _mins = "0" + _mins;
         }
         return _hours + ":" + _mins;
      }
      
      public function get_averageConsumptionA() : void
      {
         this.getValue(this.dbusAverageFuelConsumptionAPlus);
      }
      
      public function get averageConsumptionA() : String
      {
         if(this.mAverageConsumptionA == this.AVE_FUEL_CONSUMP_SNA)
         {
            return "--";
         }
         return this.mAverageConsumptionA.toString();
      }
      
      public function get_averageSpeedA() : void
      {
         this.getValue(this.dbusAverageSpeedAPlus);
      }
      
      public function get averageSpeedA() : String
      {
         if(this.mAverageSpeedA == this.AVE_SPEED_SNA.toString())
         {
            return "--";
         }
         return this.mAverageSpeedA;
      }
      
      public function get_distanceA() : void
      {
         this.getValue(this.dbusPartialOdometerAPlus);
      }
      
      public function get distanceA() : String
      {
         if(this.mDistanceA == this.PART_ODO_SNA)
         {
            return "--";
         }
         return this.mDistanceA.toString();
      }
      
      public function get_travellingTimeB() : void
      {
         this.getValue(this.dbusTravelingTimeBPlus_Hour);
         this.getValue(this.dbusTravellingTimeBPlus_Minute);
      }
      
      public function get travellingTimeB() : String
      {
         var _hours:String = null;
         var _mins:String = null;
         if(this.mTravellingTimeHoursB == this.TIME_HRS_SNA)
         {
            return "--:--";
         }
         _hours = this.mTravellingTimeHoursB.toString();
         _mins = this.mTravellingTimeMinutesB.toString();
         if(this.mTravellingTimeHoursB < 10)
         {
            _hours = "00" + _hours;
         }
         else if(this.mTravellingTimeHoursB < 100)
         {
            _hours = "0" + _hours;
         }
         if(this.mTravellingTimeMinutesB < 10)
         {
            _mins = "0" + _mins;
         }
         return _hours + ":" + _mins;
      }
      
      public function get_averageConsumptionB() : void
      {
         this.getValue(this.dbusAverageFuelConsumptionBPlus);
      }
      
      public function get averageConsumptionB() : String
      {
         if(this.mAverageConsumptionB == this.AVE_FUEL_CONSUMP_SNA)
         {
            return "--";
         }
         return this.mAverageConsumptionB.toString();
      }
      
      public function get_averageSpeedB() : void
      {
         this.getValue(this.dbusAverageSpeedBPlus);
      }
      
      public function get averageSpeedB() : String
      {
         if(this.mAverageSpeedB == this.AVE_SPEED_SNA.toString())
         {
            return "--";
         }
         return this.mAverageSpeedB;
      }
      
      public function get_distanceB() : void
      {
         this.getValue(this.dbusPartialOdometerBPlus);
      }
      
      public function get distanceB() : String
      {
         if(this.mDistanceB == this.PART_ODO_SNA)
         {
            return "--";
         }
         return this.mDistanceB.toString();
      }
      
      public function Fiat330MessageHandler(e:ConnectionEvent) : void
      {
         var rsLevel:RainSensorLevel = null;
         var resp:Object = e.data;
         if(resp.hasOwnProperty("getAllProperties"))
         {
            resp = resp.getAllProperties;
         }
         if(resp.hasOwnProperty("dBusServiceAvailable"))
         {
            if(resp.dBusServiceAvailable == "true")
            {
               this.getAll();
            }
         }
         if(resp.hasOwnProperty(this.dbusAutoSwitch))
         {
            this.mAutoOn = resp[this.dbusAutoSwitch];
            this.dispatchEvent(new Fiat330Event(Fiat330Event.AUTOONRADIO));
         }
         if(resp.hasOwnProperty(this.dbusTempUnit))
         {
            this.mTempUnit = resp.TemperatureUnit.toString();
            this.dispatchEvent(new Fiat330Event(Fiat330Event.TEMPUNIT));
         }
         if(resp.hasOwnProperty(this.dbusDistanceUnit))
         {
            this.mDistanceUnit = resp.DistanceUnit.toString();
            this.dispatchEvent(new Fiat330Event(Fiat330Event.DISTANCEUNIT));
         }
         if(resp.hasOwnProperty(this.dbusConsumptionUnit))
         {
            this.mConsumptionUnit = resp.ConsumptionUnit.toString();
            this.dispatchEvent(new Fiat330Event(Fiat330Event.CONSUMPTIONUNIT));
         }
         if(resp.hasOwnProperty(this.dbusAFSEnable))
         {
            this.mAFSEnable = resp[this.dbusAFSEnable].toString() == "1" ? true : false;
            this.dispatchEvent(new Fiat330Event(Fiat330Event.AFSENABLE));
         }
         if(resp.hasOwnProperty(this.dbusSpeedLockEnable))
         {
            this.mSpeedLockEnable = resp.SpeedLockDoorEnable.toString();
            this.dispatchEvent(new Fiat330Event(Fiat330Event.SPEEDLOCK));
         }
         if(resp.hasOwnProperty(this.dbusRainSensorLevel))
         {
            rsLevel = RainSensorLevel(Enum.ParseConstant(RainSensorLevel,resp[this.dbusRainSensorLevel]));
            if(rsLevel != null)
            {
               this.mRainSensorLevel = rsLevel;
               this.dispatchEvent(new Fiat330Event(Fiat330Event.RAINLEVEL));
            }
         }
         if(resp.hasOwnProperty(this.dbusTripBEnable))
         {
            this.mTripBEnable = resp[this.dbusTripBEnable];
            this.dispatchEvent(new Fiat330Event(Fiat330Event.TRIPBENABLE));
         }
         if(resp.hasOwnProperty(this.dbusTravelingTimeAPlus_Hour))
         {
            this.mTravellingTimeHoursA = resp[this.dbusTravelingTimeAPlus_Hour];
            this.dispatchEvent(new Fiat330Event(Fiat330Event.TRIP_A_TIME));
         }
         if(resp.hasOwnProperty(this.dbusTravellingTimeAPlus_Minute))
         {
            this.mTravellingTimeMinutesA = resp[this.dbusTravellingTimeAPlus_Minute];
            this.dispatchEvent(new Fiat330Event(Fiat330Event.TRIP_A_TIME));
         }
         if(resp.hasOwnProperty(this.dbusAverageFuelConsumptionAPlus))
         {
            this.mAverageConsumptionA = resp[this.dbusAverageFuelConsumptionAPlus];
            if(this.mAverageConsumptionA != this.AVE_FUEL_CONSUMP_SNA)
            {
               this.mAverageConsumptionA /= 10;
            }
            this.dispatchEvent(new Fiat330Event(Fiat330Event.TRIP_A_CONSUMPTION));
         }
         if(resp.hasOwnProperty(this.dbusAverageSpeedAPlus))
         {
            this.mAverageSpeedA = resp[this.dbusAverageSpeedAPlus];
            this.dispatchEvent(new Fiat330Event(Fiat330Event.TRIP_A_SPEED));
         }
         if(resp.hasOwnProperty(this.dbusPartialOdometerAPlus))
         {
            this.mDistanceA = resp[this.dbusPartialOdometerAPlus];
            if(this.mDistanceA != this.PART_ODO_SNA)
            {
               this.mDistanceA /= 10;
            }
            this.dispatchEvent(new Fiat330Event(Fiat330Event.TRIP_A_DISTANCE));
         }
         if(resp.hasOwnProperty(this.dbusTravelingTimeBPlus_Hour))
         {
            this.mTravellingTimeHoursB = resp[this.dbusTravelingTimeBPlus_Hour];
            this.dispatchEvent(new Fiat330Event(Fiat330Event.TRIP_B_TIME));
         }
         if(resp.hasOwnProperty(this.dbusTravellingTimeBPlus_Minute))
         {
            this.mTravellingTimeMinutesB = resp[this.dbusTravellingTimeBPlus_Minute];
            this.dispatchEvent(new Fiat330Event(Fiat330Event.TRIP_B_TIME));
         }
         if(resp.hasOwnProperty(this.dbusAverageFuelConsumptionBPlus))
         {
            this.mAverageConsumptionB = resp[this.dbusAverageFuelConsumptionBPlus];
            if(this.mAverageConsumptionB != this.AVE_FUEL_CONSUMP_SNA)
            {
               this.mAverageConsumptionB /= 10;
            }
            this.dispatchEvent(new Fiat330Event(Fiat330Event.TRIP_B_CONSUMPTION));
         }
         if(resp.hasOwnProperty(this.dbusAverageSpeedBPlus))
         {
            this.mAverageSpeedB = resp[this.dbusAverageSpeedBPlus];
            this.dispatchEvent(new Fiat330Event(Fiat330Event.TRIP_B_SPEED));
         }
         if(resp.hasOwnProperty(this.dbusPartialOdometerBPlus))
         {
            this.mDistanceB = resp[this.dbusPartialOdometerBPlus];
            if(this.mDistanceB != this.PART_ODO_SNA)
            {
               this.mDistanceB /= 10;
            }
            this.dispatchEvent(new Fiat330Event(Fiat330Event.TRIP_B_DISTANCE));
         }
         if(resp.hasOwnProperty(this.dbusAutonomyDistance))
         {
            this.mTotalDistance = resp[this.dbusAutonomyDistance];
            this.dispatchEvent(new Fiat330Event(Fiat330Event.TRIP_RANGE));
         }
         if(resp.hasOwnProperty(this.dbusIstantaneusFuelConsumption1))
         {
            this.mConsumption1 = resp[this.dbusIstantaneusFuelConsumption1];
            if(this.mConsumption1 != this.INST_FUEL_CONSUMP_SNA)
            {
               this.mConsumption1 *= 10;
            }
            this.dispatchEvent(new Fiat330Event(Fiat330Event.TRIP_CONSUMPTION));
         }
         if(resp.hasOwnProperty(this.dbusIstantaneusFuelConsumption2))
         {
            this.mConsumption2 = resp[this.dbusIstantaneusFuelConsumption2];
            this.dispatchEvent(new Fiat330Event(Fiat330Event.TRIP_CONSUMPTION));
         }
         if(resp.hasOwnProperty(this.dbusIstantaneusFuelConsumption3))
         {
            this.mConsumption3 = resp[this.dbusIstantaneusFuelConsumption3];
            if(this.mConsumption3 != this.INST_FUEL_CONSUMP_SNA)
            {
               this.mConsumption3 /= 10;
            }
            this.dispatchEvent(new Fiat330Event(Fiat330Event.TRIP_CONSUMPTION));
         }
      }
      
      private function sendAvailableRequest() : void
      {
         var message:String = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"" + this.dbusIdentifier + "\"}";
         this.client.send(message);
      }
   }
}

