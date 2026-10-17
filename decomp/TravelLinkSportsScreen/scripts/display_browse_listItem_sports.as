package
{
   import com.nfuzion.display.ui.ListButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol42")]
   public dynamic class display_browse_listItem_sports extends ListButtonMovieClip
   {
      
      public function display_browse_listItem_sports()
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

