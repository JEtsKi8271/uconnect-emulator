package
{
   import com.nfuzion.display.ui.ListItemRadioSatJumpHeaderButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol42")]
   public dynamic class btn_browse_listItem_radioSat_featured extends ListItemRadioSatJumpHeaderButtonMovieClip
   {
      
      public function btn_browse_listItem_radioSat_featured()
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

