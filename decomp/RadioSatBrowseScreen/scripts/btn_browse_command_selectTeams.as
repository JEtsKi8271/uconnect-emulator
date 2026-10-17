package
{
   import com.nfuzion.display.ui.ButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol138")]
   public dynamic class btn_browse_command_selectTeams extends ButtonMovieClip
   {
      
      public function btn_browse_command_selectTeams()
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

