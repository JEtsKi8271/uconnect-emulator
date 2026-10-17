package
{
   import com.nfuzion.display.ui.CallButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol63")]
   public dynamic class btn_dialPad_phone_call extends CallButtonMovieClip
   {
      
      public function btn_dialPad_phone_call()
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

