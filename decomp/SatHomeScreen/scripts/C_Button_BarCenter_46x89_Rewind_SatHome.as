package
{
   import com.harman.ui.ButtonReplaySeek;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol108")]
   public dynamic class C_Button_BarCenter_46x89_Rewind_SatHome extends ButtonReplaySeek
   {
      
      public function C_Button_BarCenter_46x89_Rewind_SatHome()
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

