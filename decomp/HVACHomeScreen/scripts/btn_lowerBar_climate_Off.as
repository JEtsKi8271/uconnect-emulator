package
{
   import com.nfuzion.display.ui.ButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol242")]
   public dynamic class btn_lowerBar_climate_Off extends ButtonMovieClip
   {
      
      public function btn_lowerBar_climate_Off()
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

