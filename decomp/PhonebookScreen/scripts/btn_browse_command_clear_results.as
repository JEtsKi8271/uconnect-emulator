package
{
   import com.nfuzion.display.ui.ButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol80")]
   public dynamic class btn_browse_command_clear_results extends ButtonMovieClip
   {
      
      public function btn_browse_command_clear_results()
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

