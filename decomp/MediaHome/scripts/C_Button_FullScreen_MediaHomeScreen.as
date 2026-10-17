package
{
   import com.harman.ui.ButtonSplitSourceAlwaysDispatchEvent;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol26")]
   public dynamic class C_Button_FullScreen_MediaHomeScreen extends ButtonSplitSourceAlwaysDispatchEvent
   {
      
      public function C_Button_FullScreen_MediaHomeScreen()
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

