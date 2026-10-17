package
{
   import com.nfuzion.display.ui.ButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol198")]
   public dynamic class btn_browse_sort_favorites extends ButtonMovieClip
   {
      
      public function btn_browse_sort_favorites()
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

