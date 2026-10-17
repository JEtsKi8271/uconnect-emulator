package
{
   import com.harman.ui.ButtonBarIconOnly;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol143")]
   public dynamic class C_Button_PlayPause_MediaHomeScreen extends ButtonBarIconOnly
   {
      
      public function C_Button_PlayPause_MediaHomeScreen()
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

