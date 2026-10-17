package
{
   import com.harman.ui.ButtonBarIconOnly;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol15")]
   public dynamic class C_Button_BarLeft_46x88_PlayAndPause_SatHome extends ButtonBarIconOnly
   {
      
      public function C_Button_BarLeft_46x88_PlayAndPause_SatHome()
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

