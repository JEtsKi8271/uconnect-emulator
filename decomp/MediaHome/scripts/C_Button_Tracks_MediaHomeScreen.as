package
{
   import com.harman.ui.ButtonSplitSource;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol35")]
   public dynamic class C_Button_Tracks_MediaHomeScreen extends ButtonSplitSource
   {
      
      public function C_Button_Tracks_MediaHomeScreen()
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

