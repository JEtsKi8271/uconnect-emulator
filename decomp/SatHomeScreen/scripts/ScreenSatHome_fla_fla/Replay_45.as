package ScreenSatHome_fla_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol116")]
   public dynamic class Replay_45 extends MovieClip
   {
      
      public var live_button:C_Button_BarRight_46x89_Live_SatHome;
      
      public var playPause_button:C_Button_BarLeft_46x88_PlayAndPause_SatHome;
      
      public var replay_scroller:MovieClip;
      
      public var seekBackward_button:C_Button_BarCenter_46x89_Rewind_SatHome;
      
      public var seekForward_button:C_Button_BarCenter_46x89_FastForward_SatHome;
      
      public function Replay_45()
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

