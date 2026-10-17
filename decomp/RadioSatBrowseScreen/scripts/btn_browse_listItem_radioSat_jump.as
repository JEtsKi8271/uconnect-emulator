package
{
   import com.nfuzion.display.ui.ListItemRadioSatJumpButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol167")]
   public dynamic class btn_browse_listItem_radioSat_jump extends ListItemRadioSatJumpButtonMovieClip
   {
      
      public function btn_browse_listItem_radioSat_jump()
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

