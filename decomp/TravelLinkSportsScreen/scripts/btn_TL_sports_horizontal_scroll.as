package
{
   import com.nfuzion.display.ui.ButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol131")]
   public dynamic class btn_TL_sports_horizontal_scroll extends ButtonMovieClip
   {
      
      public function btn_TL_sports_horizontal_scroll()
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

