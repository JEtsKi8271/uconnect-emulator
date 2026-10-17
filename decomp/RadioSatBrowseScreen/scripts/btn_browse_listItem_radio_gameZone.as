package
{
   import com.nfuzion.display.ui.ListItemRadioGameZoneButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol24")]
   public dynamic class btn_browse_listItem_radio_gameZone extends ListItemRadioGameZoneButtonMovieClip
   {
      
      public function btn_browse_listItem_radio_gameZone()
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

