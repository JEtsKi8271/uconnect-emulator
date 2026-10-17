package
{
   import com.nfuzion.display.ui.ListItemFuelButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol151")]
   public dynamic class btn_browse_listItem_fuel extends ListItemFuelButtonMovieClip
   {
      
      public function btn_browse_listItem_fuel()
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

