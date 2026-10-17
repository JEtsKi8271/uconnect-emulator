package
{
   import com.nfuzion.display.ui.ListItemRadioSatAllButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol82")]
   public dynamic class btn_browse_listItem_radioSat_all extends ListItemRadioSatAllButtonMovieClip
   {
      
      public function btn_browse_listItem_radioSat_all()
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

