package com.nfuzion.moduleLinkAPI
{
   public interface I330Serv extends IModule
   {
      
      function get_tempUnit() : void;
      
      function get tempUnit() : String;
      
      function set_tempUnit(param1:String) : void;
      
      function get_distanceUnit() : void;
      
      function get distanceUnit() : String;
      
      function set_distanceUnit(param1:String) : void;
      
      function get_consumptionUnit() : void;
      
      function get consumptionUnit() : String;
      
      function set_consumptionUnit(param1:String) : void;
      
      function get_afsEnable() : void;
      
      function get afsEnable() : Boolean;
      
      function set_afsEnable(param1:Boolean) : void;
      
      function get_speedlockEnable() : void;
      
      function get speedlockEnable() : String;
      
      function set_speedlockEnable(param1:String) : void;
      
      function get_rainsensorLevel() : void;
      
      function get rainsensorLevel() : RainSensorLevel;
      
      function set_rainsensorLevel(param1:RainSensorLevel) : void;
      
      function get tripbEnable() : String;
      
      function set_tripbEnable(param1:String) : void;
      
      function get_autoSwitch() : void;
      
      function get autoSwitch() : String;
      
      function set_autoSwitch(param1:String) : void;
      
      function get_totalDistance() : void;
      
      function get totalDistance() : String;
      
      function get_totalConsumption() : void;
      
      function get totalConsumption() : String;
      
      function get_travellingTimeA() : void;
      
      function get travellingTimeA() : String;
      
      function get_averageConsumptionA() : void;
      
      function get averageConsumptionA() : String;
      
      function get_averageSpeedA() : void;
      
      function get averageSpeedA() : String;
      
      function get_distanceA() : void;
      
      function get distanceA() : String;
      
      function get_travellingTimeB() : void;
      
      function get travellingTimeB() : String;
      
      function get_averageConsumptionB() : void;
      
      function get averageConsumptionB() : String;
      
      function get_averageSpeedB() : void;
      
      function get averageSpeedB() : String;
      
      function get_distanceB() : void;
      
      function get distanceB() : String;
   }
}

