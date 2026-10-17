package
{
   import com.nfuzion.display.ui.ButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol140")]
   public dynamic class btn_browse_TL_movieSearch extends ButtonMovieClip
   {
      
      public function btn_browse_TL_movieSearch()
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

