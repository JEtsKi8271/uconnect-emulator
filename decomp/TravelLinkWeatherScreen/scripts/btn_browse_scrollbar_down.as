package
{
   import com.nfuzion.display.ui.ButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol410")]
   public dynamic class btn_browse_scrollbar_down extends ButtonMovieClip
   {
      
      public function btn_browse_scrollbar_down()
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

