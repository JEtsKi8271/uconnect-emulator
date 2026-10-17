package
{
   import com.nfuzion.display.ui.ButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol58")]
   public dynamic class btn_browse_scrollbar_down extends ButtonMovieClip
   {
      
      public function btn_browse_scrollbar_down()
      {
         super();
         addFrameScript(0,this.frame1,9,this.frame10,19,this.frame20,29,this.frame30);
      }
      
      internal function frame1() : *
      {
         stop();
         icon.gotoAndStop(1);
      }
      
      internal function frame10() : *
      {
         icon.gotoAndStop(1);
      }
      
      internal function frame20() : *
      {
         icon.gotoAndStop(1);
      }
      
      internal function frame30() : *
      {
         icon.gotoAndStop(4);
      }
   }
}

