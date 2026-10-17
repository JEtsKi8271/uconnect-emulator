package
{
   import com.nfuzion.display.ui.ButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol113")]
   public dynamic class btn_titleBar_close extends ButtonMovieClip
   {
      
      public function btn_titleBar_close()
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

