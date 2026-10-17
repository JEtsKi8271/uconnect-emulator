package
{
   import com.nfuzion.display.ui.ButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol432")]
   public dynamic class btn_commandCol_TL_weather_currentConditions extends ButtonMovieClip
   {
      
      public function btn_commandCol_TL_weather_currentConditions()
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

