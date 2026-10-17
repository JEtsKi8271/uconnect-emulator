package
{
   import com.nfuzion.display.ui.ButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol94")]
   public dynamic class btn_player_track_up extends ButtonMovieClip
   {
      
      public function btn_player_track_up()
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

