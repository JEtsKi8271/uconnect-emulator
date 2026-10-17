package
{
   import com.nfuzion.display.ui.ButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol104")]
   public dynamic class btn_audioSettings_auxVolume_minus extends ButtonMovieClip
   {
      
      public function btn_audioSettings_auxVolume_minus()
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

