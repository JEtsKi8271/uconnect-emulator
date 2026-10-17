package
{
   import com.nfuzion.display.ui.ButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol29")]
   public dynamic class Phonebook_btn_browse_command_phonebook_alphaJump extends ButtonMovieClip
   {
      
      public function Phonebook_btn_browse_command_phonebook_alphaJump()
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

