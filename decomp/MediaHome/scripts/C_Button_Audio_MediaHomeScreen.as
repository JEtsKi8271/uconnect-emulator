package
{
   import com.harman.ui.ButtonBarRegular;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol130")]
   public dynamic class C_Button_Audio_MediaHomeScreen extends ButtonBarRegular
   {
      
      public function C_Button_Audio_MediaHomeScreen()
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

