package
{
   import com.harman.ui.ButtonBarIconOnly;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol158")]
   public dynamic class C_Button_Stop_MediaHomeScreen extends ButtonBarIconOnly
   {
      
      public function C_Button_Stop_MediaHomeScreen()
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

