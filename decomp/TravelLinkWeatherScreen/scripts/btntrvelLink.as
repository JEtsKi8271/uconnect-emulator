package
{
   import com.nfuzion.display.ui.NoIconButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol366")]
   public dynamic class btntrvelLink extends NoIconButtonMovieClip
   {
      
      public function btntrvelLink()
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

