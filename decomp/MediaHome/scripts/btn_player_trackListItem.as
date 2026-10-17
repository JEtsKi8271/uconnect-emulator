package
{
   import com.nfuzion.display.ui.TrackListButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol82")]
   public dynamic class btn_player_trackListItem extends TrackListButtonMovieClip
   {
      
      public function btn_player_trackListItem()
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

