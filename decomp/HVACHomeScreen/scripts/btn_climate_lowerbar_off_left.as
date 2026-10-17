package
{
   import com.nfuzion.display.ui.ButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol246")]
   public dynamic class btn_climate_lowerbar_off_left extends ButtonMovieClip
   {
      
      public function btn_climate_lowerbar_off_left()
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

