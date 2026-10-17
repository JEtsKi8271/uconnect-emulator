package
{
   import com.nfuzion.display.ui.ButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol405")]
   public dynamic class btn_browse_scrollbar_up extends ButtonMovieClip
   {
      
      public function btn_browse_scrollbar_up()
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

