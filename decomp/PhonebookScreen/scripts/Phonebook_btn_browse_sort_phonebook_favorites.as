package
{
   import com.nfuzion.display.ui.ButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol150")]
   public dynamic class Phonebook_btn_browse_sort_phonebook_favorites extends ButtonMovieClip
   {
      
      public function Phonebook_btn_browse_sort_phonebook_favorites()
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

