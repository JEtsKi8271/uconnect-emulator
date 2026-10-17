package
{
   import com.harman.ui.ButtonBarIconAndText;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol50")]
   public dynamic class C_Button_Regular_45x45_Favorite_SatHome extends ButtonBarIconAndText
   {
      
      public function C_Button_Regular_45x45_Favorite_SatHome()
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

