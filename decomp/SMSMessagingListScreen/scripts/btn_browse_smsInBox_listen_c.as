package
{
   import com.nfuzion.display.ui.ButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol15")]
   public dynamic class btn_browse_smsInBox_listen_c extends ButtonMovieClip
   {
      
      public function btn_browse_smsInBox_listen_c()
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

