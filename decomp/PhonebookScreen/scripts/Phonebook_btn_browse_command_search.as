package
{
   import com.nfuzion.display.ui.ButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol111")]
   public dynamic class Phonebook_btn_browse_command_search extends ButtonMovieClip
   {
      
      public function Phonebook_btn_browse_command_search()
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

