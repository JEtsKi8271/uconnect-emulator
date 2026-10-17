package
{
   import com.nfuzion.display.ui.MainMenuButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol161")]
   public dynamic class btn_mainMenu_controls extends MainMenuButtonMovieClip
   {
      
      public function btn_mainMenu_controls()
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

