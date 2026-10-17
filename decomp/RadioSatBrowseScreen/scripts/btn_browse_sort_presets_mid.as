package
{
   import com.nfuzion.display.ui.ButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol202")]
   public dynamic class btn_browse_sort_presets_mid extends ButtonMovieClip
   {
      
      public function btn_browse_sort_presets_mid()
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

