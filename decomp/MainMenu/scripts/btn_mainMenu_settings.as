package
{
   import com.nfuzion.display.ui.MainMenuButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol179")]
   public dynamic class btn_mainMenu_settings extends MainMenuButtonMovieClip
   {
      
      public function btn_mainMenu_settings()
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

