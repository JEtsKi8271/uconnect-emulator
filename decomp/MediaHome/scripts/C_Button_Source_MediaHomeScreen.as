package
{
   import com.harman.ui.ButtonMediaSource;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol65")]
   public dynamic class C_Button_Source_MediaHomeScreen extends ButtonMediaSource
   {
      
      public function C_Button_Source_MediaHomeScreen()
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

