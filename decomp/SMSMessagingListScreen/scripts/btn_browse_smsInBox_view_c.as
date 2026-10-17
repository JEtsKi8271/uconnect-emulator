package
{
   import com.nfuzion.display.ui.ButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol111")]
   public dynamic class btn_browse_smsInBox_view_c extends ButtonMovieClip
   {
      
      public function btn_browse_smsInBox_view_c()
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

