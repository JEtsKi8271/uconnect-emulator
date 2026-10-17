package
{
   import com.nfuzion.display.ui.AlertWarningButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol32")]
   public dynamic class Phonebook_btn_browse_command_cancel extends AlertWarningButtonMovieClip
   {
      
      public function Phonebook_btn_browse_command_cancel()
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

