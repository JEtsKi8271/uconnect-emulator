package
{
   import com.nfuzion.display.ui.TeamInfoButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol99")]
   public dynamic class btn_TL_sports_team1Info extends TeamInfoButtonMovieClip
   {
      
      public function btn_TL_sports_team1Info()
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

