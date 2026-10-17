package
{
   import com.nfuzion.display.ui.AlertNoneButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol65")]
   public dynamic class btn_keypad_popup_done extends AlertNoneButtonMovieClip
   {
      
      public function btn_keypad_popup_done()
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

