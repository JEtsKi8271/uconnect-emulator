package
{
   import com.nfuzion.display.ui.CloseButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol105")]
   public dynamic class btn_popup_close_sq60 extends CloseButtonMovieClip
   {
      
      public function btn_popup_close_sq60()
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

