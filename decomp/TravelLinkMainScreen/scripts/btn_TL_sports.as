package
{
   import com.nfuzion.display.ui.NoIconButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol24")]
   public dynamic class btn_TL_sports extends NoIconButtonMovieClip
   {
      
      public function btn_TL_sports()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
         stop();
      }
   }
}

