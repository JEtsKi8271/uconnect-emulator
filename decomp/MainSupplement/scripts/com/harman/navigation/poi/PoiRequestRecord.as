package com.harman.navigation.poi
{
   public class PoiRequestRecord
   {
      
      private static var idCounter:int = 0;
      
      private var _mesg:String = "";
      
      private var _id:int = 0;
      
      public function PoiRequestRecord(msg:String)
      {
         super();
         this._mesg = msg;
         ++idCounter;
         this._id = idCounter;
      }
      
      public function get mesg() : String
      {
         return this._mesg;
      }
      
      public function get id() : int
      {
         return this._id;
      }
   }
}

