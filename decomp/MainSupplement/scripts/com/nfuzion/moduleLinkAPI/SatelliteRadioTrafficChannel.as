package com.nfuzion.moduleLinkAPI
{
   public class SatelliteRadioTrafficChannel extends SatelliteRadioChannel
   {
      
      public var marketIdentifer:uint;
      
      public function SatelliteRadioTrafficChannel(ch:SatelliteRadioChannel)
      {
         super();
         updateInfo(ch);
      }
   }
}

