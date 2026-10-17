package
{
   import com.nfuzion.display.ui.ButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol75")]
   public dynamic class btn_upperBar_climate_Defrost_rear extends ButtonMovieClip
   {
      
      public function btn_upperBar_climate_Defrost_rear()
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

