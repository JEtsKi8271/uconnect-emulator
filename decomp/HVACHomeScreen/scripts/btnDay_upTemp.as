package
{
   import com.nfuzion.display.ui.HeatButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol209")]
   public dynamic class btnDay_upTemp extends HeatButtonMovieClip
   {
      
      public function btnDay_upTemp()
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

