package com.harman.navigation.Controller.NDR
{
   import flash.events.EventDispatcher;
   
   public class NDRControlImpl extends EventDispatcher
   {
      
      private static var mNDRControlInstance:NDRControl;
      
      public function NDRControlImpl()
      {
         super();
      }
      
      public static function create() : NDRControl
      {
         if(mNDRControlInstance == null)
         {
            return mNDRControlInstance = new NDRControl();
         }
         return mNDRControlInstance;
      }
      
      public static function get instance() : NDRControl
      {
         return mNDRControlInstance;
      }
   }
}

