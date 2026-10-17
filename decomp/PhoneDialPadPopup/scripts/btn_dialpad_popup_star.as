package
{
   import com.nfuzion.display.ui.DialPadNumberButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol59")]
   public dynamic class btn_dialpad_popup_star extends DialPadNumberButtonMovieClip
   {
      
      public function btn_dialpad_popup_star()
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

