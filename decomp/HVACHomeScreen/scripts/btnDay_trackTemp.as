package
{
   import com.nfuzion.display.ui.HVACThumbMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol201")]
   public dynamic class btnDay_trackTemp extends HVACThumbMovieClip
   {
      
      public function btnDay_trackTemp()
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

