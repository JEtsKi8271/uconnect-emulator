package
{
   import com.nfuzion.display.ui.ButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol328")]
   public dynamic class btn_weather_popup_weatherStation extends ButtonMovieClip
   {
      
      public function btn_weather_popup_weatherStation()
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

