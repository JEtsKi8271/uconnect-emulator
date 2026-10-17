package
{
   import com.nfuzion.display.ui.DialPadNumberButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol25")]
   public dynamic class btn_dialpad_popup_2 extends DialPadNumberButtonMovieClip
   {
      
      public function btn_dialpad_popup_2()
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

