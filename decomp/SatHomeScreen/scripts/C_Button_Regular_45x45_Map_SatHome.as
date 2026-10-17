package
{
   import com.harman.ui.ButtonBarIconAndText;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol122")]
   public dynamic class C_Button_Regular_45x45_Map_SatHome extends ButtonBarIconAndText
   {
      
      public function C_Button_Regular_45x45_Map_SatHome()
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

