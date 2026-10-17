package ScreenMediaHome_fla_fla
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol122")]
   public dynamic class display_upperBar_player_progress_41 extends MovieClip
   {
      
      public var playhead_scroller:MovieClip;
      
      public var songnumber:TextField;
      
      public var timeduration:TextField;
      
      public function display_upperBar_player_progress_41()
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

