package
{
   import com.nfuzion.display.ui.NoIconButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol20")]
   public dynamic class btn_TL_fuelIcon extends NoIconButtonMovieClip
   {
      
      public function btn_TL_fuelIcon()
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

