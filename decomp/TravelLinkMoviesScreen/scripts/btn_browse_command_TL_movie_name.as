package
{
   import com.nfuzion.display.ui.ButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol179")]
   public dynamic class btn_browse_command_TL_movie_name extends ButtonMovieClip
   {
      
      public function btn_browse_command_TL_movie_name()
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

