package
{
   import com.nfuzion.display.ui.ClimateFanSpeedMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol96")]
   public dynamic class btn_climate_fanSpeed extends ClimateFanSpeedMovieClip
   {
      
      public function btn_climate_fanSpeed()
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

