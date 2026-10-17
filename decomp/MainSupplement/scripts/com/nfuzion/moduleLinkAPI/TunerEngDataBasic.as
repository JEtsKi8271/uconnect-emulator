package com.nfuzion.moduleLinkAPI
{
   public class TunerEngDataBasic
   {
      
      public var frequency:uint = 0;
      
      public var pi:uint = 0;
      
      public var senderName:String = "";
      
      public var quality:uint = 0;
      
      public var fs:int = 0;
      
      public var ber:int = 0;
      
      public var multipath:uint = 0;
      
      public var waveband:String = "";
      
      public function TunerEngDataBasic()
      {
         super();
      }
      
      public function copyTunerEngDataBasic(value:Object) : TunerEngDataBasic
      {
         if(value.hasOwnProperty("frequency"))
         {
            this.frequency = value.frequency;
         }
         if(value.hasOwnProperty("pi"))
         {
            this.pi = value.pi;
         }
         if(value.hasOwnProperty("senderName"))
         {
            this.senderName = value.senderName;
         }
         if(value.hasOwnProperty("quality"))
         {
            this.quality = value.quality;
         }
         if(value.hasOwnProperty("fs"))
         {
            this.fs = value.fs;
         }
         if(value.hasOwnProperty("ber"))
         {
            this.ber = value.ber;
         }
         if(value.hasOwnProperty("multipath"))
         {
            this.multipath = value.multipath;
         }
         if(value.hasOwnProperty("waveband"))
         {
            this.waveband = value.waveband;
         }
         return this;
      }
   }
}

