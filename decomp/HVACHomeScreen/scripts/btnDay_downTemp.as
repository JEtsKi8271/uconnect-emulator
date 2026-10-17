package
{
   import com.nfuzion.display.ui.ColdButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol205")]
   public dynamic class btnDay_downTemp extends ColdButtonMovieClip
   {
      
      public function btnDay_downTemp()
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

