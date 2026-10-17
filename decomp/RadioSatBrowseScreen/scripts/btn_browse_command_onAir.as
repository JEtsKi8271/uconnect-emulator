package
{
   import com.nfuzion.display.ui.ButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol98")]
   public dynamic class btn_browse_command_onAir extends ButtonMovieClip
   {
      
      public function btn_browse_command_onAir()
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

