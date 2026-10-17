package
{
   import com.nfuzion.display.ui.ListItemPlayerBrowseButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol48")]
   public dynamic class btn_browse_listItem_playerBrowse extends ListItemPlayerBrowseButtonMovieClip
   {
      
      public function btn_browse_listItem_playerBrowse()
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

