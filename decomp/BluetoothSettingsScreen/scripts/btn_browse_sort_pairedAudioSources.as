package
{
   import com.nfuzion.display.ui.ButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol101")]
   public dynamic class btn_browse_sort_pairedAudioSources extends ButtonMovieClip
   {
      
      public function btn_browse_sort_pairedAudioSources()
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

