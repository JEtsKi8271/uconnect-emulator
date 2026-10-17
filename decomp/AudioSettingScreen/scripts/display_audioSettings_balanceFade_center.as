package
{
   import com.nfuzion.display.ui.ButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol220")]
   public dynamic class display_audioSettings_balanceFade_center extends ButtonMovieClip
   {
      
      public function display_audioSettings_balanceFade_center()
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

