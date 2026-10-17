package
{
   import com.nfuzion.display.ui.ButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol205")]
   public dynamic class btn_browse_sort_all extends ButtonMovieClip
   {
      
      public function btn_browse_sort_all()
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

