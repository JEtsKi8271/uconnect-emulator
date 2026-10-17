package
{
   import com.nfuzion.display.ui.ListItemMovieTheaterButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol204")]
   public dynamic class display_browse_listItem_movieTheater_group extends ListItemMovieTheaterButtonMovieClip
   {
      
      public function display_browse_listItem_movieTheater_group()
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

