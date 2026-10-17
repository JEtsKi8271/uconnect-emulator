package
{
   import com.nfuzion.display.ui.ButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol107")]
   public dynamic class btn_TL_movie_info_small extends ButtonMovieClip
   {
      
      public function btn_TL_movie_info_small()
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

