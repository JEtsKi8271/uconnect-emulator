package com.nfuzion.moduleLinkAPI
{
   public interface IVehSettings extends IModule
   {
      
      function get controlFeaturesDisabled() : Boolean;
      
      function getHeatedSeat() : void;
      
      function heatedSeat(param1:String) : String;
      
      function setHeatedSeat(param1:String, param2:String) : void;
      
      function get hasHeatedSeat() : Boolean;
      
      function getVentedSeat() : void;
      
      function ventedSeat(param1:String) : String;
      
      function setVentedSeat(param1:String, param2:String) : void;
      
      function get hasVentedSeat() : Boolean;
      
      function getHeatedSteeringWheel() : void;
      
      function heatedSteeringWheel() : String;
      
      function setHeatedSteeringWheel(param1:String) : void;
      
      function get hasHeatedSteeringWheel() : Boolean;
      
      function comfortFeatureFailStatus(param1:String, param2:String = "") : Boolean;
      
      function comfortFeatureFailPopUpState(param1:String, param2:String = "") : Boolean;
      
      function getSportsMode() : void;
      
      function sportsMode() : String;
      
      function dnaStatus() : String;
      
      function setSportsMode(param1:String) : void;
      
      function get hasSportsMode() : Boolean;
      
      function getAwdMode() : void;
      
      function awdMode() : String;
      
      function setAwdMode(param1:String) : void;
      
      function get hasAwdMode() : Boolean;
      
      function getEcoMode() : void;
      
      function ecoMode() : String;
      
      function setEcoMode(param1:String) : void;
      
      function get hasEcoMode() : Boolean;
      
      function getSunShadePosition() : void;
      
      function sunShadePosition() : String;
      
      function setSunShadePosition(param1:String) : void;
      
      function get hasSunShade() : Boolean;
      
      function getOutletState() : void;
      
      function outletState() : String;
      
      function setOutletState(param1:String) : void;
      
      function get hasOutlet() : Boolean;
      
      function getScreenEnable() : void;
      
      function screenEnable() : Boolean;
      
      function setScreenEnable(param1:Boolean) : void;
      
      function getHeadrestDump() : void;
      
      function setHeadrestDump(param1:String) : void;
      
      function get headrestDump() : String;
      
      function get mirrorDimming() : Boolean;
      
      function getMirrorDimming() : void;
      
      function setMirrorDimming(param1:Boolean) : void;
      
      function getCargoCamera() : void;
      
      function setCargoCamera(param1:String) : void;
      
      function get cargoCamera() : String;
      
      function getSurroundCamera() : void;
      
      function setSurroundCamera(param1:String) : void;
      
      function get surroundCamera() : String;
      
      function getRearCamera() : void;
      
      function setRearCamera(param1:String) : void;
      
      function get rearCamera() : String;
   }
}

