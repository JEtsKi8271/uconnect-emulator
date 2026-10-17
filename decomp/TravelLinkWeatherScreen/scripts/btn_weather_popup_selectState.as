package
{
   import com.nfuzion.display.ui.ButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol330")]
   public dynamic class btn_weather_popup_selectState extends ButtonMovieClip
   {
      
      public function btn_weather_popup_selectState()
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

