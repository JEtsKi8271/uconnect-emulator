package
{
   import com.nfuzion.display.ui.ButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol93")]
   public dynamic class btn_TL_movie_additionalTimes_info extends ButtonMovieClip
   {
      
      public function btn_TL_movie_additionalTimes_info()
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

