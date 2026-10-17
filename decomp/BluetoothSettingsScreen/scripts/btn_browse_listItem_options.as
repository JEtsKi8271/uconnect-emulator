package
{
   import com.nfuzion.display.ui.ButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol93")]
   public dynamic class btn_browse_listItem_options extends ButtonMovieClip
   {
      
      public function btn_browse_listItem_options()
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

