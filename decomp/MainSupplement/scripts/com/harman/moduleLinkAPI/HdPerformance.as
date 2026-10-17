package com.harman.moduleLinkAPI
{
   public class HdPerformance
   {
      
      public var SIS_FRAME_ACQUISITION_TIME:int = 0;
      
      public var AUDIO_ACQUISITION_TIME:int = 0;
      
      public var SIGNAL_TO_NOISE_RATIO:int = 0;
      
      public var ANALOG_TIME:int = 0;
      
      public var BLEND_COUNT:int = 0;
      
      public function HdPerformance()
      {
         super();
      }
      
      public function copyPerformance(value:Object) : HdPerformance
      {
         this.SIS_FRAME_ACQUISITION_TIME = value.SISFrameAcquisitionTime;
         this.AUDIO_ACQUISITION_TIME = value.audioAcquisitionTime;
         this.SIGNAL_TO_NOISE_RATIO = value.signalToNoiseRatio;
         this.ANALOG_TIME = value.analogTime;
         this.BLEND_COUNT = value.blendCount;
         return this;
      }
   }
}

