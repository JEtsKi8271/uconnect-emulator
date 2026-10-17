package
{
   import com.nfuzion.display.ui.ButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol121")]
   public dynamic class Phonebook_btn_browse_listItem_phonebook_options extends ButtonMovieClip
   {
      
      public function Phonebook_btn_browse_listItem_phonebook_options()
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

