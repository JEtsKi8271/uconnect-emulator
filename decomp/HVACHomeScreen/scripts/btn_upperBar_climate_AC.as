package
{
   import com.nfuzion.display.ui.ButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol273")]
   public dynamic class btn_upperBar_climate_AC extends ButtonMovieClip
   {
      
      public function btn_upperBar_climate_AC()
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

