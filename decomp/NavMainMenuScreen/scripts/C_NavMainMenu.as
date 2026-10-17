package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol52")]
   public dynamic class C_NavMainMenu extends MovieClip
   {
      
      public var emergency_button:C_Button_NavMainMenu_Emergency;
      
      public var detour_button:C_Button_BarCenter_46x190;
      
      public var viewmap_button:C_Button_NavMainMenu_ViewMap;
      
      public var information_button:C_Button_NavMainMenu_Information;
      
      public var settings_button:C_Button_BarLeft_46x122;
      
      public var live_information_button:C_Button_NavMainMenu_Live_Information;
      
      public var whereto_button:C_Button_NavMainMenu_WhereTo;
      
      public var repeat_button:C_Button_BarRight_46x123;
      
      public var stop_button:C_Button_BarCenter_46x190;
      
      public function C_NavMainMenu()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

