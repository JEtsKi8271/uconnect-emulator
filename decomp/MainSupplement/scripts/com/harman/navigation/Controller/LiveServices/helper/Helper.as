package com.harman.navigation.Controller.LiveServices.helper
{
   import com.harman.navigation.Controller.LiveServices.LiveServicesController;
   
   public class Helper
   {
      
      protected static var mController:LiveServicesController = null;
      
      public function Helper()
      {
         super();
      }
      
      public static function setController(ctrl:LiveServicesController) : void
      {
         mController = ctrl;
      }
      
      protected function sendEvent(e:String) : void
      {
         mController.sendEvent(e);
      }
   }
}

