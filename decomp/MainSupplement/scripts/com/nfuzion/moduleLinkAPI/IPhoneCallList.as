package com.nfuzion.moduleLinkAPI
{
   public interface IPhoneCallList extends IModule
   {
      
      function initBt(param1:IBluetooth) : void;
      
      function getAllCallsCount() : void;
      
      function get allCallsCount() : int;
      
      function getDialedCallsCount() : void;
      
      function get dialedCallsCount() : int;
      
      function getReceivedCallsCount() : void;
      
      function get receivedCallsCount() : int;
      
      function getMissedCallsCount() : void;
      
      function get missedCallsCount() : int;
      
      function get recentCallsAvailable() : Boolean;
      
      function requestCallList(param1:String, param2:uint, param3:uint) : void;
      
      function set blockedCallCount(param1:uint) : void;
      
      function get blockedCallCount() : uint;
      
      function set blockedCallNumber(param1:String) : void;
      
      function get blockedCallNumber() : String;
   }
}

