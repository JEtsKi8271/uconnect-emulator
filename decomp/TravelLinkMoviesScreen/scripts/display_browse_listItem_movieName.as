package
{
   import com.nfuzion.display.ui.ListItemMovieNameButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol196")]
   public dynamic class display_browse_listItem_movieName extends ListItemMovieNameButtonMovieClip
   {
      
      public function display_browse_listItem_movieName()
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

