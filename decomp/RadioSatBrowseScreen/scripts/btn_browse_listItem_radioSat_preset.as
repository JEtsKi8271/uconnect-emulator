package
{
   import com.nfuzion.display.ui.ListItemRadioSatPresetButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol90")]
   public dynamic class btn_browse_listItem_radioSat_preset extends ListItemRadioSatPresetButtonMovieClip
   {
      
      public function btn_browse_listItem_radioSat_preset()
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

