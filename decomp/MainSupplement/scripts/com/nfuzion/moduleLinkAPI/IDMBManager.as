package com.nfuzion.moduleLinkAPI
{
   public interface IDMBManager extends IModule
   {
      
      function dmbOn() : void;
      
      function dmbOff() : void;
      
      function dmbTune(param1:int) : void;
      
      function dmbScan(param1:int) : void;
      
      function dmbStatus() : void;
      
      function dmbVersion() : void;
      
      function dmbUpdate() : void;
      
      function dmbDebug() : void;
      
      function dmbCheckInit() : void;
      
      function getDMBOperable() : Boolean;
      
      function get ActiveChannelIndex() : int;
   }
}

